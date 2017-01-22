//
//  DTPieChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTPieChartController.h"
#import "DTPieChart.h"
#import "DTDataManager.h"
#import "DTChartLabel.h"
#import "NSNumber+DTExternal.h"

@interface DTPieChartController ()

@property(nonatomic) DTPieChart *mainChart;
@property(nonatomic) DTChartLabel *mainHintLabel;

@property(nonatomic) DTPieChart *secondChart;
@property(nonatomic) DTChartLabel *secondHintLabel;

@end

@implementation DTPieChartController

@synthesize chartView = _chartView;
@synthesize chartId = _chartId;


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _mainChart = [[DTPieChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _chartView = _mainChart;
        self.chartMode = DTChartModeThumb;

        _mainHintLabel = [DTChartLabel chartLabel];
        _mainHintLabel.hidden = YES;
        [_mainChart addSubview:_mainHintLabel];

        __weak typeof(self) weakSelf = self;
        [_mainChart setPieChartTouchBlock:^(NSUInteger index) {
            if (weakSelf.mainChart.drawSingleDataIndex == -1) {    // 绘制的是所有的数据
                if (weakSelf.pieChartTouchBlock) {
                    NSString *seriesId = weakSelf.mainChart.multiData[index].singleId;
                    weakSelf.pieChartTouchBlock(seriesId, -1);
                }
            } else {    // 绘制单组详细数据
                if (weakSelf.pieChartTouchBlock) {
                    NSString *seriesId = weakSelf.mainChart.multiData[(NSUInteger) weakSelf.mainChart.drawSingleDataIndex].singleId;
                    weakSelf.pieChartTouchBlock(seriesId, index);
                }
            }

            if (weakSelf.mainChart.drawSingleDataIndex == -1) {
                [weakSelf drawSecondPieChart:index];
            }
        }];

        [_mainChart setPieChartTouchCancelBlock:^(NSUInteger index) {
            [weakSelf dismissSecondPieChart];
        }];

        [_mainChart setColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
            if (weakSelf.mainAxisColorsCompletionBlock) {
                weakSelf.mainAxisColorsCompletionBlock(infos);
            }
        }];

    }
    return self;
}

/**
 * 给chartId加上前缀
 * @param chartId 赋值的chartId
 */
- (void)setChartId:(NSString *)chartId {
    _chartId = [@"pie-" stringByAppendingString:chartId];
}

- (void)setChartRadius:(CGFloat)chartRadius {
    _chartRadius = chartRadius;

    _mainChart.pieRadius = chartRadius;
}

- (void)setDrawMainChartSingleIndex:(NSInteger)drawMainChartSingleIndex {
    _drawMainChartSingleIndex = drawMainChartSingleIndex;

    self.mainChart.drawSingleDataIndex = drawMainChartSingleIndex;
}

- (void)setChartMode:(DTChartMode)chartMode {
    [super setChartMode:chartMode];

    switch (chartMode) {

        case DTChartModeThumb: {
            self.chartRadius = 4.5;
            [self.mainChart updateOrigin:0 yOffset:0];
            [self removeSecondPieChart];
        }
            break;
        case DTChartModePresentation: {
            self.chartRadius = 12;
            [self.mainChart updateOrigin:-16 yOffset:0];
            self.mainChart.drawSingleDataIndex = -1;
            [self loadSecondPieChart];
        }
            break;
    }
}

#pragma mark - private method

- (void)loadSecondPieChart {
    NSUInteger xAxisCellCount = 26;
    NSUInteger yAxisCellCount = 16;
    CGPoint origin = CGPointMake(CGRectGetWidth(self.mainChart.bounds) - xAxisCellCount * self.mainChart.coordinateAxisCellWidth,
            CGRectGetHeight(self.mainChart.bounds) / 2 + (self.mainChart.pieRadius - yAxisCellCount) * self.mainChart.coordinateAxisCellWidth);
    self.secondChart = [[DTPieChart alloc] initWithOrigin:origin xAxis:xAxisCellCount yAxis:yAxisCellCount];
    self.secondChart.pieRadius = 6;
    self.secondChart.showAnimation = self.isShowAnimation;
    [self.secondChart updateOrigin:self.secondChart.pieRadius - xAxisCellCount / 2 yOffset:0];

    [self.mainChart addSubview:self.secondChart];

    self.secondHintLabel = [DTChartLabel chartLabel];
    self.secondHintLabel.hidden = YES;
    [self.secondChart addSubview:self.secondHintLabel];
}

- (void)removeSecondPieChart {
    if (self.secondChart) {
        [self.secondChart removeFromSuperview];
        self.secondChart = nil;
    }
}

- (NSAttributedString *)labelAttributedText:(NSString *)name value:(NSNumber *)value percentage:(CGFloat)per {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: DTRGBColor(0xBFBFBF, 1), NSFontAttributeName: [UIFont systemFontOfSize:14]};
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:name attributes:attributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"  " attributes:attributes]];
    attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:16]};
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[value formatNumberToString] attributes:attributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n  " attributes:attributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f%%", per * 100] attributes:attributes]];

    return attributedString;
}

- (void)drawSecondPieChart:(NSInteger)index {
    DTChartSingleData *sData = self.mainChart.multiData[(NSUInteger) index];
    CGFloat percent = self.mainChart.percentages[(NSUInteger) index].floatValue;
    NSNumber *value = self.mainChart.singleTotal[(NSUInteger) index];


    self.mainHintLabel.attributedText = [self labelAttributedText:sData.singleName value:value percentage:percent];
    CGRect rect = [self.mainHintLabel.attributedText boundingRectWithSize:CGSizeMake(0, 50) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = CGSizeMake(rect.size.width + 5, rect.size.height + 5);
    self.mainHintLabel.frame = CGRectMake(self.mainChart.originPoint.x + (self.mainChart.pieRadius + 3) * self.mainChart.coordinateAxisCellWidth,
            self.mainChart.originPoint.y - size.height / 2, size.width, size.height);
    self.mainHintLabel.hidden = NO;


    self.secondChart.multiData = self.mainChart.multiData;
    self.secondChart.drawSingleDataIndex = index;
    [self.secondChart drawChart];

    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
    for (NSUInteger i = 0; i < sData.itemValues.count; ++i) {
        DTChartItemData *itemData = sData.itemValues[i];
        [mutableAttributedString appendAttributedString:[self labelAttributedText:itemData.title value:@(itemData.itemValue.y) percentage:self.secondChart.percentages[i].floatValue]];

        if (i < sData.itemValues.count - 1) {
            [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
    }
    self.secondHintLabel.attributedText = mutableAttributedString;
    rect = [self.secondHintLabel.attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.secondChart.bounds)
                    - self.secondChart.originPoint.x
                    - (self.secondChart.pieRadius + 2) * self.secondChart.coordinateAxisCellWidth, 0)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                             context:nil];
    size = CGSizeMake(rect.size.width + 5, rect.size.height + 5);
    self.secondHintLabel.frame = CGRectMake(0, 0, size.width, size.height);
    self.secondHintLabel.center = CGPointMake(CGRectGetWidth(self.secondChart.bounds) - size.width / 2, CGRectGetMidY(self.secondChart.bounds));
    self.secondHintLabel.hidden = NO;
}

- (void)dismissSecondPieChart {
    self.mainHintLabel.attributedText = nil;
    self.mainHintLabel.hidden = YES;
    self.secondHintLabel.attributedText = nil;
    self.secondHintLabel.hidden = YES;

    [self.secondChart dismissChart:NO];
}

/**
 * 把柱状图图的multiData和secondMultiData缓存起来
 */
- (void)cacheMultiData {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (self.mainChart.multiData.count > 0) {
        dataDic[@"multiData"] = self.mainChart.multiData;
    }
    if (self.mainChart.secondMultiData.count > 0) {
        dataDic[@"secondMultiData"] = self.mainChart.secondMultiData;
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

                [self checkItemData:s2Data.itemValues compare:sData.itemValues];

                sData.color = s2Data.color;
                sData.secondColor = s2Data.secondColor;
                sData.lineWidth = s2Data.lineWidth;

                [cachedArray removeObject:s2Data];
                break;
            }
        }
    }
}

- (void)checkItemData:(NSArray<DTChartItemData *> *)cachedItemData compare:(NSArray<DTChartItemData *> *)itemData {
    if (cachedItemData.count == 0 || itemData.count == 0) {
        return;
    }

    NSMutableArray *cachedArray = [cachedItemData mutableCopy];

    for (DTChartItemData *itemData1 in itemData) {
        for (DTChartItemData *itemData2 in cachedArray) {

            if ([itemData1.title isEqualToString:itemData2.title]) {
                itemData1.color = itemData2.color;
                itemData1.secondColor = itemData2.secondColor;

                [cachedArray removeObject:itemData2];
                break;
            }
        }
    }
}

- (void)processPieParts:(NSArray<DTListCommonData *> *)listData remainData:(BOOL)remain {

    NSMutableArray<DTChartSingleData *> *parts = [NSMutableArray arrayWithCapacity:listData.count];


    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];

        if (!listCommonData.isMainAxis) { // 是副轴 过滤
            continue;
        }

        NSArray<DTCommonData *> *values = listCommonData.commonDatas;

        NSMutableArray<DTChartItemData *> *bar = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            // 单个柱状体
            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.itemValue = ChartItemValueMake(i, data.ptValue);
            itemData.title = data.ptName;
            [bar addObject:itemData];
        }


        // 单个柱状体
        DTChartSingleData *singleData = [DTChartSingleData singleData:bar];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        [parts addObject:singleData];
    }

    // 赋值柱状体数据
    if (remain) {
        NSMutableArray<DTChartSingleData *> *mutableArray = [NSMutableArray array];
        if (self.mainChart.multiData.count > 0) {
            [mutableArray addObjectsFromArray:self.mainChart.multiData];
        }
        [mutableArray addObjectsFromArray:parts];
        self.mainChart.multiData = mutableArray.copy;
    } else {
        self.mainChart.multiData = parts;
    }

}


#pragma mark - override


- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat {
    [super setItems:chartId listData:listData axisFormat:axisFormat];

    [self processPieParts:listData remainData:NO];
}

- (void)drawChart {
    [super drawChart];

    if (![DTManager checkExistByChartId:self.chartId]) {

        [self.mainChart drawChart];

        // 保存数据
        [self cacheMultiData];

    } else {

        // 加载保存的数据信息（颜色等）
        NSDictionary *chartDic = [DTManager queryByChartId:self.chartId];
        NSDictionary *dataDic = chartDic[@"data"];
        NSArray *multiData = dataDic[@"multiData"];
        NSArray *secondMultiData = dataDic[@"secondMultiData"];

        [self checkMultiData:multiData compare:self.mainChart.multiData];
        [self checkMultiData:secondMultiData compare:self.mainChart.secondMultiData];
        [self cacheMultiData];

        [self.mainChart drawChart];
    }
}

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation {
}


- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation {
}


@end
