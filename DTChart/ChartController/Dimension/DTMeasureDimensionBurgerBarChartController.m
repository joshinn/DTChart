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
        _chart.yOffset = 2 * _chart.coordinateAxisCellWidth;
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

    NSMutableArray *xLabelDatas = [NSMutableArray array];
    for (NSUInteger i = 0; i < 5; i++) {
        DTAxisLabelData *labelData = [[DTAxisLabelData alloc] initWithTitle:[NSString stringWithFormat:@"%@%%", @(i * 25)] value:i * 0.25f];
        [xLabelDatas addObject:labelData];
    }
    NSMutableArray *xSecondLabelDatas = [NSMutableArray array];
    for (NSUInteger i = 0; i < 5; i++) {
        DTAxisLabelData *labelData = [[DTAxisLabelData alloc] initWithTitle:[NSString stringWithFormat:@"%@%%", @(i * 25)] value:i * 0.25f];
        [xSecondLabelDatas addObject:labelData];
    }

    // y轴label data
    self.chart.xAxisLabelDatas = xLabelDatas;
    self.chart.xSecondAxisLabelDatas = xSecondLabelDatas;
}


@end
