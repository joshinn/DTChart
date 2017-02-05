//
//  DTFillChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTFillChart.h"
#import "DTChartLabel.h"
#import "DTFillLayer.h"


@interface DTFillChart ()

@property(nonatomic) NSMutableArray<DTFillLayer *> *fillLayers;

@property(nonatomic) NSInteger prevTouchedPathIndex;
@property(nonatomic) NSInteger prevTouchedPointIndex;

@end

@implementation DTFillChart

/**
 * 触摸点最大的偏移距离
 */
static CGFloat const TouchOffsetMaxDistance = 10;

- (void)initial {
    [super initial];

    _beginRangeIndex = 0;
    _endRangeIndex = NSUIntegerMax;
    _xAxisAlignGrid = NO;

    _prevTouchedPathIndex = -1;
    _prevTouchedPointIndex = -1;
}

- (NSMutableArray<DTFillLayer *> *)fillLayers {
    if (!_fillLayers) {
        _fillLayers = [NSMutableArray array];
    }
    return _fillLayers;
}

#pragma mark - private method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchKeyPoint:touches isMoving:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchKeyPoint:touches isMoving:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.prevTouchedPathIndex >= 0) {
        DTFillLayer *prevFillLayer = self.fillLayers[(NSUInteger) self.prevTouchedPathIndex];
        prevFillLayer.highLighted = NO;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.prevTouchedPathIndex >= 0) {
        DTFillLayer *prevFillLayer = self.fillLayers[(NSUInteger) self.prevTouchedPathIndex];
        prevFillLayer.highLighted = NO;
    }
}

- (void)touchKeyPoint:(NSSet *)touches isMoving:(BOOL)moving {
    if (!self.valueSelectable) {
        return;
    }

    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];

    CGFloat minDistance = -100;
    NSInteger n1 = -1;
    NSInteger n2 = -1;

    for (NSUInteger i = 0; i < self.fillLayers.count; ++i) {
        DTFillLayer *fillLayer = self.fillLayers[i];

        if ([fillLayer.fillPath containsPoint:touchPoint]) {

            fillLayer.highLighted = YES;

            if (self.prevTouchedPathIndex >= 0 && self.prevTouchedPathIndex != i) {
                DTFillLayer *prevFillLayer = self.fillLayers[(NSUInteger) self.prevTouchedPathIndex];
                prevFillLayer.highLighted = NO;
            }

            DTChartSingleData *sData = fillLayer.singleData;

            for (NSUInteger j = 0; j < sData.itemValues.count; ++j) {
                DTChartItemData *itemData = sData.itemValues[j];

                CGFloat distance = ABS(touchPoint.x - itemData.position.x);
                if (distance < TouchOffsetMaxDistance) {
                    if (minDistance == -100) {
                        minDistance = distance;
                        n1 = i;
                        n2 = j;
                    } else if (distance < minDistance) {
                        minDistance = distance;
                        n1 = i;
                        n2 = j;
                    }

                }

            }

            self.prevTouchedPathIndex = i;

            break;
        }
    }

    if (self.fillChartTouchBlock && n1 >= 0 && n2 >= 0) {
        NSString *text = self.fillChartTouchBlock((NSUInteger) n1, (NSUInteger) n2);
        DTLog(@"touch return = %@", text);
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

    [self.fillLayers enumerateObjectsUsingBlock:^(DTFillLayer *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperlayer];
    }];

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            [obj removeFromSuperview];
        }
    }];
}

- (void)generateMultiDataColors:(BOOL)needInitial {
    if (needInitial) {
        NSMutableArray<UIColor *> *existColors = [NSMutableArray arrayWithCapacity:self.multiData.count];
        for (DTChartSingleData *sData in self.multiData) {
            if (sData.color) {
                [existColors addObject:sData.color];
            }
        }
        self.colorManager = [DTColorManager randomManagerExistColors:existColors];
    }

    NSMutableDictionary *cachedSingleDataDic = [NSMutableDictionary dictionary];
    NSMutableArray<DTChartBlockModel *> *infos = [NSMutableArray arrayWithCapacity:self.multiData.count];

    for (DTChartSingleData *sData in self.multiData) {
        DTChartSingleData *cachedData = cachedSingleDataDic[sData.singleName];

        if (cachedData) { // 已经有相同的singleName，取相同颜色alpha减小

            sData.color = cachedData.color;
            sData.secondColor = cachedData.secondColor;

        } else {
            cachedSingleDataDic[sData.singleName] = sData;

            if (!sData.color) {
                sData.color = [self.colorManager getColor];
            }
            if (!sData.secondColor) {
                sData.secondColor = [self.colorManager getLightColor:sData.color];
            }
        }


    }
    if (infos.count > 0 && self.colorsCompletionBlock) {
        self.colorsCompletionBlock(infos);
    }

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
        if (self.xAxisAlignGrid) {  // 卡格子线
            sectionCellCount = (self.xAxisCellCount - 1) * 1 / (self.xAxisLabelDatas.count - 1);
        } else {
            sectionCellCount = (self.xAxisCellCount - 1) * 1.0f / (self.xAxisLabelDatas.count - 1);
        }
    }


    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];


        // 每个label位于section内最后一个单元格线上，所有label在x轴上整体居中
        if (self.xAxisAlignGrid) {  // 卡格子线
            NSUInteger sectionCount2 = (NSUInteger) sectionCellCount;
            data.axisPosition = sectionCount2 * i + 1 + (self.xAxisCellCount - 1 - (self.xAxisLabelDatas.count - 1) * sectionCount2) / 2;
        } else {
            data.axisPosition = sectionCellCount * i + 1 + (self.xAxisCellCount - 1 - (self.xAxisLabelDatas.count - 1) * sectionCellCount) / 2;
        }

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

    [self.fillLayers removeAllObjects];

    DTAxisLabelData *yMaxData = self.yAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.yAxisLabelDatas.firstObject;

    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

    for (NSUInteger n = 0; n < self.multiData.count; ++n) {

        if (n < self.beginRangeIndex) {
            continue;
        }
        if (n > self.endRangeIndex) {
            continue;
        }

        DTChartSingleData *singleData = self.multiData[n];

        UIBezierPath *path = [self generateItemPath:singleData
                                      xAxisMaxVaule:xMaxData
                                      xAxisMinValue:xMinData
                                      yAxisMaxVaule:yMaxData
                                      yAxisMinValue:yMinData];

        if (path) {
            DTFillLayer *fillLayer = [DTFillLayer fillLayer];
            DTFillLayer *prevFillLayer = self.fillLayers.lastObject;

            fillLayer.startPoint = singleData.itemValues.firstObject.position;
            fillLayer.endPoint = singleData.itemValues.lastObject.position;
            fillLayer.borderPath = path;

            UIBezierPath *fillPath = path.copy;
            if (prevFillLayer) {
                [fillPath addLineToPoint:prevFillLayer.endPoint];
                [fillPath appendPath:[prevFillLayer.borderPath bezierPathByReversingPath]];
                [fillPath addLineToPoint:fillLayer.startPoint];
                [fillPath closePath];

            } else {
                [fillPath addLineToPoint:CGPointMake(fillLayer.endPoint.x, self.yAxisCellCount * self.coordinateAxisCellWidth)];
                [fillPath addLineToPoint:CGPointMake(self.coordinateAxisCellWidth, self.yAxisCellCount * self.coordinateAxisCellWidth)];
                [fillPath closePath];
            }

            fillLayer.strokeColor = [UIColor colorWithRed:(49 + n * 2.1f) / 255.0f green:(101 + n * 4) / 255.0f blue:(184 + 1.3f * n) / 255.0f alpha:1].CGColor;
            fillLayer.normalFillColor = [UIColor colorWithRed:(89 + n * 1.67f) / 255.0f green:(129 + n * 3.2f) / 255.0f blue:(198 + n) / 255.0f alpha:1];
            fillLayer.highlightedFillColor = [UIColor colorWithRed:(89 + 10 + n * 1.67f) / 255.0f green:(129 + 10 + n * 3.2f) / 255.0f blue:(198 + 10 + n) / 255.0f alpha:1];

            fillLayer.fillPath = fillPath;
            fillLayer.singleData = singleData;
            [fillLayer draw];

            [self.fillLayers addObject:fillLayer];
            if (prevFillLayer) {
                [self.contentView.layer insertSublayer:fillLayer below:prevFillLayer];
            } else {
                [self.contentView.layer addSublayer:fillLayer];
            }

        }

    }
}

- (void)drawChart {
    [super drawChart];
}


@end
