//
//  DTVerticalBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/9.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTVerticalBarChart.h"
#import "DTChartLabel.h"
#import "DTChartData.h"
#import "DTHeapBar.h"

@interface DTVerticalBarChart ()


@end


@implementation DTVerticalBarChart

@synthesize barBorderStyle = _barBorderStyle;

- (void)initial {
    [super initial];

    _barBorderStyle = DTBarBorderStyleSidesBorder;
}


#pragma mark - private method


/**
 * 绘制DTBarChartStyleStartingLine风格的柱状图
 * @param singleData 单个数据对象
 * @param index 当前singleData在所有数据中的序号
 * @param yMaxData y轴标签最大值
 * @param yMinData y轴标签最小值
 */
- (void)generateStartingLineBars:(DTChartSingleData *)singleData
                           index:(NSUInteger)index
                   yAxisMaxVaule:(DTAxisLabelData *)yMaxData
                   yAxisMinValue:(DTAxisLabelData *)yMinData {

    CGFloat xOffset = self.barWidth / 2 * (self.multiData.count - 1);

    for (NSUInteger i = 0; i < singleData.itemValues.count; ++i) {
        DTChartItemData *itemData = singleData.itemValues[i];

        for (NSUInteger j = 0; j < self.xAxisLabelDatas.count; ++j) {
            DTAxisLabelData *xData = self.xAxisLabelDatas[j];

            if (xData.value == itemData.itemValue.x) {

                DTBar *bar = [DTBar bar:DTBarOrientationUp style:self.barBorderStyle];
                bar.barData = itemData;
                bar.delegate = self;
                bar.barSelectable = self.isValueSelectable;
                if (singleData.color) {
                    bar.barColor = singleData.color;
                }
                if (singleData.secondColor) {
                    bar.barBorderColor = singleData.secondColor;
                }

                CGFloat width = self.coordinateAxisCellWidth * self.barWidth;
                CGFloat height = self.coordinateAxisCellWidth * ((itemData.itemValue.y - yMinData.value) / (yMaxData.value - yMinData.value)) * yMaxData.axisPosition;
                CGFloat x = (xData.axisPosition - xOffset + index * self.barWidth) * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - width) / 2;
                CGFloat y = CGRectGetHeight(self.contentView.frame) - height;

                bar.frame = CGRectMake(x, y, width, height);
                [self.contentView addSubview:bar];

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
           yAxisMaxVaule:(DTAxisLabelData *)yMaxData
           yAxisMinValue:(DTAxisLabelData *)yMinData {

    for (NSUInteger i = 0; i < singleData.itemValues.count; ++i) {
        DTChartItemData *itemData = singleData.itemValues[i];

        for (NSUInteger j = 0; j < self.xAxisLabelDatas.count; ++j) {
            DTAxisLabelData *xData = self.xAxisLabelDatas[j];

            if (xData.value == itemData.itemValue.x) {

                __block DTHeapBar *bar = nil;
                [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *v, NSUInteger idx, BOOL *stop) {
                    if ([v isKindOfClass:[DTHeapBar class]]) {
                        DTHeapBar *b = v;
                        if (b.barTag == itemData.itemValue.x) {
                            bar = b;
                            *stop = YES;
                        }
                    }
                }];


                if (!bar) {
                    bar = [DTHeapBar bar:DTBarOrientationUp];
                    bar.barTag = itemData.itemValue.x;
                    [self.contentView addSubview:bar];
                }


                bar.barData = itemData;
                bar.delegate = self;
                bar.barSelectable = self.isValueSelectable;
                if (singleData.color) {
                    bar.barColor = singleData.color;
                }
                if (singleData.secondColor) {
                    bar.barBorderColor = singleData.secondColor;
                }

                CGFloat width = self.coordinateAxisCellWidth * self.barWidth;
                CGFloat height = self.coordinateAxisCellWidth * ((itemData.itemValue.y - yMinData.value) / (yMaxData.value - yMinData.value)) * yMaxData.axisPosition;
                CGFloat x = xData.axisPosition * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - width) / 2;
                CGFloat y = CGRectGetHeight(self.contentView.frame) - height;

                bar.frame = CGRectMake(x, y, width, height);

                [bar appendData:itemData barLength:height barColor:bar.barColor needLayout:isLast];


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
           yAxisMaxVaule:(DTAxisLabelData *)yMaxData
           yAxisMinValue:(DTAxisLabelData *)yMinData {

    for (NSUInteger i = 0; i < singleData.itemValues.count; ++i) {
        DTChartItemData *itemData = singleData.itemValues[i];

        for (NSUInteger j = 0; j < self.xAxisLabelDatas.count; ++j) {
            DTAxisLabelData *xData = self.xAxisLabelDatas[j];

            if (xData.value == itemData.itemValue.x) {

                if (index == 0) {

                    DTBar *bar = [DTBar bar:DTBarOrientationUp style:self.barBorderStyle];
                    bar.barData = itemData;
                    bar.delegate = self;
                    bar.barSelectable = self.isValueSelectable;
                    if (singleData.color) {
                        bar.barColor = singleData.color;
                    }
                    if (singleData.secondColor) {
                        bar.barBorderColor = singleData.secondColor;
                    }

                    CGFloat width = self.coordinateAxisCellWidth * self.barWidth;
                    CGFloat height = self.coordinateAxisCellWidth * ((itemData.itemValue.y - yMinData.value) / (yMaxData.value - yMinData.value)) * yMaxData.axisPosition;
                    CGFloat x = xData.axisPosition * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - width) / 2;
                    CGFloat y = CGRectGetHeight(self.contentView.frame) - height;

                    bar.frame = CGRectMake(x, y, width, height);
                    [self.contentView addSubview:bar];

                    if (self.isShowAnimation) {
                        [bar startAppearAnimation];
                    }

                } else {

                    UIView *lumpView = [UIView new];
                    if (singleData.color) {
                        lumpView.backgroundColor = singleData.color;
                    } else {
                        lumpView.backgroundColor = [UIColor yellowColor];
                    }


                    CGFloat width = self.coordinateAxisCellWidth * self.barWidth;
                    CGFloat height = self.coordinateAxisCellWidth * ((itemData.itemValue.y - yMinData.value) / (yMaxData.value - yMinData.value)) * yMaxData.axisPosition;
                    CGFloat x = xData.axisPosition * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - width) / 2;
                    CGFloat y = CGRectGetHeight(self.contentView.frame) - height;
                    height = self.coordinateAxisCellWidth / 3;

                    lumpView.frame = CGRectMake(x, y, width, height);
                    [self.contentView addSubview:lumpView];
                }


                break;
            }
        }

    }
}


#pragma mark - override

- (BOOL)drawXAxisLabels {
    if (![super drawXAxisLabels]) {
        return NO;
    }

    NSUInteger sectionCellCount = self.xAxisCellCount / self.xAxisLabelDatas.count;


    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];

        // 相对于坐标轴内（contentView）位置
        // 所有的柱状体在坐标轴上整体居中
        // 坐标系原点在左下角
        data.axisPosition = sectionCellCount * i + (sectionCellCount - 1) / 2
                + (self.xAxisCellCount - self.xAxisLabelDatas.count * sectionCellCount) / 2;

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

        CGFloat x = (self.coordinateAxisInsets.left + data.axisPosition + 0.5f) * self.coordinateAxisCellWidth;
        x -= size.width / 2;
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


    DTAxisLabelData *yMaxData = self.yAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.yAxisLabelDatas.firstObject;

    for (NSUInteger n = 0; n < self.multiData.count; ++n) {
        DTChartSingleData *singleData = self.multiData[n];

        switch (self.barChartStyle) {

            case DTBarChartStyleStartingLine: {
                [self generateStartingLineBars:singleData index:n yAxisMaxVaule:yMaxData yAxisMinValue:yMinData];
            }
                break;
            case DTBarChartStyleHeap: {
                [self generateHeapBars:singleData last:n == (self.multiData.count - 1) yAxisMaxVaule:yMaxData yAxisMinValue:yMinData];
            }
                break;
            case DTBarChartStyleLump: {
                [self generateLumpBars:singleData index:n yAxisMaxVaule:yMaxData yAxisMinValue:yMinData];
            }
                break;
        }
    }
}

- (void)drawChart {
    DTLog(@"#### begin draw");

    [super drawChart];

    DTLog(@"#### end draw");
}


#pragma mark - DTBarDelegate

- (void)_DTBarSelected:(DTBar *)bar {
    DTLog(@"%@", NSStringFromChartItemValue(bar.barData.itemValue));
}

@end
