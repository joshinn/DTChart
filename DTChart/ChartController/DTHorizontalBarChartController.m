//
//  DTHorizontalBarChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTHorizontalBarChartController.h"
#import "DTHorizontalBarChart.h"
#import "DTDataManager.h"
#import "DTChartLabel.h"

@interface DTHorizontalBarChartController ()

@property(nonatomic) DTHorizontalBarChart *barChart;

@property(nonatomic) NSUInteger mMaxXAxisCount;
@property(nonatomic) NSUInteger mMaxYAxisCount;


@end

@implementation DTHorizontalBarChartController

static NSUInteger const ChartModeThumbXAxisCount = 5;
static NSUInteger const ChartModePresentationXAxisCount = 10;

static NSUInteger const ChartModeThumbYAxisCount = 5;
static NSUInteger const ChartModePresentationYAxisCount = 10;


@synthesize chartView = _chartView;
@synthesize chartId = _chartId;
@synthesize chartMode = _chartMode;


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _barChart = [[DTHorizontalBarChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _barChart.barChartStyle = DTBarChartStyleStartingLine;
        _chartView = _barChart;


        WEAK_SELF;
        [_barChart setColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
            if (weakSelf.mainAxisColorsCompletionBlock) {
                weakSelf.mainAxisColorsCompletionBlock(infos);
            }
        }];

        [_barChart setBarChartTouchBlock:^NSString *(NSUInteger dataIndex, NSUInteger barIndex) {
            if (weakSelf.barChartControllerTouchBlock) {
                return weakSelf.barChartControllerTouchBlock(dataIndex, barIndex);
            }
            return nil;
        }];

    }
    return self;
}

- (NSUInteger)mMaxXAxisCount {
    if (self.preferXAxisDataCount > 0) {
        _mMaxXAxisCount = self.preferXAxisDataCount;
        return _mMaxXAxisCount;
    }

    _mMaxXAxisCount = ChartModeThumbXAxisCount;
    switch (self.chartMode) {
        case DTChartModeThumb:
            _mMaxXAxisCount = ChartModeThumbXAxisCount;
            break;
        case DTChartModePresentation:
            _mMaxXAxisCount = ChartModePresentationXAxisCount;
            break;
    }

    return _mMaxXAxisCount;
}

- (NSUInteger)mMaxYAxisCount:(NSUInteger)valuesCount {
    if (self.preferMainYAxisDataCount > 0) {
        _mMaxYAxisCount = self.preferMainYAxisDataCount;
        return _mMaxYAxisCount;
    }

    _mMaxYAxisCount = ChartModeThumbYAxisCount;
    switch (self.chartMode) {
        case DTChartModeThumb: {
            if (valuesCount <= self.barChart.yAxisCellCount / 2) {
                _mMaxYAxisCount = valuesCount;
            } else {
                _mMaxYAxisCount = ChartModeThumbYAxisCount;
            }
        }
            break;
        case DTChartModePresentation:
            if (valuesCount <= self.barChart.yAxisCellCount / 2) {
                _mMaxYAxisCount = valuesCount;
            } else {
                _mMaxYAxisCount = ChartModePresentationYAxisCount;
            }
            break;
    }

    return _mMaxYAxisCount;
}


- (void)setBarWidth:(CGFloat)barWidth {
    _barWidth = barWidth;

    _barChart.barWidth = barWidth;
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

    NSUInteger maxXAxisCount = self.mMaxXAxisCount;
    NSUInteger maxYAxisCount = [self mMaxYAxisCount:values.count];

    CGFloat maxX = 0;

    if (remain) {
        // 找出已有的最大值做对比
        for (DTChartSingleData *sData in self.barChart.multiData) {
            for (DTChartItemData *itemData in sData.itemValues) {
                maxX = MAX(maxX, itemData.itemValue.x);
            }
        }
    }


    NSUInteger divide = values.count / maxYAxisCount;   // y轴平均划分有关
    CGFloat decimal = values.count * 1.0f / maxYAxisCount - values.count / maxXAxisCount;
    if (decimal > 0) {
        divide += 1;
    }


    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];
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
            if (data.ptValue > maxX) {
                maxX = data.ptValue;
            }

            if (n == 0) {   // y轴label data，只需要取第一个柱状体数据计算就可以
                DTAxisLabelData *yLabelData = [[DTAxisLabelData alloc] initWithTitle:[self.axisFormatter getMainYAxisLabelTitle:data.ptName orValue:0] value:i];
                if (values.count > maxXAxisCount) {

                    yLabelData.hidden = i % divide != 0;

                } else {    // 全部显示
                    yLabelData.hidden = NO;
                }

                [yAxisLabelDatas addObject:yLabelData];
            }

            // 单个柱状体
            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.itemValue = ChartItemValueMake(data.ptValue, i);
            [bar addObject:itemData];
        }

        if (n == 0) {
            // 赋值y轴数据，只需要取第一个柱状体数据计算就可以
            self.barChart.yAxisLabelDatas = yAxisLabelDatas;
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

    // x轴label data
    self.barChart.xAxisLabelDatas = [self generateXAxisLabelData:maxXAxisCount xAxisMaxValue:maxX];

    self.barChart.mainNotationLabel.text = [self getNotationLabelText];

    CGRect frame = self.barChart.mainNotationLabel.frame;
    CGRect bounding = [self.barChart.mainNotationLabel.text boundingRectWithSize:CGSizeMake(self.barChart.coordinateAxisCellWidth, 0)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                      attributes:@{NSFontAttributeName: self.barChart.mainNotationLabel.font}
                                                                         context:nil];
    bounding.size.height += 5;
    frame.origin.y += CGRectGetHeight(frame) - CGRectGetHeight(bounding);
    frame.size.height = CGRectGetHeight(bounding);
    self.barChart.mainNotationLabel.frame = frame;
}

- (NSMutableArray<DTAxisLabelData *> *)generateXAxisLabelData:(NSUInteger)maxYAxisCount xAxisMaxValue:(CGFloat)maxY {
    if (maxY == 0) {    // 最大值是0，只显示0标签
        maxY = 1;

        NSMutableArray < DTAxisLabelData * > *xAxisLabelDatas = [NSMutableArray array];

        for (NSUInteger i = 0; i <= maxYAxisCount; ++i) {
            CGFloat y = maxY * 1.0f / maxYAxisCount * i;

            NSString *title = [self.axisFormatter getXAxisLabelTitle:nil orValue:y];
            [xAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:y]];

            xAxisLabelDatas.lastObject.hidden = i != 0;
        }

        return xAxisLabelDatas;
    }


    BOOL yScaled = NO;  // 需要缩放时，记录缩放行为
    CGFloat scale = self.axisFormatter.xAxisScale;
    CGFloat maxLimit = self.xAxisMaxValueLimit;
    maxLimit *= scale;

    // 确定坐标轴最大值
    if ([self.axisFormatter.xAxisFormat containsString:@"%.0f"]) {

        maxY *= scale;
        yScaled = YES;

        if (maxY <= maxYAxisCount && maxYAxisCount < 10) {  // 10以内，从0，1，2...maxYAxisCount
            maxY = maxYAxisCount;

        } else if (maxY <= 10) {   // 10以内
            NSUInteger y = 10;
            while (y % maxYAxisCount != 0) {
                ++y;
            }
            maxY = y;
        } else if (maxY <= 100) {    // 100以内
            NSUInteger y = maxYAxisCount * 5;
            while (y < maxY) {
                y += maxYAxisCount * 5;
            }
            maxY = y;
        } else {    // 大于2位数
            NSUInteger limit = 100;
            while (maxY >= limit) {
                limit *= 10;
            }
            limit /= 1000;

            NSUInteger y = maxYAxisCount * 10 * limit;
            while (y < maxY) {
                y += maxYAxisCount * 10 * limit;
            }

            maxY = y;
        }

        if (maxY > maxLimit && maxLimit > 0) {
            maxY = maxLimit;

            while (maxYAxisCount >= 1 && maxLimit / maxYAxisCount != (NSInteger) (maxY / maxYAxisCount)) {
                --maxYAxisCount;
            }
        }
    }


    NSMutableArray<DTAxisLabelData *> *xAxisLabelDatas = [NSMutableArray array];
    NSInteger unitScale = 1;

    for (NSUInteger i = 0; i <= maxYAxisCount; ++i) {
        CGFloat y = maxY / maxYAxisCount * i;

        if (i == 1) {
            NSInteger intY = (NSInteger) y;

            NSInteger notation = 1000000000;
            while (notation >= 1000) {
                if (intY % notation == 0) {
                    unitScale = notation;

                    self.axisFormatter.xAxisNotation = notation;

                    break;
                } else {
                    notation /= 1000;
                }
            }

        }

        if (yScaled) {
            y /= scale;
        }

        NSString *title;
        DTAxisFormatterType axisType = self.axisFormatter.xAxisType;
        if (axisType == DTAxisFormatterTypeText || axisType == DTAxisFormatterTypeDate) {
            title = [self.axisFormatter getXAxisLabelTitle:[NSString stringWithFormat:@"%@", @(y)] orValue:0];

        } else if (axisType == DTAxisFormatterTypeNumber) {
            title = [self.axisFormatter getXAxisLabelTitle:nil orValue:y / unitScale];
        }

        [xAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:y]];
    }

    return xAxisLabelDatas;
}

/**
 * 获取x轴对应的倍数文字
 * @return 文字
 */
- (NSString *)getNotationLabelText {
    NSInteger notation = self.axisFormatter.xAxisNotation;
    NSString *unit = self.axisFormatter.xAxisUnit;

    if (notation == 1000) {
        if (unit.length == 0) {
            return [NSString stringWithFormat:@"×\n10³"];
        } else {
            return [NSString stringWithFormat:@"×\n10³\n%@", unit];
        }
    } else if (notation == 1000000) {
        if (unit.length == 0) {
            return [NSString stringWithFormat:@"×\n10⁹"];
        } else {
            return [NSString stringWithFormat:@"×\n10⁶\n%@", unit];
        }
    } else if (notation == 1000000000) {
        if (unit.length == 0) {
            return [NSString stringWithFormat:@"×\n10⁹"];
        } else {
            return [NSString stringWithFormat:@"×\n10⁹\n%@", unit];
        }
    } else {
        return unit;
    }
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

    self.axisFormatter = [DTAxisFormatter axisFormatterExClone:axisFormat];

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
}


- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation {
}


@end
