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
#import "DTTableChartSingleData.h"
#import "DTTableChartTitleOrderModel.h"

@interface DTTableChartController ()

@property(nonatomic) DTTableChart *tableChart;

@end

@implementation DTTableChartController

@synthesize chartView = _chartView;

- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _tableChart = [DTTableChart tableChart:DTTableChartStyleC1C2 origin:origin widthCellCount:xCount heightCellCount:yCount];
        _tableChart.headViewHeight = 500;

        WEAK_SELF;
        [_tableChart setExpandTouchBlock:^(NSString *seriesId) {
            if (weakSelf.tableChartExpandTouchBlock) {
                weakSelf.tableChartExpandTouchBlock(seriesId);
            }
        }];
        [_tableChart setOrderTouchBlock:^(NSUInteger column) {
            if (weakSelf.tableChartOrderTouchBlock) {
                weakSelf.tableChartOrderTouchBlock(column);
            }
        }];

        _chartView = _tableChart;
    }
    return self;
}

- (void)setCollapseColumn:(NSInteger)collapseColumn {
    _collapseColumn = collapseColumn;

    _tableChart.collapseColumn = _collapseColumn;
}


#pragma mark - private method

- (void)processMainAxisLabelDataAndLines:(NSArray<DTListCommonData *> *)listData {

    NSMutableArray<DTListCommonData *> *listSecondAxisData = [NSMutableArray array];

    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];
    NSMutableArray<DTChartSingleData *> *rows = [NSMutableArray arrayWithCapacity:listData.count];

    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];
        if (!listCommonData.isMainAxis) { // 是副轴 过滤
            [listSecondAxisData addObject:listCommonData];
            continue;
        }


        NSArray<DTCommonData *> *values = listCommonData.commonDatas;
        NSMutableArray<DTChartItemData *> *points = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            if (n == 0) {
                DTTableAxisLabelData *yLabelData = [[DTTableAxisLabelData alloc] initWithTitle:data.ptName value:i];
                if (self.titleOrderModels.count > i) {
                    DTTableChartTitleOrderModel *orderModel = self.titleOrderModels[i];
                    yLabelData.showOrder = orderModel.showOrder;
                    yLabelData.ascending = orderModel.ascending;
                }
                [yAxisLabelDatas addObject:yLabelData];
            }


            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.title = data.ptStringValue;
            [points addObject:itemData];
        }

        DTTableChartSingleData *singleData = [DTTableChartSingleData singleData:points];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        [rows addObject:singleData];
    }

    self.tableChart.yAxisLabelDatas = yAxisLabelDatas;
    self.tableChart.multiData = rows;

    if (listSecondAxisData.count > 0) {
        [self processSecondAxisLabelDataAndLines:listSecondAxisData];
    } else {
        // 没有副轴，清除之前的副轴数据
        self.tableChart.secondMultiData = nil;
        self.tableChart.ySecondAxisLabelDatas = nil;
    }
}


- (void)processSecondAxisLabelDataAndLines:(NSArray<DTListCommonData *> *)listData {
    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];
    NSMutableArray<DTChartSingleData *> *columns = [NSMutableArray arrayWithCapacity:listData.count];

    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];

        NSArray<DTCommonData *> *values = listCommonData.commonDatas;
        NSMutableArray<DTChartItemData *> *points = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            if (n == 0) {
                DTTableAxisLabelData *yLabelData = [[DTTableAxisLabelData alloc] initWithTitle:data.ptName value:i];
                if (self.titleOrderModels.count > i) {
                    DTTableChartTitleOrderModel *orderModel = self.titleOrderModels[i];
                    yLabelData.showOrder = orderModel.showOrder;
                    yLabelData.ascending = orderModel.ascending;
                }
                [yAxisLabelDatas addObject:yLabelData];
            }

            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.title = data.ptStringValue;
            [points addObject:itemData];
        }

        DTTableChartSingleData *singleData = [DTTableChartSingleData singleData:points];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        [columns addObject:singleData];
    }

    self.tableChart.ySecondAxisLabelDatas = yAxisLabelDatas;
    self.tableChart.secondMultiData = columns;

}

- (DTTableChartStyle)getTableChartStyle:(NSUInteger)mainAxisColumnCount secondAxis:(NSUInteger)secondAxisColumnCount {
    if (secondAxisColumnCount == 0) {
        if (mainAxisColumnCount <= 3) {
            return DTTableChartStyleC1C2;
        } else if (mainAxisColumnCount == 4) {
            return DTTableChartStyleC1C3;
        } else if (mainAxisColumnCount == 5) {
            return DTTableChartStyleC1C4;
        } else if (mainAxisColumnCount == 6) {
            return DTTableChartStyleC1C5;
        } else if (mainAxisColumnCount == 7) {
            return DTTableChartStyleC1C6;
        } else if (mainAxisColumnCount == 8) {
            return DTTableChartStyleC1C7;
        } else if (mainAxisColumnCount == 9) {
            return DTTableChartStyleC1C8;
        } else if (mainAxisColumnCount == 10) {
            return DTTableChartStyleC1C9;
        } else if (mainAxisColumnCount >= 11 && mainAxisColumnCount <= 16) {
            return DTTableChartStyleC1C1C14;
        } else if (mainAxisColumnCount >= 17) {
            return DTTableChartStyleC1C1C31;
        }
    } else if (secondAxisColumnCount <= 3) {
        return DTTableChartStyleT2C1C2;
    } else if (secondAxisColumnCount == 4) {
        return DTTableChartStyleT2C1C3;
    } else if (secondAxisColumnCount >= 5) {
        return DTTableChartStyleT2C1C4;
    }

    return DTTableChartStyleC1C2;
}


#pragma mark - public method

- (void)addExpandItems:(NSArray<DTListCommonData *> *)listData {

    NSMutableArray<DTTableChartSingleData *> *mainRows = [NSMutableArray array];
    NSMutableArray<DTTableChartSingleData *> *secondRows = [NSMutableArray array];

    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];

        NSArray<DTCommonData *> *values = listCommonData.commonDatas;
        NSMutableArray<DTChartItemData *> *points = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.title = data.ptStringValue;
            [points addObject:itemData];
        }

        DTTableChartSingleData *singleData = [DTTableChartSingleData singleData:points];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        singleData.headerRow = NO;

        if (listCommonData.isMainAxis) {
            [mainRows addObject:singleData];
        } else {
            [secondRows addObject:singleData];
        }
    }

    [self.tableChart addExpandItems:mainRows];
}

#pragma mark - override

- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat {
    [super setItems:chartId listData:listData axisFormat:axisFormat];

    [self processMainAxisLabelDataAndLines:listData];

    self.tableChart.tableChartStyle = [self getTableChartStyle:self.tableChart.yAxisLabelDatas.count secondAxis:self.tableChart.ySecondAxisLabelDatas.count];
}

- (void)drawChart {
    [super drawChart];

    [self.tableChart drawChart];
}

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation {

}

- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation {
    [self.tableChart deleteItems:seriesIds];
}

@end
