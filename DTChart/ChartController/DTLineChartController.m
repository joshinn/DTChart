//
//  DTLineChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTLineChartController.h"
#import "DTLineChart.h"
#import "DTCommonData.h"
#import "DTLineChartSingleData.h"
#import "DTDataManager.h"

@interface DTLineChartController ()

@property(nonatomic) DTLineChart *lineChart;

@end


@implementation DTLineChartController

static NSUInteger const ChartModeThumbYAxisCount = 3;
static NSUInteger const ChartModePresentationYAxisCount = 7;

static NSUInteger const ChartModeThumbXAxisMaxCount = 5;
static NSUInteger const ChartModePresentationXAxisMaxCount = 18;


@synthesize chartView = _chartView;

- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {

        _lineChart = [[DTLineChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _lineChart.contentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    }
    return self;
}


- (void)initial {

}


- (UIView *)chartView {
    if (!_chartView) {
        _chartView = self.lineChart;
    }
    return _chartView;
}


/**
 * 处理主坐标轴数据和折线数据
 * @param listData 所有折线数据
 */
- (void)processMainAxisLabelDataAndLines:(NSArray<DTListCommonData *> *)listData {

    NSArray<DTCommonData *> *values = listData.firstObject.commonDatas;

    NSUInteger maxXAxisCount = ChartModeThumbXAxisMaxCount;
    NSUInteger maxYAxisCount = ChartModeThumbYAxisCount;
    switch (self.chartMode) {
        case DTChartModeThumb:
            maxYAxisCount = ChartModeThumbYAxisCount;
            maxXAxisCount = ChartModeThumbXAxisMaxCount;
            break;
        case DTChartModePresentation:
            maxYAxisCount = ChartModePresentationYAxisCount;
            maxXAxisCount = ChartModePresentationXAxisMaxCount;
            break;
    }

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
                DTAxisLabelData *xLabelData = [[DTAxisLabelData alloc] initWithTitle:data.ptName value:i];
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
    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];

    for (NSUInteger i = 0; i <= maxYAxisCount; ++i) {
        CGFloat y = maxY / maxYAxisCount * i;

        NSString *title = [NSString stringWithFormat:self.axisFormat, y];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:y]];
    }

    self.lineChart.yAxisLabelDatas = yAxisLabelDatas;

    if (listSecondAxisData.count > 0) {
        [self processSecondAxisLabelDataAndLines:listSecondAxisData];
    }
}

- (void)processSecondAxisLabelDataAndLines:(NSArray<DTListCommonData *> *)listData {

    NSUInteger maxYAxisCount = ChartModeThumbYAxisCount;
    switch (self.chartMode) {
        case DTChartModeThumb:
            maxYAxisCount = ChartModeThumbYAxisCount;
            break;
        case DTChartModePresentation:
            maxYAxisCount = ChartModePresentationYAxisCount;
            break;
    }

    CGFloat maxY = 0;


    NSMutableArray<DTLineChartSingleData *> *lines = [NSMutableArray arrayWithCapacity:listData.count];

    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];
        NSArray<DTCommonData *> *values = listCommonData.commonDatas;

        NSMutableArray<DTChartItemData *> *points = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            // 找出y轴最大值
            if (data.ptValue > maxY) {
                maxY = data.ptValue;
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
        [lines addObject:singleData];
    }

    // 赋值折线数据
    self.lineChart.secondMultiData = lines;

    // y轴label data
    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];

    for (NSUInteger i = 0; i <= maxYAxisCount; ++i) {
        CGFloat y = maxY / maxYAxisCount * i;

        NSString *title = [NSString stringWithFormat:self.axisFormat, y];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:y]];
    }

    self.lineChart.ySecondAxisLabelDatas = yAxisLabelDatas;
}

/**
 * 对比已缓存的数据和当前的新数据，给新数据修正颜色等信息
 * @param cachedMultiData 已缓存的数据
 * @param multiData 当前的新数据
 */
- (void)checkMultiData:(NSArray<DTLineChartSingleData *> *)cachedMultiData compare:(NSArray<DTLineChartSingleData *> *)multiData {
    if (cachedMultiData.count == 0 || multiData.count == 0) {
        return;
    }

    NSMutableArray *cachedArray = [cachedMultiData mutableCopy];

    for (DTLineChartSingleData *sData in multiData) {
        for (DTLineChartSingleData *s2Data in cachedArray) {

            if ([sData.singleId isEqualToString:s2Data.singleId]) {
                sData.color = s2Data.color;
                sData.secondColor = s2Data.secondColor;
                sData.lineWidth = s2Data.lineWidth;
                sData.pointType = s2Data.pointType;

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

#pragma mark - override

- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(NSString *)axisFormat {
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

    NSUInteger maxYAxisCount = ChartModeThumbYAxisCount;
    switch (self.chartMode) {
        case DTChartModeThumb:
            maxYAxisCount = ChartModeThumbYAxisCount;
            break;
        case DTChartModePresentation:
            maxYAxisCount = ChartModePresentationYAxisCount;
            break;
    }

    if (maxMainAxisY > yAxisLabelData.value) {    // y主轴需要重绘了
        needRedrawAxis = YES;

        // y轴label data
        NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];

        for (NSUInteger i = 0; i <= maxYAxisCount; ++i) {
            CGFloat y = maxMainAxisY / maxYAxisCount * i;

            NSString *title = [NSString stringWithFormat:self.axisFormat, y];
            [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:y]];
        }

        self.lineChart.yAxisLabelDatas = yAxisLabelDatas;
    }

    CGFloat ySecondAxisValue = (ySecondAxisLabelData != nil) ? ySecondAxisLabelData.value : 0;
    if (maxSecondAxisY > ySecondAxisValue) { // y副轴需要重绘了
        needRedrawAxis = YES;

        // y轴label data
        NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];

        for (NSUInteger i = 0; i <= maxYAxisCount; ++i) {
            CGFloat y = maxSecondAxisY / maxYAxisCount * i;

            NSString *title = [NSString stringWithFormat:self.axisFormat, y];
            [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:y]];
        }

        self.lineChart.ySecondAxisLabelDatas = yAxisLabelDatas;
    }


    if (needRedrawAxis) {
        BOOL ani = self.lineChart.isShowAnimation;
        self.lineChart.showAnimation = NO;
        [self.lineChart drawChart];
        self.lineChart.showAnimation = ani;
    }


    NSMutableArray<DTLineChartSingleData *> *lines = self.lineChart.multiData.mutableCopy;
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];

    for (NSUInteger n = 0; n < mainAxisDatas.count; ++n) {

        DTListCommonData *listCommonData = mainAxisDatas[n];
        NSArray<DTCommonData *> *values = listCommonData.commonDatas;

        NSMutableArray<DTChartItemData *> *points = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            // 单条折线里的点
            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.itemValue = ChartItemValueMake(i, data.ptValue);
            [points addObject:itemData];
        }

        // 单条折线
        DTLineChartSingleData *singleData = [DTLineChartSingleData singleData:points];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;

        [indexSet addIndex:lines.count];
        [lines addObject:singleData];
    }

    // 赋值折线数据
    self.lineChart.multiData = lines;

    [self.lineChart insertChartItems:indexSet withAnimation:animation];

    // 保存数据
    [self cacheMultiData];
}


@end
