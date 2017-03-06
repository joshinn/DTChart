//
//  DTDimensionVerticalBarChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/28.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionVerticalBarChartController.h"
#import "DTDimensionVerticalBarChart.h"
#import "DTDimensionModel.h"
#import "DTDimensionReturnModel.h"
#import "DTDataManager.h"
#import "DTDimensionBarModel.h"

@interface DTDimensionVerticalBarChartController ()

@property(nonatomic) DTDimensionVerticalBarChart *chart;

@end

@implementation DTDimensionVerticalBarChartController

@synthesize chartView = _chartView;
@synthesize chartId = _chartId;


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _chart = [[DTDimensionVerticalBarChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _chartView = _chart;

        _chart.barWidth = 2;

        WEAK_SELF;
        [_chart setBarChartTouchBlock:^NSString *(NSUInteger touchIndex) {
            if (weakSelf.dimensionBarChartControllerTouchBlock) {
                return weakSelf.dimensionBarChartControllerTouchBlock(touchIndex);
            }
            return nil;
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
    _chartId = [@"vDimBar-" stringByAppendingString:chartId];
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


    if (![DTManager checkExistByChartId:self.chartId]) {

        [self.chart drawChart];

        // 保存数据
        [self cacheBarData];

    } else {

        // 加载保存的数据信息（颜色等）
        NSDictionary *chartDic = [DTManager queryByChartId:self.chartId];
        NSDictionary *dataDic = chartDic[@"data"];
        NSArray *barData = dataDic[@"barData"];

        [self checkBarData:barData compare:self.chart.levelLowestBarModels];
        [self cacheBarData];

        [self.chart drawChart];
    }
}

#pragma mark - public method

- (void)setItem:(DTDimensionModel *)dimensionModel {
    self.chart.dimensionModel = dimensionModel;

    DTDimensionReturnModel *returnModel = [self.chart calculate:dimensionModel];
    ChartEdgeInsets insets = self.chart.coordinateAxisInsets;
    self.chart.coordinateAxisInsets = ChartEdgeInsetsMake(insets.left, insets.top, insets.right, (NSUInteger) returnModel.level);

    self.chart.xOffset = (CGRectGetWidth(self.chart.contentView.bounds) - returnModel.sectionWidth) / 2;
    self.chart.xOffset = (NSInteger) (self.chart.xOffset / 15) * 15;

    // y轴label data
    self.chart.yAxisLabelDatas = [super generateYAxisLabelData:4 yAxisMaxValue:self.chart.maxY isMainAxis:YES];
}

@end
