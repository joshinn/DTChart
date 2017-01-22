//
//  DTLineChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTLineChart.h"
#import "DTChartLabel.h"
#import "DTLineChartSingleData.h"
#import "DTLine.h"
#import "DTChartBlockModel.h"


@interface DTLineChart ()

@property(nonatomic) NSMutableArray<DTLine *> *valueLines;
@property(nonatomic) NSMutableArray<DTLine *> *secondValueLines;
@property(nonatomic) NSIndexPath *prevTouchIndex;


@end

@implementation DTLineChart

/**
 * 相同seriesName的折线，第二条起，颜色alpha减小系数
 */
static CGFloat const DTSameSeriesNameColorAlpha = 0.5;

/**
 * 触摸点最大的偏移距离
 */
static CGFloat const TouchOffsetMaxDistance = 10;


- (void)initial {
    [super initial];

    _xAxisAlignGrid = NO;
    self.coordinateAxisInsets = ChartEdgeInsetsMake(self.coordinateAxisInsets.left, self.coordinateAxisInsets.top, 1, self.coordinateAxisInsets.bottom);
}

#pragma mark - delay init

- (NSMutableArray<DTLine *> *)valueLines {
    if (!_valueLines) {
        _valueLines = [[NSMutableArray<DTLine *> alloc] init];
    }
    return _valueLines;
}

- (NSMutableArray<DTLine *> *)secondValueLines {
    if (!_secondValueLines) {
        _secondValueLines = [[NSMutableArray<DTLine *> alloc] init];
    }
    return _secondValueLines;
}

- (NSIndexPath *)prevTouchIndex {
    if (!_prevTouchIndex) {
        _prevTouchIndex = [NSIndexPath indexPathForItem:-1 inSection:-1];
    }
    return _prevTouchIndex;
}


#pragma mark - private method


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchKeyPoint:touches isMoving:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchKeyPoint:touches isMoving:YES];
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

    for (NSUInteger i = 0; i < (self.multiData.count + self.secondMultiData.count); ++i) {
        DTChartSingleData *item;
        if (i < self.multiData.count) {
            item = self.multiData[i];
        } else {
            item = self.secondMultiData[i - self.multiData.count];
        }

        if (![item isKindOfClass:[DTLineChartSingleData class]]) {
            continue;
        }

        DTLineChartSingleData *sData = (DTLineChartSingleData *) item;

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

    if (n1 >= 0 && n2 >= 0 && self.lineChartTouchBlock) {
        // 过滤掉手指移动造成的重复点选择
        if (moving) {
            if (self.prevTouchIndex.section != n1 || self.prevTouchIndex.item != n2) {

                self.prevTouchIndex = [NSIndexPath indexPathForItem:n2 inSection:n1];
                BOOL isMainAxis = n1 < self.multiData.count;
                if (!isMainAxis) {
                    n1 -= self.multiData.count;
                }

                self.lineChartTouchBlock((NSUInteger) n1, (NSUInteger) n2, isMainAxis);
            }
        } else {
            self.prevTouchIndex = [NSIndexPath indexPathForItem:n2 inSection:n1];
            BOOL isMainAxis = n1 < self.multiData.count;

            if (!isMainAxis) {
                n1 -= self.multiData.count;
            }

            self.lineChartTouchBlock((NSUInteger) n1, (NSUInteger) n2, isMainAxis);
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
- (UIBezierPath *)generateItemPath:(DTLineChartSingleData *)singleData
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


#pragma mark - public method


#pragma mark - override

/**
 * 清除坐标系里的轴标签和值线条
 */
- (void)clearChartContent {

    [self.valueLines enumerateObjectsUsingBlock:^(DTLine *line, NSUInteger idx, BOOL *stop) {
        [line removeFromSuperlayer];
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

            sData.color = [cachedData.color colorWithAlphaComponent:DTSameSeriesNameColorAlpha];
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

        DTChartBlockModel *blockModel = [[DTChartBlockModel alloc] init];
        blockModel.seriesId = sData.singleId;
        blockModel.color = sData.color;
        [infos addObject:blockModel];

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

    [self.valueLines removeAllObjects];

    DTAxisLabelData *yMaxData = self.yAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.yAxisLabelDatas.firstObject;

    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

    for (NSUInteger n = 0; n < self.multiData.count; ++n) {
        DTLineChartSingleData *singleData = (DTLineChartSingleData *) self.multiData[n];

        UIBezierPath *path = [self generateItemPath:singleData
                                      xAxisMaxVaule:xMaxData
                                      xAxisMinValue:xMinData
                                      yAxisMaxVaule:yMaxData
                                      yAxisMinValue:yMinData];

        if (path) {

            DTLine *line = [DTLine line:singleData.pointType];
            line.linePath = path;
            line.singleData = singleData;
            [self.valueLines addObject:line];
            [self.contentView.layer addSublayer:line];


            if (self.isShowAnimation) {
                [line startAppearAnimation];
            }
            [line drawEdgePoint:0];
        }

    }
}

- (void)drawChart {

    [super drawChart];

    [self drawSecondChart];
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

        DTLineChartSingleData *singleData = (DTLineChartSingleData *) self.multiData[n];

        UIBezierPath *path = [self generateItemPath:singleData
                                      xAxisMaxVaule:xMaxData
                                      xAxisMinValue:xMinData
                                      yAxisMaxVaule:yMaxData
                                      yAxisMinValue:yMinData];

        if (path) {

            DTLine *line = self.valueLines[n];
            line.singleData = singleData;

            if (animation) {
                [line startPathUpdateAnimation:path];
            } else {
                line.linePath = path;
            }
            [line drawEdgePoint:0];
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

        DTLineChartSingleData *singleData = (DTLineChartSingleData *) self.multiData[n];

        UIBezierPath *path = [self generateItemPath:singleData
                                      xAxisMaxVaule:xMaxData
                                      xAxisMinValue:xMinData
                                      yAxisMaxVaule:yMaxData
                                      yAxisMinValue:yMinData];

        if (path) {

            DTLine *line = [DTLine line:singleData.pointType];
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
            }
            [line drawEdgePoint:0];
        }

    }

}

- (void)deleteChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
    [super deleteChartItems:indexes withAnimation:animation];

    [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        DTLog(@"enum index = %@", @(index));
        DTLine *line = self.valueLines[index];

        if (animation) {
            [line removeEdgePoint];
            [line startDisappearAnimation];
        } else {
            [line removeFromSuperlayer];
        }
    }];

    [self.valueLines removeObjectsAtIndexes:indexes];
}

#pragma mark - 副轴绘制

- (void)generateSecondMultiDataColors:(BOOL)needInitial {

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

    for (NSUInteger i = 0; i < self.secondMultiData.count; ++i) {
        DTChartSingleData *sData = self.secondMultiData[i];

        DTChartSingleData *cachedData = cachedSingleDataDic[sData.singleName];

        if (cachedData) { // 已经有相同的singleName，取相同颜色alpha减小

            sData.color = [cachedData.color colorWithAlphaComponent:DTSameSeriesNameColorAlpha];
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

        DTChartBlockModel *blockModel = [[DTChartBlockModel alloc] init];
        blockModel.seriesId = sData.singleId;
        blockModel.color = sData.color;
        [infos addObject:blockModel];

    }
    if (infos.count > 0 && self.secondAxisColorsCompletionBlock) {
        self.secondAxisColorsCompletionBlock(infos);
    }
}
/**
 * 清除坐标系里的副轴轴标签和值线条
 */
- (void)clearSecondChartContent {

    [self.secondValueLines enumerateObjectsUsingBlock:^(DTLine *line, NSUInteger idx, BOOL *stop) {
        [line removeFromSuperlayer];
    }];

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            DTChartLabel *label = obj;
            if (label.isSecondAxis) {
                [label removeFromSuperview];
            }
        }
    }];
}


- (BOOL)drawYSecondAxisLabels {
    if (self.ySecondAxisLabelDatas.count < 2) {
        DTLog(@"Error: y轴副轴标签数量小于2");
        return NO;
    }

    NSUInteger sectionCellCount = self.yAxisCellCount / (self.ySecondAxisLabelDatas.count - 1);

    for (NSUInteger i = 0; i < self.ySecondAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.ySecondAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i;

        if (data.hidden) {
            continue;
        }

        DTChartLabel *yLabel = [DTChartLabel chartLabel];
        if (self.yAxisLabelColor) {
            yLabel.textColor = self.yAxisLabelColor;
        }
        yLabel.secondAxis = YES;

        yLabel.textAlignment = NSTextAlignmentRight;
        yLabel.text = data.title;

        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: yLabel.font}];

        CGFloat x = CGRectGetMaxX(self.contentView.frame);
        CGFloat y = (self.coordinateAxisInsets.top + self.yAxisCellCount - data.axisPosition) * self.coordinateAxisCellWidth - size.height / 2;

        yLabel.frame = (CGRect) {CGPointMake(x, y), size};

        [self addSubview:yLabel];
    }

    return YES;
}

/**
 * 绘制副轴折线
 */
- (void)drawSecondValues {

    [self.secondValueLines removeAllObjects];

    DTAxisLabelData *yMaxData = self.ySecondAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.ySecondAxisLabelDatas.firstObject;

    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

    for (NSUInteger n = 0; n < self.secondMultiData.count; ++n) {
        DTChartSingleData *item = self.secondMultiData[n];
        if (![item isKindOfClass:[DTLineChartSingleData class]]) {
            continue;
        }

        DTLineChartSingleData *singleData = (DTLineChartSingleData *) item;

        UIBezierPath *path = [self generateItemPath:singleData
                                      xAxisMaxVaule:xMaxData
                                      xAxisMinValue:xMinData
                                      yAxisMaxVaule:yMaxData
                                      yAxisMinValue:yMinData];

        if (path) {

            DTLine *line = [DTLine line:singleData.pointType];
            line.linePath = path;
            line.singleData = singleData;
            [self.secondValueLines addObject:line];
            [self.contentView.layer addSublayer:line];


            if (self.isShowAnimation) {
                [line startAppearAnimation];
            }
            [line drawEdgePoint:0];
        }
    }
}

- (void)drawSecondChart {
    [super drawSecondChart];
}

- (void)reloadChartSecondAxisItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {

    DTAxisLabelData *yMaxData = self.ySecondAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.ySecondAxisLabelDatas.firstObject;

    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

    for (NSUInteger n = 0; n < self.secondMultiData.count; ++n) {

        if (![indexes containsIndex:n]) {
            continue;
        }

        DTChartSingleData *item = self.secondMultiData[n];
        if (![item isKindOfClass:[DTLineChartSingleData class]]) {
            continue;
        }

        DTLineChartSingleData *singleData = (DTLineChartSingleData *) item;

        UIBezierPath *path = [self generateItemPath:singleData
                                      xAxisMaxVaule:xMaxData
                                      xAxisMinValue:xMinData
                                      yAxisMaxVaule:yMaxData
                                      yAxisMinValue:yMinData];

        if (path) {

            DTLine *line = self.secondValueLines[n];
            line.singleData = singleData;


            if (animation) {
                [line startPathUpdateAnimation:path];
            } else {
                line.linePath = path;
            }
            [line drawEdgePoint:0];
        }
    }
}

- (void)insertChartSecondAxisItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
    [super insertChartSecondAxisItems:indexes withAnimation:animation];

    DTAxisLabelData *yMaxData = self.ySecondAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.ySecondAxisLabelDatas.firstObject;

    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

    for (NSUInteger n = 0; n < self.secondMultiData.count; ++n) {
        if (![indexes containsIndex:n]) {
            continue;
        }

        DTChartSingleData *item = self.secondMultiData[n];
        if (![item isKindOfClass:[DTLineChartSingleData class]]) {
            continue;
        }

        DTLineChartSingleData *singleData = (DTLineChartSingleData *) item;

        UIBezierPath *path = [self generateItemPath:singleData
                                      xAxisMaxVaule:xMaxData
                                      xAxisMinValue:xMinData
                                      yAxisMaxVaule:yMaxData
                                      yAxisMinValue:yMinData];

        if (path) {

            DTLine *line = [DTLine line:singleData.pointType];
            line.singleData = singleData;
            line.linePath = path;

            if (self.secondValueLines.count >= n) {
                [self.secondValueLines insertObject:line atIndex:n];
                NSInteger index = MIN(self.multiData.count + n, self.contentView.layer.sublayers.count);
                [self.contentView.layer insertSublayer:line atIndex:(unsigned int) index];
            } else {
                [self.secondValueLines addObject:line];
                [self.contentView.layer addSublayer:line];
            }

            if (animation) {
                [line startAppearAnimation];
            }
            [line drawEdgePoint:0];
        }
    }
}

- (void)deleteChartSecondAxisItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
    [super deleteChartSecondAxisItems:indexes withAnimation:animation];

    [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        DTLog(@"enum index = %@", @(index));
        DTLine *line = self.secondValueLines[index];

        if (animation) {
            [line removeEdgePoint];
            [line startDisappearAnimation];
        } else {
            [line removeFromSuperlayer];
        }
    }];

    [self.secondValueLines removeObjectsAtIndexes:indexes];

    if(self.secondMultiData.count == 0){ // 移除y副轴label
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[DTChartLabel class]]) {
                DTChartLabel *label = obj;
                if (label.isSecondAxis) {
                    [label removeFromSuperview];
                }
            }
        }];
    }
}

@end
