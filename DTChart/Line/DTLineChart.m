//
//  DTLineChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTLineChart.h"
#import "DTChartLabel.h"
#import "DTChartData.h"
#import "DTLine.h"


@interface DTLineChart ()

@property(nonatomic) NSMutableArray<DTLine *> *valueLines;
@property(nonatomic) NSIndexPath *prevSelectIndex;


@end

@implementation DTLineChart

/**
 * 触摸点最大的偏移距离
 */
static CGFloat const TouchOffsetMaxDistance = 10;


- (void)initial {
    [super initial];

    _xAxisAlignGrid = NO;
    self.userInteractionEnabled = NO;
}

- (NSMutableArray<DTLine *> *)valueLines {
    if (!_valueLines) {
        _valueLines = [[NSMutableArray<DTLine *> alloc] init];
    }
    return _valueLines;
}

- (NSIndexPath *)prevSelectIndex {
    if (!_prevSelectIndex) {
        _prevSelectIndex = [NSIndexPath indexPathForItem:-1 inSection:-1];
    }
    return _prevSelectIndex;
}


#pragma mark - private method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchKeyPoint:touches isMoving:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchKeyPoint:touches isMoving:YES];
}


- (void)touchKeyPoint:(NSSet *)touches isMoving:(BOOL)moving {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];

    CGFloat minDistance = -100;
    NSInteger n1 = -1;
    NSInteger n2 = -1;


    for (NSUInteger i = 0; i < self.multiData.count; ++i) {
        DTChartSingleData *sData = self.multiData[i];

        CGRect bound = CGRectMake(sData.itemValues.firstObject.position.x - TouchOffsetMaxDistance,
                sData.itemValues[sData.maxValueIndex].position.y - 2 * TouchOffsetMaxDistance,
                sData.itemValues.lastObject.position.x - sData.itemValues.firstObject.position.x + 2 * TouchOffsetMaxDistance,
                sData.itemValues[sData.minValueIndex].position.y - sData.itemValues[sData.maxValueIndex].position.y + 2 * TouchOffsetMaxDistance);

        // 不在这个区域，直接忽略
        if (!CGRectContainsPoint(bound, touchPoint)) {
            continue;
        }

        for (NSUInteger n = 0; n < sData.itemValues.count; ++n) {
            DTChartItemData *itemData = sData.itemValues[n];

            CGFloat distance = CGPointGetDistance(touchPoint, itemData.position);
            if (distance < TouchOffsetMaxDistance) {
                if (minDistance == -100) {

                    minDistance = distance;
                    n1 = i;
                    n2 = n;
                } else if (distance < minDistance) {
                    minDistance = distance;
                    n1 = i;
                    n2 = n;
                }

            }

        }
    }

    // 过滤掉手指移动造成的重复点选择
    if (moving) {
        if ((n1 >= 0 && n2 >= 0)
                && (self.prevSelectIndex.section != n1 || self.prevSelectIndex.item != n2)
                && self.lineChartTouchBlock) {

            self.prevSelectIndex = [NSIndexPath indexPathForItem:n2 inSection:n1];

            DTChartItemData *itemData = self.multiData[(NSUInteger) n1].itemValues[(NSUInteger) n2];
            self.lineChartTouchBlock((NSUInteger) n1, (NSUInteger) n2, itemData);
        }
    } else {
        if ((n1 >= 0 && n2 >= 0)
                && self.lineChartTouchBlock) {

            self.prevSelectIndex = [NSIndexPath indexPathForItem:n2 inSection:n1];

            DTChartItemData *itemData = self.multiData[(NSUInteger) n1].itemValues[(NSUInteger) n2];
            self.lineChartTouchBlock((NSUInteger) n1, (NSUInteger) n2, itemData);
        }
    }
}

/**
 * 创建单个数据对象的折线路径
 * @param singleData 单个数据对象
 * @param xMaxData x轴标签最大值
 * @param xMinData x轴标签最小值
 * @param yMaxData y轴标签最大值
 * @param yMinData y轴标签最小值
 * @return 路径
 */
- (UIBezierPath *)generateItemPath:(DTChartSingleData *)singleData
                     xAxisMaxVaule:(DTAxisLabelData *)xMaxData
                     xAxisMinValue:(DTAxisLabelData *)xMinData
                     yAxisMaxVaule:(DTAxisLabelData *)yMaxData
                     yAxisMinValue:(DTAxisLabelData *)yMinData {

    UIBezierPath *path = nil;

    for (NSUInteger i = 0; i < singleData.itemValues.count; ++i) {
        DTChartItemData *itemData = singleData.itemValues[i];


        CGFloat ratioPosition = 0;
        if (xMaxData.value != xMinData.value) {
            ratioPosition = (xMaxData.axisPosition - xMinData.axisPosition) * (itemData.itemValue.x - xMinData.value) / (xMaxData.value - xMinData.value);
        }
        CGFloat x = self.coordinateAxisCellWidth * (xMinData.axisPosition + ratioPosition);
        CGFloat y = self.coordinateAxisCellWidth * (self.yAxisCellCount - ((itemData.itemValue.y - yMinData.value) / (yMaxData.value - yMinData.value)) * yMaxData.axisPosition);
        itemData.position = CGPointMake(x, y);
        DTLog(@"position = %@", NSStringFromCGPoint(itemData.position));

        if (path) {
            [path addLineToPoint:itemData.position];
        } else {
            path = [UIBezierPath bezierPath];
            [path moveToPoint:itemData.position];
        }

    }

    return path;
}


#pragma mark - override

/**
 * 清除坐标系里的轴标签和值线条
 */
- (void)clearChartContent {

    NSArray<CALayer *> *layers = [self.contentView.layer.sublayers copy];
    [layers enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTLine class]]) {
            DTLine *line = (DTLine *) obj;
            [line removeEdgePoint];
            [line removeFromSuperlayer];
        }
    }];

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            [obj removeFromSuperview];
        }
    }];
}


- (BOOL)drawXAxisLabels {
    if (![super drawXAxisLabels]) {
        return NO;
    }

    // 第一个单元格空余出来
    CGFloat sectionCellCount = 0;
    if (self.xAxisLabelDatas.count == 1) {
        sectionCellCount = self.xAxisCellCount / 2 + 1;
    } else {
        if (self.xAxisAlignGrid) {
            sectionCellCount = (self.xAxisCellCount - 1) * 1 / (self.xAxisLabelDatas.count - 1);
        } else {
            sectionCellCount = (self.xAxisCellCount - 1) * 1.0f / (self.xAxisLabelDatas.count - 1);
        }
    }


    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];

        // 每个label位于section内最后一个单元格线上，所有label在x轴上整体居左
//        if (self.xAxisLabelDatas.count == 1) {
//            data.axisPosition = 1 + (self.xAxisCellCount - 1 - (self.xAxisLabelDatas.count - 1) * sectionCellCount) / 2;
//        } else {
//            data.axisPosition = sectionCellCount * i + 1;
//        }

        // 每个label位于section内最后一个单元格线上，所有label在x轴上整体居中
        data.axisPosition = sectionCellCount * i + 1 + (self.xAxisCellCount - 1 - (self.xAxisLabelDatas.count - 1) * sectionCellCount) / 2;

        if (data.hidden) {
            continue;
        }

        DTChartLabel *xLabel = [DTChartLabel chartLabel];
        if (self.xAxisLabelColor) {
            xLabel.textColor = self.xAxisLabelColor;
        }
        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.text = data.title;

        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: xLabel.font}];

        CGFloat x = (self.coordinateAxisInsets.left + data.axisPosition) * self.coordinateAxisCellWidth - size.width / 2;
        CGFloat y = CGRectGetMaxY(self.contentView.frame);
        if (size.height < self.coordinateAxisCellWidth) {
            y += (self.coordinateAxisCellWidth - size.height) / 2;
        }


        xLabel.frame = (CGRect) {CGPointMake(x, y), size};


        [self addSubview:xLabel];
    }

    return YES;
}


- (BOOL)drawYAxisLabels {
    if (self.yAxisLabelDatas.count < 2) {
        DTLog(@"Error: y轴标签数量小于2");
        return NO;
    }

    NSUInteger sectionCellCount = self.yAxisCellCount / (self.yAxisLabelDatas.count - 1);


    for (NSUInteger i = 0; i < self.yAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.yAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i;

        if (data.hidden) {
            continue;
        }

        DTChartLabel *yLabel = [DTChartLabel chartLabel];
        if (self.yAxisLabelColor) {
            yLabel.textColor = self.yAxisLabelColor;
        }

        yLabel.textAlignment = NSTextAlignmentRight;
        yLabel.text = data.title;

        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: yLabel.font}];

        CGFloat x = CGRectGetMinX(self.contentView.frame) - size.width;
        CGFloat y = (self.coordinateAxisInsets.top + self.yAxisCellCount - data.axisPosition) * self.coordinateAxisCellWidth - size.height / 2;


        yLabel.frame = (CGRect) {CGPointMake(x, y), size};


        [self addSubview:yLabel];
    }

    return YES;
}


- (void)drawValues {

    [self.valueLines removeAllObjects];

    DTAxisLabelData *yMaxData = self.yAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.yAxisLabelDatas.firstObject;

    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

    for (NSUInteger n = 0; n < self.multiData.count; ++n) {
        DTChartSingleData *singleData = self.multiData[n];

        UIBezierPath *path = [self generateItemPath:singleData
                                      xAxisMaxVaule:xMaxData
                                      xAxisMinValue:xMinData
                                      yAxisMaxVaule:yMaxData
                                      yAxisMinValue:yMinData];

        if (path) {

            DTLine *line = [DTLine line:DTLinePointTypeCircle];
            line.linePath = path;
            line.singleData = singleData;
            [self.valueLines addObject:line];
            [self.contentView.layer addSublayer:line];


            if (self.isShowAnimation) {
                [line startAppearAnimation];
                [line drawEdgePoint:0.8];
            } else {
                [line drawEdgePoint:0];
            }
        }

    }
}


- (void)drawChart {

    [super drawChart];

}

- (void)reloadChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
    [super reloadChartItems:indexes withAnimation:animation];

    DTAxisLabelData *yMaxData = self.yAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.yAxisLabelDatas.firstObject;

    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

    for (NSUInteger n = 0; n < self.multiData.count; ++n) {

        if (![indexes containsIndex:n]) {
            continue;
        }

        DTChartSingleData *singleData = self.multiData[n];

        UIBezierPath *path = [self generateItemPath:singleData
                                      xAxisMaxVaule:xMaxData
                                      xAxisMinValue:xMinData
                                      yAxisMaxVaule:yMaxData
                                      yAxisMinValue:yMinData];

        if (path) {

            DTLine *line = self.valueLines[n];
            line.singleData = singleData;

            if (animation) {
                [line removeEdgePoint];
                [line startPathUpdateAnimation:path];
                [line drawEdgePoint:0.3];
            } else {
                [line removeEdgePoint];
                line.linePath = path;
                [line drawEdgePoint:0];
            }
        }

    }

}

- (void)insertChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
    [super insertChartItems:indexes withAnimation:animation];


    DTAxisLabelData *yMaxData = self.yAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.yAxisLabelDatas.firstObject;

    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

    for (NSUInteger n = 0; n < self.multiData.count; ++n) {
        if (![indexes containsIndex:n]) {
            continue;
        }

        DTChartSingleData *singleData = self.multiData[n];

        UIBezierPath *path = [self generateItemPath:singleData
                                      xAxisMaxVaule:xMaxData
                                      xAxisMinValue:xMinData
                                      yAxisMaxVaule:yMaxData
                                      yAxisMinValue:yMinData];

        if (path) {

            DTLine *line = [DTLine line:DTLinePointTypeCircle];
            line.singleData = singleData;
            line.linePath = path;
            if (self.valueLines.count >= n) {
                [self.valueLines insertObject:line atIndex:n];
                [self.contentView.layer insertSublayer:line atIndex:(unsigned int) n];
            } else {
                [self.valueLines addObject:line];
                [self.contentView.layer addSublayer:line];
            }

            if (animation) {
                [line startAppearAnimation];
                [line drawEdgePoint:0.8];
            } else {
                [line drawEdgePoint:0];
            }
        }

    }

}

- (void)deleteChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
    [super deleteChartItems:indexes withAnimation:animation];

    [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        DTLog(@"enum index = %@", @(index));
        DTLine *line = self.valueLines[index];
        [line removeEdgePoint];

        if (animation) {
            [line startDisappearAnimation];
        } else {
            [line removeFromSuperlayer];
        }
    }];

    [self.valueLines removeObjectsAtIndexes:indexes];
}

@end
