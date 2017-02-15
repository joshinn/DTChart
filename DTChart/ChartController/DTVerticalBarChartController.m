//
//  DTVerticalBarChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/13.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTVerticalBarChartController.h"
#import "DTVerticalBarChart.h"
#import "DTDataManager.h"

@interface DTVerticalBarChartController ()

@property(nonatomic) DTVerticalBarChart *barChart;

@property(nonatomic) NSUInteger mMaxXAxisCount;
@property(nonatomic) NSUInteger mMaxYAxisCount;


@end

@implementation DTVerticalBarChartController

static NSUInteger const ChartModeThumbYAxisCount = 3;
static NSUInteger const ChartModePresentationYAxisCount = 7;

static NSUInteger const ChartModeThumbXAxisMaxCount = 5;
static NSUInteger const ChartModePresentationXAxisMaxCount = 18;


@synthesize chartView = _chartView;
@synthesize chartId = _chartId;
@synthesize chartMode = _chartMode;

- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _barChart = [[DTVerticalBarChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _barChart.barChartStyle = DTBarChartStyleLump;
        _barChart.valueSelectable = NO;
        _chartView = _barChart;


        WEAK_SELF;
        [_barChart setColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
            if (weakSelf.mainAxisColorsCompletionBlock) {
                weakSelf.mainAxisColorsCompletionBlock(infos);
            }
        }];

    }
    return self;
}

- (void)setChartMode:(DTChartMode)chartMode {
    _chartMode = chartMode;

    switch (_chartMode) {

        case DTChartModeThumb: {
            self.barChart.barChartStyle = DTBarChartStyleLump;
        }
            break;
        case DTChartModePresentation: {
            self.barChart.barChartStyle = DTBarChartStyleStartingLine;
        }
            break;
    }
}

- (void)setBarWidth:(CGFloat)barWidth {
    _barWidth = barWidth;

    _barChart.barWidth = barWidth;
}

- (NSUInteger)mMaxXAxisCount:(NSUInteger)valuesCount {
    _mMaxXAxisCount = ChartModeThumbYAxisCount;
    switch (self.chartMode) {
        case DTChartModeThumb: {
            if (valuesCount <= self.barChart.xAxisCellCount / 2) {
                _mMaxXAxisCount = valuesCount;
            } else {
                _mMaxXAxisCount = ChartModeThumbXAxisMaxCount;
            }
        }
            break;
        case DTChartModePresentation:
            if (valuesCount <= self.barChart.xAxisCellCount / 2) {
                _mMaxXAxisCount = valuesCount;
            } else {
                _mMaxXAxisCount = ChartModePresentationXAxisMaxCount;
            }
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

/**
 * 给chartId加上前缀
 * @param chartId 赋值的chartId
 */
- (void)setChartId:(NSString *)chartId {
    _chartId = [@"vBar-" stringByAppendingString:chartId];
}

#pragma mark - private method

/**
 * 生成坐标系的坐标轴和柱状体的数据
 * @param listData 所有数据
 * @param remain 保留原来的multiData
 */
- (void)processMainAxisLabelDataAndBars:(NSArray<DTListCommonData *> *)listData remainData:(BOOL)remain {
    NSArray<DTCommonData *> *values = listData.firstObject.commonDatas;

    NSUInteger maxXAxisCount = [self mMaxXAxisCount:values.count];
    NSUInteger maxYAxisCount = self.mMaxYAxisCount;

    CGFloat maxY = 0;

    if (remain) {
        // 找出已有的最大值做对比
        for(DTChartSingleData *sData in self.barChart.multiData){
            for(DTChartItemData *itemData in sData.itemValues){
                maxY = MAX(maxY, itemData.itemValue.y);
            }
        }
    }


    NSUInteger divide = values.count / maxXAxisCount;   // x轴平均划分有关
    CGFloat decimal = values.count * 1.0f / maxXAxisCount - values.count / maxXAxisCount;
    if (decimal > 0) {
        divide += 1;
    }


    NSMutableArray<DTAxisLabelData *> *xAxisLabelDatas = [NSMutableArray array];
    NSMutableArray<DTChartSingleData *> *bars = [NSMutableArray arrayWithCapacity:listData.count];

    NSMutableArray<DTListCommonData *> *listSecondAxisData = [NSMutableArray array];

    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];

        if (!listCommonData.isMainAxis) { // 是副轴 过滤
            [listSecondAxisData addObject:listCommonData];
            continue;
        }

        values = listCommonData.commonDatas;

        NSMutableArray<DTChartItemData *> *bar = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            // 找出y轴最大值
            if (data.ptValue > maxY) {
                maxY = data.ptValue;
            }

            if (n == 0) {   // x轴label data，只需要取第一个柱状体数据计算就可以
                DTAxisLabelData *xLabelData = [[DTAxisLabelData alloc] initWithTitle:[self.axisFormatter getXAxisLabelTitle:data.ptName orValue:0] value:i];
                if (values.count > maxXAxisCount) {

                    xLabelData.hidden = i % divide != 0;

                } else {    // 全部显示
                    xLabelData.hidden = NO;
                }

                [xAxisLabelDatas addObject:xLabelData];
            }

            // 单个柱状体
            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.itemValue = ChartItemValueMake(i, data.ptValue);
            [bar addObject:itemData];
        }

        if (n == 0) {
            // 赋值x轴数据，只需要取第一个柱状体数据计算就可以
            self.barChart.xAxisLabelDatas = xAxisLabelDatas;
        }

        // 单个柱状体
        DTChartSingleData *singleData = [DTChartSingleData singleData:bar];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        [bars addObject:singleData];
    }

    // 赋值柱状体数据
    if (remain) {
        NSMutableArray<DTChartSingleData *> *mutableArray = [NSMutableArray array];
        if (self.barChart.multiData.count > 0) {
            [mutableArray addObjectsFromArray:self.barChart.multiData];
        }
        [mutableArray addObjectsFromArray:bars];
        self.barChart.multiData = mutableArray.copy;
    } else {
        self.barChart.multiData = bars;
    }

    // y轴label data
    self.barChart.yAxisLabelDatas = [super generateYAxisLabelData:maxYAxisCount yAxisMaxValue:maxY isMainAxis:YES];
}

/**
 * 把柱状图图的multiData和secondMultiData缓存起来
 */
- (void)cacheMultiData {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (self.barChart.multiData.count > 0) {
        dataDic[@"multiData"] = self.barChart.multiData;
    }
    if (self.barChart.secondMultiData.count > 0) {
        dataDic[@"secondMultiData"] = self.barChart.secondMultiData;
    }

    [DTManager addChart:self.chartId object:@{@"data": dataDic}];
}

/**
 * 对比已缓存的数据和当前的新数据，给新数据修正颜色等信息
 * @param cachedMultiData 已缓存的数据
 * @param multiData 当前的新数据
 */
- (void)checkMultiData:(NSArray<DTChartSingleData *> *)cachedMultiData compare:(NSArray<DTChartSingleData *> *)multiData {
    if (cachedMultiData.count == 0 || multiData.count == 0) {
        return;
    }

    NSMutableArray *cachedArray = [cachedMultiData mutableCopy];

    for (DTChartSingleData *sData in multiData) {
        for (DTChartSingleData *s2Data in cachedArray) {

            if ([sData.singleId isEqualToString:s2Data.singleId]) {
                sData.color = s2Data.color;
                sData.secondColor = s2Data.secondColor;
                sData.lineWidth = s2Data.lineWidth;

                [cachedArray removeObject:s2Data];
                break;
            }
        }
    }
}


#pragma mark - override

- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat {
    [super setItems:chartId listData:listData axisFormat:axisFormat];

    [self processMainAxisLabelDataAndBars:listData remainData:NO];
}

- (void)drawChart {
    [super drawChart];

    if (![DTManager checkExistByChartId:self.chartId]) {

        [self.barChart drawChart];

        // 保存数据
        [self cacheMultiData];

    } else {

        // 加载保存的数据信息（颜色等）
        NSDictionary *chartDic = [DTManager queryByChartId:self.chartId];
        NSDictionary *dataDic = chartDic[@"data"];
        NSArray *multiData = dataDic[@"multiData"];
        NSArray *secondMultiData = dataDic[@"secondMultiData"];

        [self checkMultiData:multiData compare:self.barChart.multiData];
        [self checkMultiData:secondMultiData compare:self.barChart.secondMultiData];
        [self cacheMultiData];

        [self.barChart drawChart];
    }
}

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation {

    BOOL ani = self.barChart.isShowAnimation;
    self.showAnimation = animation;
    [self processMainAxisLabelDataAndBars:listData remainData:YES];
    [self drawChart];
    self.barChart.showAnimation = ani;
}


- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];

    for (NSString *seriesId in seriesIds) {
        for (NSUInteger i = 0; i < self.barChart.multiData.count; ++i) {
            DTChartSingleData *sData = self.barChart.multiData[i];
            if ([sData.singleId isEqualToString:seriesId]) {
                [indexSet addIndex:i];

                break;
            }
        }
    }
    if (indexSet.count > 0) {

        [self.barChart deleteChartItems:indexSet withAnimation:animation];

        BOOL ani = self.barChart.isShowAnimation;
        self.showAnimation = animation;
        [self drawChart];
        self.barChart.showAnimation = ani;
    }
}



@end
