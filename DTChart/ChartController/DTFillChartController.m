//
//  DTFillChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTFillChartController.h"
#import "DTFillChart.h"

@interface DTFillChartController ()

@property(nonatomic) DTFillChart *chart;

@property(nonatomic) NSUInteger mMaxXAxisCount;
@property(nonatomic) NSUInteger mMaxYAxisCount;

@end

@implementation DTFillChartController

@synthesize chartView = _chartView;
@synthesize chartId = _chartId;

static NSUInteger const ChartModeThumbYAxisCount = 3;
static NSUInteger const ChartModePresentationYAxisCount = 7;

static NSUInteger const ChartModeThumbXAxisMaxCount = 5;
static NSUInteger const ChartModePresentationXAxisMaxCount = 18;


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _chart = [[DTFillChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _chartView = _chart;

        _beginRangeIndex = 0;
        _endRangeIndex = NSUIntegerMax;
    }
    return self;
}

- (void)setBeginRangeIndex:(NSUInteger)beginRangeIndex {
    _beginRangeIndex = beginRangeIndex;
    _chart.beginRangeIndex = _beginRangeIndex;
}

- (void)setEndRangeIndex:(NSUInteger)endRangeIndex {
    _endRangeIndex = endRangeIndex;
    _chart.endRangeIndex = _endRangeIndex;
}

- (NSUInteger)mMaxXAxisCount {
    _mMaxXAxisCount = ChartModeThumbXAxisMaxCount;
    switch (self.chartMode) {
        case DTChartModeThumb:
            _mMaxXAxisCount = ChartModeThumbXAxisMaxCount;
            break;
        case DTChartModePresentation:
            _mMaxXAxisCount = ChartModePresentationXAxisMaxCount;
            break;
    }
    return _mMaxXAxisCount;
}

- (NSUInteger)mMaxYAxisCount {
    _mMaxYAxisCount = ChartModeThumbYAxisCount;
    switch (self.chartMode) {
        case DTChartModeThumb:
            _mMaxYAxisCount = ChartModeThumbYAxisCount;
            break;
        case DTChartModePresentation:
            _mMaxYAxisCount = ChartModePresentationYAxisCount;
            break;
    }

    return _mMaxYAxisCount;
}


#pragma mark - private method

/**
 * 给chartId加上前缀
 * @param chartId 赋值的chartId
 */
- (void)setChartId:(NSString *)chartId {
    _chartId = [@"line-" stringByAppendingString:chartId];
}

/**
 * 处理主坐标轴数据和折线数据
 * @param listData 所有折线数据
 */
- (void)processMainAxisLabelDataAndLines:(NSArray<DTListCommonData *> *)listData {

    NSArray<DTCommonData *> *values = listData.firstObject.commonDatas;

    NSUInteger maxXAxisCount = self.mMaxXAxisCount;
    NSUInteger maxYAxisCount = self.mMaxYAxisCount;


    CGFloat maxY = 0;

    NSUInteger divide = values.count / maxXAxisCount;   // x轴平均划分有关
    CGFloat decimal = values.count * 1.0f / maxXAxisCount - values.count / maxXAxisCount;
    if (decimal > 0) {
        divide += 1;
    }


    NSMutableArray<DTAxisLabelData *> *xAxisLabelDatas = [NSMutableArray array];
    NSMutableArray<DTChartSingleData *> *lines = [NSMutableArray arrayWithCapacity:listData.count];

    NSMutableArray<DTListCommonData *> *listSecondAxisData = [NSMutableArray array];

    // x轴只需计算一次
    BOOL xAxisNeedValue = YES;

    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];

        if (!listCommonData.isMainAxis) { // 是副轴 过滤
            [listSecondAxisData addObject:listCommonData];
            continue;
        }

        values = listCommonData.commonDatas;

        NSMutableArray<DTChartItemData *> *points = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            // 找出y轴最大值，只统计[beginRangeIndex, endRangeIndex]之间的数
            if (n >= self.beginRangeIndex && n <= self.endRangeIndex) {
                if (data.ptValue > maxY) {
                    maxY = data.ptValue;
                }
            }

            if (xAxisNeedValue) {   // x轴label data，只需要取第一条折线数据计算就可以
                DTAxisLabelData *xLabelData = [[DTAxisLabelData alloc] initWithTitle:[self.axisFormatter getXAxisLabelTitle:data.ptName orValue:0] value:i];
                if (values.count > maxXAxisCount) {

                    xLabelData.hidden = i % divide != 0;

                } else {    // 全部显示
                    xLabelData.hidden = NO;
                }

                [xAxisLabelDatas addObject:xLabelData];
            }


            // 单条折线里的点
            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.itemValue = ChartItemValueMake(i, data.ptValue);
            [points addObject:itemData];
        }

        if (xAxisNeedValue) {
            // 赋值x轴数据，只需要取第一条折线数据计算就可以
            self.chart.xAxisLabelDatas = xAxisLabelDatas;
            xAxisNeedValue = NO;
        }

        // 单条折线
        DTChartSingleData *singleData = [DTChartSingleData singleData:points];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        [lines addObject:singleData];
    }

    // 赋值折线数据
    self.chart.multiData = lines;

    // y轴label data
    self.chart.yAxisLabelDatas = [super generateYAxisLabelData:maxYAxisCount yAxisMaxValue:maxY isMainAxis:YES];

    if (listSecondAxisData.count > 0) {
        [self processSecondAxisLabelDataAndLines:listSecondAxisData];
    } else {
        // 没有副轴，清除之前的副轴数据
        self.chart.secondMultiData = nil;
        self.chart.ySecondAxisLabelDatas = nil;
    }
}

- (void)processSecondAxisLabelDataAndLines:(NSArray<DTListCommonData *> *)listData {

    NSUInteger maxYAxisCount = self.mMaxYAxisCount;

    CGFloat maxY = 0;

    NSMutableArray<DTChartSingleData *> *lines = [NSMutableArray arrayWithCapacity:listData.count];

    [self generatePoints:listData yMaxValue:&maxY lines:lines constainIndexs:nil];

    // 赋值副轴折线数据
    self.chart.secondMultiData = lines;

    // y副轴label data
    self.chart.ySecondAxisLabelDatas = [super generateYAxisLabelData:maxYAxisCount yAxisMaxValue:maxY isMainAxis:NO];
}

/**
 * 生成折线里点数据
 * @param listData 所有点数据
 * @param maxY 顺带计算y轴最大值
 * @param lines 存储折线数据的数组
 * @param indexSet 生成的折线所在的位置（添加折线使用）
 */

- (void)generatePoints:(nonnull NSArray<DTListCommonData *> *)listData yMaxValue:(nullable CGFloat *)maxY lines:(nonnull NSMutableArray<DTChartSingleData *> *)lines constainIndexs:(nullable NSMutableIndexSet *)indexSet {
    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];
        NSArray<DTCommonData *> *values = listCommonData.commonDatas;

        NSMutableArray<DTChartItemData *> *points = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            // 找出y轴最大值
            if (maxY && data.ptValue > *maxY) {
                *maxY = data.ptValue;
            }


            // 单条折线里的点
            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.itemValue = ChartItemValueMake(i, data.ptValue);
            [points addObject:itemData];
        }


        // 单条折线
        DTChartSingleData *singleData = [DTChartSingleData singleData:points];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        if (indexSet) {
            [indexSet addIndex:lines.count];
        }
        [lines addObject:singleData];
    }
}

#pragma mark - override

- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat {
    [super setItems:chartId listData:listData axisFormat:axisFormat];

    [self processMainAxisLabelDataAndLines:listData];
}


- (void)drawChart {
    [super drawChart];

    [self.chart drawChart];
}

@end
