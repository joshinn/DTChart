//
//  DTFillChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTFillChartController.h"
#import "DTFillChart.h"
#import "DTChartLabel.h"

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

        WEAK_SELF;
        [_chart setFillChartTouchBlock:^NSString *(NSUInteger lineIndex, NSUInteger pointIndex) {
            if (weakSelf.fillChartTouchBlock) {
                return weakSelf.fillChartTouchBlock(weakSelf.chart.multiData.count - lineIndex - 1, pointIndex);
            }
            return nil;
        }];
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

            if (n == 0) {   // x轴label data，只需要取第一条折线数据计算就可以
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

        if (n == 0) {
            // 赋值x轴数据，只需要取第一条折线数据计算就可以
            self.chart.xAxisLabelDatas = xAxisLabelDatas;
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

    self.chart.mainNotationLabel.text = [self.axisFormatter getNotationLabelText:YES];
}


#pragma mark - override

- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat {
    [super setItems:chartId listData:listData axisFormat:axisFormat];

    // FillChart 第一组数据是最小值，所以逆序
    [self processMainAxisLabelDataAndLines:listData.reverseObjectEnumerator.allObjects];
}


- (void)drawChart {
    [super drawChart];

    [self.chart drawChart];
}

@end
