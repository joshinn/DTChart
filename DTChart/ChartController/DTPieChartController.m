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
@property(nonatomic) UIView *secondHintContainerView;
@property(nonatomic) NSMutableArray<UIColor *> *listSecondItemColors;

@end

@implementation DTPieChartController

@synthesize chartView = _chartView;
@synthesize chartId = _chartId;
@synthesize valueSelectable = _valueSelectable;


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        UIView *containerView = [[UIView alloc] init];
        _chartView = containerView;

        _mainChart = [[DTPieChart alloc] initWithOrigin:CGPointZero xAxis:xCount yAxis:yCount];

        containerView.frame = CGRectMake(origin.x, origin.y, xCount * _mainChart.coordinateAxisCellWidth, yCount * _mainChart.coordinateAxisCellWidth);

        [containerView addSubview:_mainChart];
        self.chartMode = DTChartModeThumb;

        _mainHintLabel = [DTChartLabel chartLabel];
        _mainHintLabel.hidden = YES;
        [containerView addSubview:_mainHintLabel];

        _secondHintContainerView = [UIView new];
        _secondHintContainerView.hidden = YES;
        [containerView addSubview:_secondHintContainerView];
        _listSecondItemColors = [NSMutableArray array];

        WEAK_SELF;
        [_mainChart setPieChartTouchBlock:^(NSUInteger index) {
            if (weakSelf.pieChartTouchBlock) {
                DTChartSingleData *sData = weakSelf.mainChart.multiData.firstObject;
                DTChartItemData *itemData = sData.itemValues[index];

                weakSelf.pieChartTouchBlock(itemData.title, index);
            }

            if (weakSelf.chartMode == DTChartModePresentation) {
                [weakSelf showMainChartHint:index];
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
        [_mainChart setItemsColorsCompletion:^(NSArray<DTChartBlockModel *> *infos) {
            if (weakSelf.mainChartItemsColorsCompletionBlock) {
                weakSelf.mainChartItemsColorsCompletionBlock(infos);
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

- (void)setValueSelectable:(BOOL)valueSelectable {
    _valueSelectable = valueSelectable;

    _mainChart.valueSelectable = valueSelectable;
}

- (void)setChartMode:(DTChartMode)chartMode {
    [super setChartMode:chartMode];

    CGFloat cellWidth = self.mainChart.coordinateAxisCellWidth;

    switch (chartMode) {

        case DTChartModeThumb: {
            self.chartRadius = 4.5;

            CGFloat width = (self.chartRadius * 2 + 2) * cellWidth;
            CGFloat x = (CGRectGetWidth(self.chartView.bounds) - width) / 2;
            CGFloat y = (CGRectGetHeight(self.chartView.bounds) - width) / 2;
            [self.mainChart updateFrame:CGPointMake(x, y)
                                  xAxis:(NSUInteger) (width / cellWidth)
                                  yAxis:(NSUInteger) (width / cellWidth)];
            [self removeSecondPieChart];
        }
            break;
        case DTChartModePresentation: {
            self.chartRadius = 12;
            CGFloat width = (self.chartRadius * 2 + 2) * cellWidth;
            CGFloat x = 7 * cellWidth;
            CGFloat y = (CGRectGetHeight(self.chartView.bounds) - width) / 2;

            [self.mainChart updateFrame:CGPointMake(x, y)
                                  xAxis:(NSUInteger) (width / cellWidth)
                                  yAxis:(NSUInteger) (width / cellWidth)];

            [self loadSecondPieChart];
        }
            break;
    }
}

#pragma mark - private method

- (void)loadSecondPieChart {
    CGFloat radius = 6;
    CGFloat cellWidth = self.mainChart.coordinateAxisCellWidth;
    NSUInteger xAxisCellCount = (NSUInteger) (radius * 2 + 2);
    NSUInteger yAxisCellCount = (NSUInteger) (radius * 2 + 2);
    CGPoint origin = CGPointMake(CGRectGetMaxX(self.mainChart.frame) + 15 * cellWidth,
            CGRectGetMidY(self.mainChart.frame) - radius / 2 * cellWidth);
    self.secondChart = [[DTPieChart alloc] initWithOrigin:origin xAxis:xAxisCellCount yAxis:yAxisCellCount];
    self.secondChart.pieRadius = radius;
    self.secondChart.showAnimation = self.isShowAnimation;

    __weak typeof(self) weakSelf = self;
    [self.secondChart setItemsColorsCompletion:^(NSArray<DTChartBlockModel *> *infos) {
        [weakSelf.listSecondItemColors removeAllObjects];
        for (DTChartBlockModel *model in infos) {
            [weakSelf.listSecondItemColors addObject:model.color];
        }

        if (weakSelf.secondChartItemsColorsCompletionBlock) {
            weakSelf.secondChartItemsColorsCompletionBlock(infos);
        }
    }];

    [self.chartView addSubview:self.secondChart];
}

- (void)removeSecondPieChart {
    if (self.secondChart) {
        [self.secondChart removeFromSuperview];
        self.secondChart = nil;
    }
}

/**
 * 显示主表的文字提示
 */
- (void)showMainChartHint:(NSUInteger)index {
    DTChartSingleData *sData = self.mainChart.multiData.firstObject;
    CGFloat percent = self.mainChart.percentages[(NSUInteger) index].floatValue;
    DTChartItemData *itemData = sData.itemValues[index];

    self.mainHintLabel.attributedText = [self labelAttributedText:itemData.title value:@(itemData.itemValue.y) percentage:percent];
    CGRect rect = [self.mainHintLabel.attributedText boundingRectWithSize:CGSizeMake(150, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = CGSizeMake(rect.size.width + 5, rect.size.height + 5);
    self.mainHintLabel.frame = CGRectMake(CGRectGetMaxX(self.mainChart.frame) + 2 * self.mainChart.coordinateAxisCellWidth,
            CGRectGetMidY(self.mainChart.frame) - size.height / 2, size.width, size.height);
    self.mainHintLabel.hidden = NO;
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


/**
 * 把柱状图图的multiData和secondMultiData缓存起来
 */
- (void)cacheMultiData {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (self.mainChart.multiData.count > 0) {
        dataDic[@"multiData"] = self.mainChart.multiData;
    }
    if (self.mainChart.secondMultiData.count > 0) {
        dataDic[@"secondMultiData"] = self.secondChart.multiData;
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

/**
 * 对比已缓存的数据itemValues和当前的新数据itemValues，给新数据修正颜色等信息
 * @param cachedItemData 已缓存的数据
 * @param itemData 新数据
 */
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

- (void)processPieParts:(NSArray<DTListCommonData *> *)listData {

    NSMutableArray<DTChartSingleData *> *parts = [NSMutableArray arrayWithCapacity:listData.count];

    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];

        if (!listCommonData.isMainAxis) { // 是副轴 过滤
            continue;
        }

        NSArray<DTCommonData *> *values = listCommonData.commonDatas;

        NSMutableArray<DTChartItemData *> *part = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.itemValue = ChartItemValueMake(i, data.ptValue);
            itemData.title = data.ptName;
            [part addObject:itemData];
        }


        // pie图单个组成部分
        DTChartSingleData *singleData = [DTChartSingleData singleData:part];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        [parts addObject:singleData];
    }

    // 赋值主图数据
    self.mainChart.multiData = parts;

}

- (void)processSecondAxisPieParts:(NSArray<DTListCommonData *> *)listData {
    NSMutableArray<DTChartSingleData *> *parts = [NSMutableArray arrayWithCapacity:listData.count];

    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];

        if (listCommonData.isMainAxis) { // 是主轴 过滤
            continue;
        }

        NSArray<DTCommonData *> *values = listCommonData.commonDatas;

        NSMutableArray<DTChartItemData *> *part = [NSMutableArray array];

        for (NSUInteger i = 0; i < values.count; ++i) {

            DTCommonData *data = values[i];

            DTChartItemData *itemData = [DTChartItemData chartData];
            itemData.itemValue = ChartItemValueMake(i, data.ptValue);
            itemData.title = data.ptName;
            [part addObject:itemData];
        }


        // pie图单个组成部分
        DTChartSingleData *singleData = [DTChartSingleData singleData:part];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        [parts addObject:singleData];
    }

    // 赋值主图数据
    self.secondChart.multiData = parts;
}

#pragma mark - public method

- (void)drawSecondPieChart {
    [self.secondChart drawChart];

    [self.secondHintContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];

    CGFloat cellWidth = self.secondChart.coordinateAxisCellWidth;

    CGFloat x = 2 * cellWidth;
    CGFloat y = 0;
    CGFloat maxWidth = 0;
    DTChartSingleData *sData = self.secondChart.multiData.firstObject;
    for (NSUInteger i = 0; i < sData.itemValues.count; ++i) {
        DTChartItemData *itemData = sData.itemValues[i];

        DTChartLabel *label = [DTChartLabel chartLabel];
        label.attributedText = [self labelAttributedText:itemData.title value:@(itemData.itemValue.y) percentage:self.secondChart.percentages[i].floatValue];
        CGRect rect = [label.attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.chartView.bounds) - CGRectGetMaxX(self.secondChart.frame) - 3 * cellWidth, 0)
                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                         context:nil];
        label.frame = CGRectMake(x, y, CGRectGetWidth(rect), CGRectGetHeight(rect));
        if (maxWidth < CGRectGetWidth(rect)) {
            maxWidth = CGRectGetWidth(rect);
        }

        UIView *icon = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(label.frame) - cellWidth / 2, cellWidth, cellWidth)];
        icon.backgroundColor = self.listSecondItemColors[i];

        [self.secondHintContainerView addSubview:icon];
        [self.secondHintContainerView addSubview:label];

        y += CGRectGetHeight(rect) + 2;
    }

    self.secondHintContainerView.frame = CGRectMake(CGRectGetMaxX(self.secondChart.frame) + cellWidth, CGRectGetMidY(self.secondChart.frame) - y / 2, maxWidth + x, y);
    self.secondHintContainerView.hidden = NO;
}

- (void)dismissSecondPieChart {
    self.mainHintLabel.attributedText = nil;
    self.mainHintLabel.hidden = YES;
    self.secondHintContainerView.hidden = YES;
    [self.secondHintContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];

    [self.secondChart dismissChart:NO];
}


#pragma mark - override


- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat {
    [super setItems:chartId listData:listData axisFormat:axisFormat];

    [self processPieParts:listData];
}

- (void)drawChart {
    [self dismissSecondPieChart];

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
        [self checkMultiData:secondMultiData compare:self.secondChart.multiData];
        [self cacheMultiData];

        [self.mainChart drawChart];
    }
}

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation {
}


- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation {
}


- (void)setSecondChartItems:(NSArray<DTListCommonData *> *)listData {
    [self processSecondAxisPieParts:listData];
}

- (void)drawSecondChart {
    [self drawSecondPieChart];
}

@end
