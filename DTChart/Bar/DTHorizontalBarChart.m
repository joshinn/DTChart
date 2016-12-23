//
//  DTHorizontalBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/9.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTHorizontalBarChart.h"
#import "DTChartLabel.h"
#import "DTChartData.h"
#import "DTHeapBar.h"


@implementation DTHorizontalBarChart

@synthesize barBorderStyle = _barBorderStyle;


- (void)initial {
    [super initial];

    _barBorderStyle = DTBarBorderStyleTopBorder;
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
                bar.delegate = self;
                bar.barSelectable = self.isBarSelectable;
                if (singleData.color) {
                    bar.barColor = singleData.color;
                }
                if (singleData.secondColor) {
                    bar.barBorderColor = singleData.secondColor;
                }

                CGFloat height = self.coordinateAxisCellWidth * self.barWidth;
                CGFloat width = self.coordinateAxisCellWidth * ((itemData.itemValue.x - xMinData.value) / (xMaxData.value - xMinData.value)) * xMaxData.axisPosition;
                CGFloat x = 0;
                CGFloat y = (yData.axisPosition - 1 + yOffset - index) * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - height) / 2;

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
           xAxisMaxVaule:(DTAxisLabelData *)xMaxData
           xAxisMinValue:(DTAxisLabelData *)xMinData {


    for (NSUInteger i = 0; i < singleData.itemValues.count; ++i) {
        DTChartItemData *itemData = singleData.itemValues[i];

        for (NSUInteger j = 0; j < self.yAxisLabelDatas.count; ++j) {
            DTAxisLabelData *yData = self.yAxisLabelDatas[j];

            if (yData.value == itemData.itemValue.y) {

                __block DTHeapBar *bar = nil;
                [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *v, NSUInteger idx, BOOL *stop) {
                    if([v isKindOfClass:[DTHeapBar class]]){
                        DTHeapBar *b = v;
                        if(b.barTag == itemData.itemValue.y){
                            bar = b;
                            *stop = YES;
                        }
                    }
                }];


                if(!bar){
                    bar = [DTHeapBar bar:DTBarOrientationRight];
                    [self.contentView addSubview:bar];
                    bar.barTag = itemData.itemValue.y;
                }

                bar.barData = itemData;
                bar.delegate = self;
                bar.barSelectable = self.isBarSelectable;
                if (singleData.color) {
                    bar.barColor = singleData.color;
                }
                if (singleData.secondColor) {
                    bar.barBorderColor = singleData.secondColor;
                }

                CGFloat height = self.coordinateAxisCellWidth * self.barWidth;
                CGFloat width = self.coordinateAxisCellWidth * ((itemData.itemValue.x - xMinData.value) / (xMaxData.value - xMinData.value)) * xMaxData.axisPosition;
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
                    bar.delegate = self;
                    bar.barSelectable = self.isBarSelectable;
                    if (singleData.color) {
                        bar.barColor = singleData.color;
                    }
                    if (singleData.secondColor) {
                        bar.barBorderColor = singleData.secondColor;
                    }

                    CGFloat height = self.coordinateAxisCellWidth * self.barWidth;
                    CGFloat width = self.coordinateAxisCellWidth * ((itemData.itemValue.x - xMinData.value) / (xMaxData.value - xMinData.value)) * xMaxData.axisPosition;
                    CGFloat x = 0;
                    CGFloat y = (yData.axisPosition - 1) * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - height) / 2;

                    bar.frame = CGRectMake(x, y, width, height);
                    [self.contentView addSubview:bar];

                    if (self.isShowAnimation) {
                        [bar startAppearAnimation];
                    }

                } else {

                    DTBar *lump = [DTBar bar:DTBarOrientationRight style:DTBarBorderStyleNone];
                    lump.barSelectable = self.isBarSelectable;
                    if (singleData.color) {
                        lump.barColor = singleData.color;
                    } else{
                        lump.barColor = [UIColor yellowColor];
                    }

                    CGFloat height = self.coordinateAxisCellWidth * self.barWidth;
                    CGFloat width = self.coordinateAxisCellWidth * ((itemData.itemValue.x - xMinData.value) / (xMaxData.value - xMinData.value)) * xMaxData.axisPosition;
                    CGFloat x = width - self.coordinateAxisCellWidth / 3;
                    CGFloat y = (yData.axisPosition - 1) * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - height) / 2;
                    width = self.coordinateAxisCellWidth / 3;

                    lump.frame = CGRectMake(x, y, width, height);
                    [self.contentView addSubview:lump];

                }


                break;
            }

        }

    }
}

#pragma mark - override

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

        CGFloat x = (self.coordinateAxisInsets.left + data.axisPosition) * self.coordinateAxisCellWidth - size.height / 2;
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
    if (![super drawYAxisLabels]) {
        return NO;
    }

    NSUInteger sectionCellCount = self.yAxisCellCount / self.yAxisLabelDatas.count;

    if (self.barChartStyle == DTBarChartStyleLump) {
        self.barBorderStyle = DTBarBorderStyleNone;
    } else if (sectionCellCount > 1) {
        self.barBorderStyle = DTBarBorderStyleTopBorder;
    } else {
        self.barBorderStyle = DTBarBorderStyleSidesBorder;
    }

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

        CGFloat x = CGRectGetMinX(self.contentView.frame) - size.width;

        CGFloat y = (self.coordinateAxisInsets.top + data.axisPosition - 0.5f) * self.coordinateAxisCellWidth;
        y -= size.height / 2;

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


#pragma mark - DTBarDelegate

- (void)_DTBarSelected:(DTBar *)bar {

}


@end
