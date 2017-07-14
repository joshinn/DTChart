//
//  DTMeasureDimensionBurgerBarChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/20.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTMeasureDimensionBurgerBarChartController.h"
#import "DTMeasureDimensionBurgerBarChart.h"
#import "DTDataManager.h"
#import "DTDimensionBarModel.h"
#import "DTDimensionModel.h"

@interface DTMeasureDimensionBurgerBarChartController ()

@property(nonatomic) DTMeasureDimensionBurgerBarChart *chart;

@end

@implementation DTMeasureDimensionBurgerBarChartController

@synthesize chartView = _chartView;
@synthesize chartId = _chartId;


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _chart = [[DTMeasureDimensionBurgerBarChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _chartView = _chart;

        _chart.barWidth = 2;
        _chart.yOffset = 2;
        WEAK_SELF;
        [_chart setTouchMainSubBarBlock:^NSString *(NSArray<DTDimensionModel *> *allSubData, DTDimensionModel *touchData, NSUInteger dimensionIndex) {
            if (weakSelf.touchBurgerMainSubBarBlock) {
                id dimensionData = nil;
                if (dimensionIndex < weakSelf.dimensionDatas.count) {
                    dimensionData = weakSelf.dimensionDatas[dimensionIndex];
                }
                return weakSelf.touchBurgerMainSubBarBlock(allSubData, touchData, dimensionData, weakSelf.mainMeasureData);
            } else {
                return nil;
            }
        }];

        [_chart setTouchSecondSubBarBlock:^NSString *(NSArray<DTDimensionModel *> *allSubData, DTDimensionModel *touchData, NSUInteger dimensionIndex) {
            if (weakSelf.touchBurgerSecondSubBarBlock) {
                id dimensionData = nil;
                if (dimensionIndex < weakSelf.dimensionDatas.count) {
                    dimensionData = weakSelf.dimensionDatas[dimensionIndex];
                }
                return weakSelf.touchBurgerSecondSubBarBlock(allSubData, touchData, dimensionData, weakSelf.secondMeasureData);
            } else {
                return nil;
            }
        }];

        [_chart setMainSubBarInfoBlock:^(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, NSUInteger dimensionIndex) {
            if (weakSelf.burgerMainSubBarInfoBlock) {
                id dimensionData = nil;
                if (dimensionIndex < weakSelf.dimensionDatas.count) {
                    dimensionData = weakSelf.dimensionDatas[dimensionIndex];
                }
                weakSelf.burgerMainSubBarInfoBlock(allSubData, barAllColor, dimensionData, dimensionIndex);
            }
        }];

        [_chart setSecondSubBarInfoBlock:^(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, NSUInteger dimensionIndex) {
            if (weakSelf.burgerSecondSubBarInfoBlock) {
                id dimensionData = nil;
                if (dimensionIndex < weakSelf.dimensionDatas.count) {
                    dimensionData = weakSelf.dimensionDatas[dimensionIndex];
                }
                weakSelf.burgerSecondSubBarInfoBlock(allSubData, barAllColor, dimensionData, dimensionIndex);
            }
        }];
    }
    return self;
}

#pragma mark - private method

/**
 * 给chartId加上前缀
 * @param chartId 赋值的chartId
 */
- (void)setChartId:(NSString *)chartId {
    _chartId = [@"hMeaDimBurgerBar-" stringByAppendingString:chartId];
}

- (void)setChartMode:(DTChartMode)chartMode {
    [super setChartMode:chartMode];

    if (chartMode == DTChartModeThumb) {
        _chart.barWidth = 1;
        _chart.barGap = 2;
    } else if (chartMode == DTChartModePresentation) {
        _chart.barWidth = 2;
        _chart.barGap = 6;
    }
}

#pragma mark - private method

/**
 * 把柱状图图的柱状体信息缓存起来
 */
- (void)cacheBarData {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (self.chart.levelLowestBarModels.count > 0) {
        dataDic[@"barData"] = self.chart.levelLowestBarModels.copy;
    }

    [DTManager addChart:self.chartId object:@{@"data": dataDic}];
}

/**
 * 对比已缓存的数据和当前的新数据，给新数据修正颜色等信息
 * @param cachedBarData 已缓存的数据
 * @param barData 当前的新数据
 */
- (void)checkBarData:(NSArray<DTDimensionBarModel *> *)cachedBarData compare:(NSArray<DTDimensionBarModel *> *)barData {
    if (cachedBarData.count == 0 || barData.count == 0) {
        return;
    }

    NSMutableArray<DTDimensionBarModel *> *cachedArray = [cachedBarData mutableCopy];

    for (DTDimensionBarModel *sData in barData) {
        for (DTDimensionBarModel *s2Data in cachedArray) {

            if ([sData.title isEqualToString:s2Data.title]) {
                sData.color = s2Data.color;
                sData.secondColor = s2Data.secondColor;

                [cachedArray removeObject:s2Data];
                break;
            }
        }
    }
}

#pragma mark - override


- (void)drawChart {
    [super drawChart];

    [self.chart drawChart];

//    if (![DTManager checkExistByChartId:self.chartId]) {
//
//        [self.chart drawChart];
//
//        // 保存数据
//        [self cacheBarData];
//
//    } else {
//
//        // 加载保存的数据信息（颜色等）
//        NSDictionary *chartDic = [DTManager queryByChartId:self.chartId];
//        NSDictionary *dataDic = chartDic[@"data"];
//        NSArray *barData = dataDic[@"barData"];
//
//        [self checkBarData:barData compare:self.chart.levelLowestBarModels];
//        [self cacheBarData];
//
//        [self.chart drawChart];
//    }
}

#pragma mark - public method

- (void)setMainItem:(DTDimensionModel *)mainItem secondItem:(DTDimensionModel *)secondItem {

    self.chart.mainDimensionModel = mainItem;
    self.chart.secondDimensionModel = secondItem;

    NSUInteger divideParts = 0;
    if (self.chartMode == DTChartModeThumb) {
        divideParts = 3;
    } else if (self.chartMode == DTChartModePresentation) {
        divideParts = 5;
    }

    CGFloat itemValue = 1.0f / (divideParts - 1);
    NSMutableArray *xLabelDatas = [NSMutableArray array];
    for (NSUInteger i = 0; i < divideParts; i++) {
        DTAxisLabelData *labelData = [[DTAxisLabelData alloc] initWithTitle:[NSString stringWithFormat:@"%@%%", @(i * (NSUInteger) (itemValue * 100))] value:i * itemValue];
        [xLabelDatas addObject:labelData];
    }
    NSMutableArray *xSecondLabelDatas = [NSMutableArray array];
    for (NSUInteger i = 0; i < divideParts; i++) {
        DTAxisLabelData *labelData = [[DTAxisLabelData alloc] initWithTitle:[NSString stringWithFormat:@"%@%%", @(i * (NSUInteger) (itemValue * 100))] value:i * itemValue];
        [xSecondLabelDatas addObject:labelData];
    }

    // y轴label data
    self.chart.xAxisLabelDatas = xLabelDatas;
    self.chart.xSecondAxisLabelDatas = xSecondLabelDatas;
}

- (void)setHighlightTitle:(NSString *)highlightTitle dimensionIndex:(NSUInteger)dimensionIndex {
    [self.chart setHighlightTitle:highlightTitle dimensionIndex:dimensionIndex];
}


@end
