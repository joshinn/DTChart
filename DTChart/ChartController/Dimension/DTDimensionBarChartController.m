//
//  DTDimensionBarChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/19.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBarChartController.h"
#import "DTDimensionBarChart.h"
#import "DTDataManager.h"
#import "DTDimensionBarModel.h"

@interface DTDimensionBarChartController ()

@property(nonatomic) DTDimensionBarChart *chart;

@property(nonatomic) NSMutableArray<DTDimensionBarModel *> *levelBarModels;

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

        [_chart setTouchBarBlock:^NSString *(DTDimensionBarStyle chartStyle, NSUInteger row, DTDimension2Item *touchData, NSArray<DTDimension2Item *> *allSubData, BOOL isMainAxis) {
            if (weakSelf.controllerTouchBarBlock) {
                id dimensionData = weakSelf.dimensionDatas.lastObject;
                id measureData = isMainAxis ? weakSelf.mainMeasureData : weakSelf.secondMeasureData;
                return weakSelf.controllerTouchBarBlock(chartStyle, row, touchData, allSubData, dimensionData, measureData, isMainAxis);
            } else {
                return nil;
            }
        }];

        [_chart setItemColorBlock:^(NSArray<DTDimensionBarModel *> *barModels) {
            [weakSelf cacheMultiData:barModels];
        }];

    }
    return self;
}

- (void)setChartStyle:(DTDimensionBarStyle)chartStyle {
    _chartStyle = chartStyle;

    self.chart.chartStyle = chartStyle;
}

- (NSMutableArray<DTDimensionBarModel *> *)levelBarModels {
    if (!_levelBarModels) {
        _levelBarModels = [NSMutableArray array];
    }
    return _levelBarModels;
}

- (void)setHighlightTitle:(NSString *)highlightTitle {
    _highlightTitle = highlightTitle;

    _chart.highlightTitle = highlightTitle;
    [self drawChart];
}

#pragma mark - private method

/**
 * 给chartId加上前缀
 * @param chartId 赋值的chartId
 */
- (void)setChartId:(NSString *)chartId {
    _chartId = [@"Dim2Bar-" stringByAppendingString:chartId];
}

- (void)setPreProcessBarInfo:(BOOL)preProcessBarInfo {
    _preProcessBarInfo = preProcessBarInfo;

    _chart.preProcessBarInfo = preProcessBarInfo;
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
                        NSMutableString *mutableString = [[NSMutableString alloc] initWithString:labelData.title];
                        if (labelData.value < 0) {
                            if (![mutableString hasPrefix:@"-"]) {
                                [mutableString insertString:@"-" atIndex:0];
                            }
                        } else {
                            if ([mutableString hasPrefix:@"-"]) {
                                [mutableString deleteCharactersInRange:NSMakeRange(0, 1)];
                            }
                        }
                        labelData.title = mutableString.copy;
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
        self.chart.mainNotation = [self.axisFormatter getNotationLabelText:YES];
    } else {
        self.chart.secondNotation = [self.axisFormatter getNotationLabelText:NO];
    }
}

/**
 * 把柱状体的颜色信息缓存起来
 */
- (void)cacheMultiData:(NSArray<DTDimensionBarModel *> *)barInfos {

    BOOL changed = NO;

    for (DTDimensionBarModel *barInfo in barInfos) {
        BOOL exist = NO;
        for (DTDimensionBarModel *barModel in self.levelBarModels) {
            if ([barModel.title isEqualToString:barInfo.title]) {
                exist = YES;
                break;
            }
        }

        if (!exist) {
            [self.levelBarModels addObject:barInfo];
            changed = YES;
        }
    }

    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (self.levelBarModels.count > 0) {
        dataDic[@"items"] = self.levelBarModels.copy;
        [DTManager addChart:self.chartId object:@{@"data": dataDic}];
    }

    if (changed && self.controllerBarInfoBlock) {
        DTLog(@"cache data controllerBarInfoBlock");
        self.controllerBarInfoBlock(self.levelBarModels.copy);
    }

}


#pragma mark - override

- (void)drawChart {
    [super drawChart];


    if (self.chartStyle == DTDimensionBarStyleHeap) {

        [self.levelBarModels removeAllObjects];

        if (![DTManager checkExistByChartId:self.chartId]) {

            [self.chart drawChart:nil];

        } else {

            // 加载保存的数据信息（颜色等）
            NSDictionary *chartDic = [DTManager queryByChartId:self.chartId];
            NSDictionary *dataDic = chartDic[@"data"];
            NSArray *items = dataDic[@"items"];

            [self.levelBarModels addObjectsFromArray:items];

            if (self.controllerBarInfoBlock) {
                DTLog(@"draw chart controllerBarInfoBlock");
                self.controllerBarInfoBlock(self.levelBarModels.copy);
            }

            [self.chart drawChart:items];
        }

    } else {
        [self.chart drawChart:nil];
    }
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
