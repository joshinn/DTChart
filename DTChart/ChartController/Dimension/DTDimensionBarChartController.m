//
//  DTDimensionBarChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/19.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBarChartController.h"
#import "DTDimensionBarChart.h"

@interface DTDimensionBarChartController ()

@property(nonatomic) DTDimensionBarChart *chart;

@end


@implementation DTDimensionBarChartController

@synthesize chartView = _chartView;
@synthesize chartId = _chartId;


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _chart = [[DTDimensionBarChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _chartView = _chart;

        WEAK_SELF;
        [_chart setTouchLabelBlock:^NSString *(DTDimensionBarStyle chartStyle, NSUInteger row, DTDimension2Model *data, NSUInteger index) {
            if (weakSelf.controllerTouchLabelBlock) {
                return weakSelf.controllerTouchLabelBlock(chartStyle, row, data, index);
            } else {
                return nil;
            }
        }];

        [_chart setTouchBarBlock:^NSString *(DTDimensionBarStyle chartStyle, NSUInteger row, DTDimension2Item *touchData, NSString *measureName, NSArray<DTDimension2Item *> *allSubData, BOOL isMainAxis) {
            if (weakSelf.controllerTouchBarBlock) {
                return weakSelf.controllerTouchBarBlock(chartStyle, row, touchData, measureName, allSubData, isMainAxis);
            } else {
                return nil;
            }
        }];
    }
    return self;
}

- (void)setChartStyle:(DTDimensionBarStyle)chartStyle {
    _chartStyle = chartStyle;

    self.chart.chartStyle = chartStyle;
}


#pragma mark - private method

/**
 * 给chartId加上前缀
 * @param chartId 赋值的chartId
 */
- (void)setChartId:(NSString *)chartId {
    _chartId = [@"Dim2Bar-" stringByAppendingString:chartId];
}

- (void)processXLabelData:(NSUInteger)axisCount axisMaxValue:(CGFloat)maxValue axisMinValue:(CGFloat)minValue isMainAxis:(BOOL)isMainAxis {

    if (minValue >= 0) {

        NSMutableArray<DTAxisLabelData *> *xLabelDatas = [super generateYAxisLabelData:axisCount yAxisMaxValue:maxValue isMainAxis:isMainAxis];
        if (isMainAxis) {
            self.chart.xAxisLabelDatas = xLabelDatas;
        } else {
            self.chart.xSecondAxisLabelDatas = xLabelDatas;
        }

    } else {
        CGFloat max = 0;
        CGFloat min = 0;
        BOOL isReverse = NO;
        if (-minValue <= maxValue) {
            max = maxValue;
            min = minValue;
        } else {
            max = -minValue;
            min = -maxValue;
            isReverse = YES;
        }

        for (NSUInteger i = 1; i < axisCount; ++i) {
            NSMutableArray<DTAxisLabelData *> *xLabelDatas = [super generateYAxisLabelData:axisCount - i yAxisMaxValue:max isMainAxis:isMainAxis];

            if (-min < xLabelDatas[i].value) {
                NSMutableArray<DTAxisLabelData *> *negativeLabelDatas = [NSMutableArray array];
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                NSInteger notation = isMainAxis ? self.axisFormatter.mainYAxisNotation : self.axisFormatter.secondYAxisNotation;

                for (NSUInteger j = 0; j < i; ++j) {
                    DTAxisLabelData *xLabelData = [[DTAxisLabelData alloc] initWithTitle:[NSString stringWithFormat:@"%@", @(-xLabelDatas[j + 1].value / notation)] value:-xLabelDatas[j + 1].value];
                    [negativeLabelDatas insertObject:xLabelData atIndex:0];
                    [indexSet addIndex:j];
                }
                [xLabelDatas insertObjects:negativeLabelDatas atIndexes:indexSet];

                if (isReverse) {
                    NSMutableArray<DTAxisLabelData *> *reverseLabelDatas = [xLabelDatas mutableCopy];
                    [xLabelDatas removeAllObjects];

                    for (DTAxisLabelData *labelData in reverseLabelDatas) {
                        labelData.value = labelData.value == 0 ? labelData.value : -labelData.value;
                        labelData.title = [NSString stringWithFormat:@"%@", @(labelData.value)];
                        [xLabelDatas insertObject:labelData atIndex:0];
                    }
                }

                if (isMainAxis) {
                    self.chart.xAxisLabelDatas = xLabelDatas;
                } else {
                    self.chart.xSecondAxisLabelDatas = xLabelDatas;
                }

                break;
            }

        }
    }

    if (isMainAxis) {
        self.chart.mainNotation = [self getNotationLabelText:YES];
    } else {
        self.chart.secondNotation = [self getNotationLabelText:NO];
    }
}

/**
 * 获取y轴对应的倍数文字
 * @param isMain 是否是主轴
 * @return 文字
 */
- (NSString *)getNotationLabelText:(BOOL)isMain {
    NSInteger notation = isMain ? self.axisFormatter.mainYAxisNotation : self.axisFormatter.secondYAxisNotation;
    NSString *unit = isMain ? self.axisFormatter.mainYAxisUnit : self.axisFormatter.secondYAxisUnit;
    if (!unit) {
        unit = @"";
    }

    if (notation == 1000) {
        return [NSString stringWithFormat:@"×10³%@", unit];
    } else if (notation == 1000000) {
        return [NSString stringWithFormat:@"×10⁶%@", unit];
    } else if (notation == 1000000000) {
        return [NSString stringWithFormat:@"×10⁹%@", unit];
    } else {
        return nil;
    }
}

#pragma mark - override

- (void)drawChart {
    [super drawChart];

    [self.chart drawChart];
}

#pragma mark - public method

- (void)setMainData:(nonnull DTDimension2ListModel *)mainData secondData:(nullable DTDimension2ListModel *)secondData {
    if (mainData && secondData && mainData.listDimensions.count != secondData.listDimensions.count) {
        return;
    }

    DTAxisFormatter *axisFormatter = [DTAxisFormatter axisFormatter];
    axisFormatter.mainYAxisType = DTAxisFormatterTypeNumber;
    axisFormatter.secondYAxisType = DTAxisFormatterTypeNumber;
    self.axisFormatter = axisFormatter;

    if (mainData) {
        self.chart.mainData = mainData;
        [self processXLabelData:4 axisMaxValue:mainData.maxValue axisMinValue:mainData.minValue isMainAxis:YES];
    } else {
        self.chart.mainData = nil;
    }

    if (secondData) {
        self.chart.secondData = secondData;
        [self processXLabelData:4 axisMaxValue:secondData.maxValue axisMinValue:secondData.minValue isMainAxis:NO];
    } else {
        self.chart.secondData = nil;
    }
}


@end
