//
//  DTLineChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTLineChartController.h"
#import "DTLineChart.h"
#import "DTLineChartSingleData.h"
#import "DTDataManager.h"

@interface DTLineChartController ()

@property(nonatomic) DTLineChart *lineChart;

@property(nonatomic) NSUInteger mMaxXAxisCount;
@property(nonatomic) NSUInteger mMaxYAxisCount;


@end


@implementation DTLineChartController

static NSUInteger const ChartModeThumbYAxisCount = 3;
static NSUInteger const ChartModePresentationYAxisCount = 7;

static NSUInteger const ChartModeThumbXAxisMaxCount = 5;
static NSUInteger const ChartModePresentationXAxisMaxCount = 18;


@synthesize chartView = _chartView;
@synthesize chartId = _chartId;

- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _lineChart = [[DTLineChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _chartView = _lineChart;

        __weak typeof(self) weakSelf = self;
        [_lineChart setLineChartTouchBlock:^(NSUInteger lineIndex, NSUInteger pointIndex, BOOL isMainAxis) {
            if (weakSelf.lineChartTouchBlock) {
                NSString *seriesId = nil;
                if (isMainAxis) {
                    seriesId = weakSelf.lineChart.multiData[lineIndex].singleId;
                } else {
                    seriesId = weakSelf.lineChart.secondMultiData[lineIndex].singleId;
                }
                weakSelf.lineChartTouchBlock(seriesId, pointIndex);
            }
        }];

        [_lineChart setColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
            if (weakSelf.mainAxisColorsCompletionBlock) {
                weakSelf.mainAxisColorsCompletionBlock(infos);
            }
        }];

        [_lineChart setSecondAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
            if (weakSelf.secondAxisColorsCompletionBlock) {
                weakSelf.secondAxisColorsCompletionBlock(infos);
            }
        }];
    }
    return self;
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
    NSMutableArray<DTLineChartSingleData *> *lines = [NSMutableArray arrayWithCapacity:listData.count];

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

            // 找出y轴最大值
            if (data.ptValue > maxY) {
                maxY = data.ptValue;
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
            self.lineChart.xAxisLabelDatas = xAxisLabelDatas;
        }

        // 单条折线
        DTLineChartSingleData *singleData = [DTLineChartSingleData singleData:points];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        [lines addObject:singleData];
    }

    // 赋值折线数据
    self.lineChart.multiData = lines;

    // y轴label data
    self.lineChart.yAxisLabelDatas = [super generateYAxisLabelData:maxYAxisCount yAxisMaxValue:maxY isMainAxis:YES];

    if (listSecondAxisData.count > 0) {
        [self processSecondAxisLabelDataAndLines:listSecondAxisData];
    } else {
        // 没有副轴，清除之前的副轴数据
        self.lineChart.secondMultiData = nil;
        self.lineChart.ySecondAxisLabelDatas = nil;
    }
}

- (void)processSecondAxisLabelDataAndLines:(NSArray<DTListCommonData *> *)listData {

    NSUInteger maxYAxisCount = self.mMaxYAxisCount;

    CGFloat maxY = 0;

    NSMutableArray<DTLineChartSingleData *> *lines = [NSMutableArray arrayWithCapacity:listData.count];

    [self generatePoints:listData yMaxValue:&maxY lines:lines constainIndexs:nil];

    // 赋值副轴折线数据
    self.lineChart.secondMultiData = lines;

    // y副轴label data
    self.lineChart.ySecondAxisLabelDatas = [super generateYAxisLabelData:maxYAxisCount yAxisMaxValue:maxY isMainAxis:NO];
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

                if ([sData isKindOfClass:[DTLineChartSingleData class]] && [s2Data isKindOfClass:[DTLineChartSingleData class]]) {
                    DTLineChartSingleData *sLineData = (DTLineChartSingleData *) sData;
                    DTLineChartSingleData *s2LineData = (DTLineChartSingleData *) s2Data;
                    sLineData.pointType = s2LineData.pointType;
                }

                [cachedArray removeObject:s2Data];
                break;
            }
        }
    }
}

/**
 * 把折线图的multiData和secondMultiData缓存起来
 */
- (void)cacheMultiData {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (self.lineChart.multiData.count > 0) {
        dataDic[@"multiData"] = self.lineChart.multiData;
    }
    if (self.lineChart.secondMultiData.count > 0) {
        dataDic[@"secondMultiData"] = self.lineChart.secondMultiData;
    }

    [DTManager addChart:self.chartId object:@{@"data": dataDic}];
}

/**
 * 生成折线里点数据
 * @param listData 所有点数据
 * @param maxY 顺带计算y轴最大值
 * @param lines 存储折线数据的数组
 * @param indexSet 生成的折线所在的位置（添加折线使用）
 */

- (void)generatePoints:(nonnull NSArray<DTListCommonData *> *)listData yMaxValue:(nullable CGFloat *)maxY lines:(nonnull NSMutableArray<DTLineChartSingleData *> *)lines constainIndexs:(nullable NSMutableIndexSet *)indexSet {
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
        DTLineChartSingleData *singleData = [DTLineChartSingleData singleData:points];
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

    if (![DTManager checkExistByChartId:self.chartId]) {

        [self.lineChart drawChart];

        // 保存数据
        [self cacheMultiData];

    } else {

        // 加载保存的数据信息（颜色等）
        NSDictionary *chartDic = [DTManager queryByChartId:self.chartId];
        NSDictionary *dataDic = chartDic[@"data"];
        NSArray *multiData = dataDic[@"multiData"];
        NSArray *secondMultiData = dataDic[@"secondMultiData"];

        [self checkMultiData:multiData compare:self.lineChart.multiData];
        [self checkMultiData:secondMultiData compare:self.lineChart.secondMultiData];
        [self cacheMultiData];

        [self.lineChart drawChart];
    }
}

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation {

    DTAxisLabelData *yAxisLabelData = self.lineChart.yAxisLabelDatas.lastObject;
    DTAxisLabelData *ySecondAxisLabelData = self.lineChart.ySecondAxisLabelDatas.lastObject;

    CGFloat maxMainAxisY = 0;
    CGFloat maxSecondAxisY = 0;
    NSMutableArray *mainAxisDatas = [NSMutableArray array];
    NSMutableArray *secondAxisDatas = [NSMutableArray array];
    for (DTListCommonData *listCommonData in listData) {
        if (listCommonData.isMainAxis) {

            for (DTCommonData *commonData in listCommonData.commonDatas) {
                if (commonData.ptValue > maxMainAxisY) {
                    maxMainAxisY = commonData.ptValue;
                }
            }

            [mainAxisDatas addObject:listCommonData];
        } else {

            for (DTCommonData *commonData in listCommonData.commonDatas) {
                if (commonData.ptValue > maxSecondAxisY) {
                    maxSecondAxisY = commonData.ptValue;
                }
            }

            [secondAxisDatas addObject:listCommonData];
        }
    }

    BOOL needRedrawAxis = NO;

    NSUInteger maxYAxisCount = self.mMaxYAxisCount;

    if (maxMainAxisY > yAxisLabelData.value) {    // y主轴需要重绘了
        needRedrawAxis = YES;

        // y轴label data
        self.lineChart.yAxisLabelDatas = [super generateYAxisLabelData:maxYAxisCount yAxisMaxValue:maxMainAxisY isMainAxis:YES];
    }

    CGFloat ySecondAxisValue = (ySecondAxisLabelData != nil) ? ySecondAxisLabelData.value : 0;
    if (maxSecondAxisY > ySecondAxisValue) { // y副轴需要重绘了
        needRedrawAxis = YES;

        // y轴label data
        self.lineChart.ySecondAxisLabelDatas = [super generateYAxisLabelData:maxYAxisCount yAxisMaxValue:maxSecondAxisY isMainAxis:NO];
    }


    if (needRedrawAxis) {
        BOOL ani = self.lineChart.isShowAnimation;
        self.lineChart.showAnimation = NO;
        [self.lineChart drawChart];
        self.lineChart.showAnimation = ani;
    }


    // 主轴的点
    NSMutableArray<DTLineChartSingleData *> *mainAxisLines = self.lineChart.multiData.mutableCopy;
    if (!mainAxisLines) {
        mainAxisLines = [NSMutableArray array];
    }
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [self generatePoints:mainAxisDatas yMaxValue:nil lines:mainAxisLines constainIndexs:indexSet];


    // 副轴的点
    NSMutableArray<DTLineChartSingleData *> *secondAxisLines = self.lineChart.secondMultiData.mutableCopy;
    if (!secondAxisLines) {
        secondAxisLines = [NSMutableArray array];
    }
    NSMutableIndexSet *secondIndexSet = [NSMutableIndexSet indexSet];

    [self generatePoints:secondAxisDatas yMaxValue:nil lines:secondAxisLines constainIndexs:secondIndexSet];

    // 赋值折线数据
    self.lineChart.multiData = mainAxisLines;
    [self.lineChart insertChartItems:indexSet withAnimation:animation];

    if (secondIndexSet.count > 0) {
        self.lineChart.secondMultiData = secondAxisLines;
        [self.lineChart insertChartSecondAxisItems:secondIndexSet withAnimation:animation];
    }

    // 保存数据
    [self cacheMultiData];
}

- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];

    NSMutableArray<NSString *> *sIds = seriesIds.mutableCopy;
    for (NSString *seriesId in seriesIds) {
        for (NSUInteger i = 0; i < self.lineChart.multiData.count; ++i) {
            DTChartSingleData *sData = self.lineChart.multiData[i];
            if ([sData.singleId isEqualToString:seriesId]) {
                [indexSet addIndex:i];

                [sIds removeObject:seriesId];
                break;
            }
        }
    }
    if (indexSet.count > 0) {
        [self.lineChart deleteChartItems:indexSet withAnimation:animation];
    }

    if (sIds.count > 0) {
        [indexSet removeAllIndexes];
        for (NSString *seriesId in sIds) {
            for (NSUInteger i = 0; i < self.lineChart.secondMultiData.count; ++i) {
                DTChartSingleData *sData = self.lineChart.secondMultiData[i];
                if ([sData.singleId isEqualToString:seriesId]) {
                    [indexSet addIndex:i];
                    break;
                }
            }
        }
        if (indexSet.count > 0) {
            [self.lineChart deleteChartSecondAxisItems:indexSet withAnimation:animation];
        }
    }



    // 保存数据
    [self cacheMultiData];
}

@end
