//
//  DTHorizontalBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/9.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTHorizontalBarChart.h"
#import "DTChartLabel.h"
#import "DTHeapBar.h"
#import "DTChartToastView.h"


@implementation DTHorizontalBarChart

@synthesize barBorderStyle = _barBorderStyle;


- (void)initial {
    [super initial];

    _barBorderStyle = DTBarBorderStyleTopBorder;
    ChartEdgeInsets insets = self.coordinateAxisInsets;
    insets.top = 0;
    insets.right = 1;
    self.coordinateAxisInsets = insets;

    self.mainNotationLabel.textAlignment = NSTextAlignmentCenter;
    self.mainNotationLabel.numberOfLines = 0;
    self.mainNotationLabel.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame), CGRectGetMaxY(self.contentView.frame) - 6 * self.coordinateAxisCellWidth, self.coordinateAxisCellWidth, 6 * self.coordinateAxisCellWidth);
}

#pragma mark - private method

/**
 * 绘制DTBarChartStyleStartingLine风格的柱状图
 * @param singleData 单个数据对象
 * @param index 当前singleData在所有数据中的序号
 * @param xMaxData x轴标签最大值
 * @param xMinData x轴标签最小值
 *
 */
- (void)generateStartingLineBars:(DTChartSingleData *)singleData
                           index:(NSUInteger)index
                   xAxisMaxVaule:(DTAxisLabelData *)xMaxData
                   xAxisMinValue:(DTAxisLabelData *)xMinData {

    CGFloat yOffset = self.barWidth / 2 * (self.multiData.count - 1);

    for (NSUInteger i = 0; i < singleData.itemValues.count; ++i) {
        DTChartItemData *itemData = singleData.itemValues[i];

        for (NSUInteger j = 0; j < self.yAxisLabelDatas.count; ++j) {
            DTAxisLabelData *yData = self.yAxisLabelDatas[j];

            if (yData.value == itemData.itemValue.y) {

                DTBar *bar = [DTBar bar:DTBarOrientationRight style:self.barBorderStyle];
                bar.barData = itemData;

                if (singleData.color) {
                    bar.barColor = singleData.color;
                }
                if (singleData.secondColor) {
                    bar.barBorderColor = singleData.secondColor;
                }

                CGFloat height = self.coordinateAxisCellWidth * self.barWidth;
                CGFloat width = self.coordinateAxisCellWidth * ((itemData.itemValue.x - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMaxData.axisPosition - xMinData.axisPosition);
                CGFloat x = 0;
                CGFloat y = (yData.axisPosition - 1 + yOffset - index * self.barWidth) * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - height) / 2;

                bar.frame = CGRectMake(x, y, width, height);
                [self.contentView addSubview:bar];
                [self.chartBars addObject:bar];

                if (self.isShowAnimation) {
                    [bar startAppearAnimation];
                }

                break;
            }
        }
    }
}

- (void)generateHeapBars:(DTChartSingleData *)singleData
                    last:(BOOL)isLast
           xAxisMaxVaule:(DTAxisLabelData *)xMaxData
           xAxisMinValue:(DTAxisLabelData *)xMinData {

    for (NSUInteger i = 0; i < singleData.itemValues.count; ++i) {
        DTChartItemData *itemData = singleData.itemValues[i];

        for (NSUInteger j = 0; j < self.yAxisLabelDatas.count; ++j) {
            DTAxisLabelData *yData = self.yAxisLabelDatas[j];

            if (yData.value == itemData.itemValue.y) {

                __block DTHeapBar *bar = nil;
                [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *v, NSUInteger idx, BOOL *stop) {
                    if ([v isKindOfClass:[DTHeapBar class]]) {
                        DTHeapBar *b = v;
                        if (b.barTag == itemData.itemValue.y) {
                            bar = b;
                            *stop = YES;
                        }
                    }
                }];

                if (!bar) {
                    bar = [DTHeapBar bar:DTBarOrientationRight];
                    [self.contentView addSubview:bar];
                    bar.barTag = itemData.itemValue.y;
                    [self.chartBars addObject:bar];
                }

                bar.barData = itemData;

                if (singleData.color) {
                    bar.barColor = singleData.color;
                }
                if (singleData.secondColor) {
                    bar.barBorderColor = singleData.secondColor;
                }

                CGFloat height = self.coordinateAxisCellWidth * self.barWidth;
                CGFloat width = self.coordinateAxisCellWidth * ((itemData.itemValue.x - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMaxData.axisPosition - xMinData.axisPosition);
                CGFloat x = 0;
                CGFloat y = (yData.axisPosition - 1) * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - height) / 2;

                bar.frame = CGRectMake(x, y, width, height);

                [bar appendData:itemData barLength:width barColor:bar.barColor needLayout:isLast];

                if (isLast && self.isShowAnimation) {
                    [bar startAppearAnimation];
                }

                break;
            }
        }
    }
}

- (void)generateLumpBars:(DTChartSingleData *)singleData
                   index:(NSUInteger)index
           xAxisMaxVaule:(DTAxisLabelData *)xMaxData
           xAxisMinValue:(DTAxisLabelData *)xMinData {

    for (NSUInteger i = 0; i < singleData.itemValues.count; ++i) {
        DTChartItemData *itemData = singleData.itemValues[i];

        for (NSUInteger j = 0; j < self.yAxisLabelDatas.count; ++j) {
            DTAxisLabelData *yData = self.yAxisLabelDatas[j];

            if (yData.value == itemData.itemValue.y) {

                if (index == 0) {


                    DTBar *bar = [DTBar bar:DTBarOrientationRight style:self.barBorderStyle];
                    bar.barData = itemData;

                    if (singleData.color) {
                        bar.barColor = singleData.color;
                    }
                    if (singleData.secondColor) {
                        bar.barBorderColor = singleData.secondColor;
                    }

                    CGFloat height = self.coordinateAxisCellWidth * self.barWidth;
                    CGFloat width = self.coordinateAxisCellWidth * ((itemData.itemValue.x - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMaxData.axisPosition - xMinData.axisPosition);
                    CGFloat x = 0;
                    CGFloat y = (yData.axisPosition - 1) * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - height) / 2;

                    bar.frame = CGRectMake(x, y, width, height);
                    [self.contentView addSubview:bar];
                    [self.chartBars addObject:bar];

                    if (self.isShowAnimation) {
                        [bar startAppearAnimation];
                    }

                } else {

                    DTBar *lump = [DTBar bar:DTBarOrientationRight style:DTBarBorderStyleNone];

                    if (singleData.color) {
                        lump.barColor = singleData.color;
                    } else {
                        lump.barColor = [UIColor yellowColor];
                    }

                    CGFloat height = self.coordinateAxisCellWidth * self.barWidth;
                    CGFloat width = self.coordinateAxisCellWidth * ((itemData.itemValue.x - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMaxData.axisPosition - xMinData.axisPosition);
                    CGFloat x = width - self.coordinateAxisCellWidth / 3;
                    CGFloat y = (yData.axisPosition - 1) * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - height) / 2;
                    if (width > 0) {
                        width = self.coordinateAxisCellWidth / 3;
                    }

                    lump.frame = CGRectMake(x, y, width, height);
                    [self.contentView addSubview:lump];
                    [self.chartBars addObject:lump];
                }

                break;
            }

        }

    }
}

- (void)showTouchMessage:(NSString *)message touchPoint:(CGPoint)point {
    [self.touchSelectedLine removeFromSuperlayer];
    [self.contentView.layer addSublayer:self.touchSelectedLine];
    self.touchSelectedLine.hidden = NO;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.touchSelectedLine.frame = CGRectMake(0, point.y, CGRectGetWidth(self.contentView.bounds), 1);
    [CATransaction commit];

    [self.toastView show:message location:point];
}

- (void)hideTouchMessage {
    [self.toastView hide];
    self.touchSelectedLine.hidden = YES;
}

#pragma mark - touch event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.valueSelectable) {
        [super touchesBegan:touches withEvent:event];
    } else {

        [self touchKeyPoint:touches];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.valueSelectable) {
        [super touchesMoved:touches withEvent:event];
    } else {

        [self touchKeyPoint:touches];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.valueSelectable) {
        [super touchesEnded:touches withEvent:event];
    } else {
        [self hideTouchMessage];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.valueSelectable) {
        [super touchesCancelled:touches withEvent:event];
    } else {
        [self hideTouchMessage];
    }
}

- (void)touchKeyPoint:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];

    BOOL containsPoint = NO;
    for (NSUInteger i = 0; i < self.chartBars.count; ++i) {
        DTBar *bar = self.chartBars[i];
        if (touchPoint.y >= CGRectGetMinY(bar.frame) && touchPoint.y <= CGRectGetMaxY(bar.frame)) {
            containsPoint = YES;

            NSString *message = nil;
            for (NSUInteger dataIndex = 0; dataIndex < self.multiData.count; ++dataIndex) {
                DTChartSingleData *sData = self.multiData[dataIndex];
                if ([sData.itemValues containsObject:bar.barData]) {
                    NSUInteger barIndex = [sData.itemValues indexOfObject:bar.barData];

                    if (self.barChartTouchBlock) {
                        message = self.barChartTouchBlock(dataIndex, barIndex);
                    }
                    break;
                }
            }

            if (message) {
                [self showTouchMessage:message touchPoint:CGPointMake(touchPoint.x, CGRectGetMidY(bar.frame))];
            }

            break;
        }
    }

    if (!containsPoint) {
        [self hideTouchMessage];
    }
}

#pragma mark - override

- (void)clearChartContent {
    [super clearChartContent];

    [self.chartBars removeAllObjects];
}

- (BOOL)drawXAxisLabels {

    if (self.xAxisLabelDatas.count < 2) {
        DTLog(@"Error: x轴标签数量小于2");
        return NO;
    }


    NSUInteger sectionCellCount = self.xAxisCellCount / (self.xAxisLabelDatas.count - 1);

    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i;

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

    if (!self.mainNotationLabel.superview) {
        [self addSubview:self.mainNotationLabel];
    }

    return YES;
}

- (BOOL)drawYAxisLabels {
    if (![super drawYAxisLabels]) {
        return NO;
    }

    NSUInteger sectionCellCount = self.yAxisCellCount / self.yAxisLabelDatas.count;

    for (NSUInteger i = 0; i < self.yAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.yAxisLabelDatas[i];

        // 相对于坐标轴内（contentView）位置
        // 所有的柱状体在坐标轴上整体居中
        // 坐标系原点在左下角
        data.axisPosition = self.yAxisCellCount - sectionCellCount * i - (sectionCellCount - 1) / 2
                - (self.yAxisCellCount - self.yAxisLabelDatas.count * sectionCellCount) / 2;

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

        CGFloat x = CGRectGetMinX(self.contentView.frame);

        CGFloat y = (self.coordinateAxisInsets.top + data.axisPosition - 0.5f) * self.coordinateAxisCellWidth;
        y -= size.height / 2;
        y -= (self.barWidth / 2 + 0.5) * self.coordinateAxisCellWidth; // 移到柱状体上面

        yLabel.frame = (CGRect) {CGPointMake(x, y), size};


        [self addSubview:yLabel];
    }

    return YES;
}


- (void)drawValues {

    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;;


    for (NSUInteger n = 0; n < self.multiData.count; ++n) {
        DTChartSingleData *singleData = self.multiData[n];

        switch (self.barChartStyle) {

            case DTBarChartStyleStartingLine: {
                [self generateStartingLineBars:singleData index:n xAxisMaxVaule:xMaxData xAxisMinValue:xMinData];
            }
                break;
            case DTBarChartStyleHeap: {
                [self generateHeapBars:singleData last:n == (self.multiData.count - 1) xAxisMaxVaule:xMaxData xAxisMinValue:xMinData];
            }
                break;
            case DTBarChartStyleLump: {
                [self generateLumpBars:singleData index:n xAxisMaxVaule:xMaxData xAxisMinValue:xMinData];
            }
                break;
        }

    }
}

- (void)drawChart {
    [super drawChart];
}


@end
