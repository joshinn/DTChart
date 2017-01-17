//
//  DTTableChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/13.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTTableChartController.h"
#import "DTTableChart.h"
#import "DTTableAxisLabelData.h"

@interface DTTableChartController ()

@property(nonatomic) DTTableChart *tableChart;

@end

@implementation DTTableChartController

@synthesize chartView = _chartView;

- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _tableChart = [DTTableChart tableChart:DTTableChartStyleC1C2 origin:origin widthCellCount:xCount heightCellCount:yCount];
        _tableChart.headViewHeight = 500;
        _tableChart.headView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];

        _chartView = _tableChart;
    }
    return self;
}


#pragma mark - private method

- (void)processMainAxisLabelDataAndLines:(NSArray<DTListCommonData *> *)listData {

    NSMutableArray<DTListCommonData *> *listSecondAxisData = [NSMutableArray array];

    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];
    NSMutableArray<DTChartSingleData *> *columns = [NSMutableArray arrayWithCapacity:listData.count];

    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];
        if (!listCommonData.isMainAxis) { // 是副轴 过滤
            [listSecondAxisData addObject:listCommonData];
            continue;
        }

        DTTableAxisLabelData *yLabelData = [[DTTableAxisLabelData alloc] initWithTitle:listCommonData.seriesName value:n];
        [yAxisLabelDatas addObject:yLabelData];

        NSArray<DTCommonData *> *values = listCommonData.commonDatas;
        NSMutableArray<DTChartItemData *> *points = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.itemValue = ChartItemValueMake(i, data.ptValue);
            itemData.title = data.ptName;
            [points addObject:itemData];
        }

        DTChartSingleData *singleData = [DTChartSingleData singleData:points];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        [columns addObject:singleData];
    }

    self.tableChart.yAxisLabelDatas = yAxisLabelDatas;
    self.tableChart.multiData = columns;

    if (listSecondAxisData.count > 0) {
        [self processSecondAxisLabelDataAndLines:listSecondAxisData];
    }
}


- (void)processSecondAxisLabelDataAndLines:(NSArray<DTListCommonData *> *)listData {
    NSMutableArray<DTAxisLabelData *> *xAxisLabelDatas = [NSMutableArray array];
    NSMutableArray<DTChartSingleData *> *columns = [NSMutableArray arrayWithCapacity:listData.count];

    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];

        DTTableAxisLabelData *xLabelData = [[DTTableAxisLabelData alloc] initWithTitle:listCommonData.seriesName value:n];
        [xAxisLabelDatas addObject:xLabelData];

        NSArray<DTCommonData *> *values = listCommonData.commonDatas;
        NSMutableArray<DTChartItemData *> *points = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.itemValue = ChartItemValueMake(i, data.ptValue);
            itemData.title = data.ptName;
            [points addObject:itemData];
        }

        DTChartSingleData *singleData = [DTChartSingleData singleData:points];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        [columns addObject:singleData];
    }

    self.tableChart.ySecondAxisLabelDatas = xAxisLabelDatas;
    self.tableChart.secondMultiData = columns;

}

#pragma mark - override

- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat {
    [super setItems:chartId listData:listData axisFormat:axisFormat];

    [self processMainAxisLabelDataAndLines:listData];

}

- (void)drawChart {
    [super drawChart];

    [self.tableChart drawChart];
}

@end
