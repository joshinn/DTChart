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

@property(nonatomic) DTPieChart *mainPieChart;
@property(nonatomic) DTChartLabel *mainHintLabel;

@property(nonatomic) DTPieChart *secondPieChart;
@property(nonatomic) DTChartLabel *secondHintLabel;

@end

@implementation DTPieChartController

@synthesize chartView = _chartView;
@synthesize chartId = _chartId;


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _mainPieChart = [[DTPieChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _mainPieChart.showCoordinateAxisGrid = YES;
        _chartView = _mainPieChart;
        self.chartMode = DTChartModeThumb;

        _mainHintLabel = [DTChartLabel chartLabel];
        _mainHintLabel.hidden = YES;
        [_mainPieChart addSubview:_mainHintLabel];

        __weak typeof(self) weakSelf = self;
        [_mainPieChart setPieChartTouchBlock:^(NSUInteger index) {
            if (weakSelf.mainPieChart.drawSingleDataIndex == -1) {    // 绘制的是所有的数据
                if (weakSelf.pieChartTouchBlock) {
                    NSString *seriesId = weakSelf.mainPieChart.multiData[index].singleId;
                    weakSelf.pieChartTouchBlock(seriesId, -1);
                }
            } else {    // 绘制单组详细数据
                if (weakSelf.pieChartTouchBlock) {
                    NSString *seriesId = weakSelf.mainPieChart.multiData[(NSUInteger) weakSelf.mainPieChart.drawSingleDataIndex].singleId;
                    weakSelf.pieChartTouchBlock(seriesId, index);
                }
            }

            if (weakSelf.mainPieChart.drawSingleDataIndex == -1) {
                [weakSelf drawSecondPieChart:index];
            }
        }];

        [_mainPieChart setPieChartTouchCancelBlock:^(NSUInteger index) {
            [weakSelf dismissSecondPieChart];
        }];

        [_mainPieChart setColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
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

    _mainPieChart.pieRadius = chartRadius;
}

- (void)setChartMode:(DTChartMode)chartMode {
    [super setChartMode:chartMode];

    switch (chartMode) {

        case DTChartModeThumb: {
            self.chartRadius = 4.5;
            [self.mainPieChart updateOrigin:0 yOffset:0];
            [self removeSecondPieChart];
        }
            break;
        case DTChartModePresentation: {
            self.chartRadius = 12;
            [self.mainPieChart updateOrigin:-16 yOffset:0];
            [self loadSecondPieChart];
        }
            break;
    }
}

#pragma mark - private method

- (void)loadSecondPieChart {
    NSUInteger xAxisCellCount = 22;
    NSUInteger yAxisCellCount = 16;
    CGPoint origin = CGPointMake(CGRectGetWidth(self.mainPieChart.bounds) - xAxisCellCount * self.mainPieChart.coordinateAxisCellWidth,
            CGRectGetHeight(self.mainPieChart.bounds) / 2 + (self.mainPieChart.pieRadius - yAxisCellCount) * self.mainPieChart.coordinateAxisCellWidth);
    self.secondPieChart = [[DTPieChart alloc] initWithOrigin:origin xAxis:xAxisCellCount yAxis:yAxisCellCount];
    self.secondPieChart.pieRadius = 6;
    self.secondPieChart.showAnimation = self.isShowAnimation;
    [self.secondPieChart updateOrigin:self.secondPieChart.pieRadius - xAxisCellCount / 2 + 1 yOffset:0];

    [self.mainPieChart addSubview:self.secondPieChart];

    self.secondHintLabel = [DTChartLabel chartLabel];
    self.secondHintLabel.hidden = YES;
    [self.secondPieChart addSubview:self.secondHintLabel];
}

- (void)removeSecondPieChart {
    if (self.secondPieChart) {
        [self.secondPieChart removeFromSuperview];
        self.secondPieChart = nil;
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
    DTChartSingleData *sData = self.mainPieChart.multiData[(NSUInteger) index];
    CGFloat percent = self.mainPieChart.percentages[(NSUInteger) index].floatValue;
    NSNumber *value = self.mainPieChart.singleTotal[(NSUInteger) index];


    self.mainHintLabel.attributedText = [self labelAttributedText:sData.singleName value:value percentage:percent];
    CGRect rect = [self.mainHintLabel.attributedText boundingRectWithSize:CGSizeMake(0, 50) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = CGSizeMake(rect.size.width + 5, rect.size.height + 5);
    self.mainHintLabel.frame = CGRectMake(self.mainPieChart.originPoint.x + (self.mainPieChart.pieRadius + 3) * self.mainPieChart.coordinateAxisCellWidth,
            self.mainPieChart.originPoint.y - size.height / 2, size.width, size.height);
    self.mainHintLabel.hidden = NO;


    self.secondPieChart.multiData = self.mainPieChart.multiData;
    self.secondPieChart.drawSingleDataIndex = index;
    [self.secondPieChart drawChart];

    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
    for (NSUInteger i = 0; i < sData.itemValues.count; ++i) {
        DTChartItemData *itemData = sData.itemValues[i];
        [mutableAttributedString appendAttributedString:[self labelAttributedText:itemData.title value:@(itemData.itemValue.y) percentage:self.secondPieChart.percentages[i].floatValue]];

        if (i < sData.itemValues.count - 1) {
            [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
    }
    self.secondHintLabel.attributedText = mutableAttributedString;
    rect = [self.secondHintLabel.attributedText boundingRectWithSize:CGSizeMake(9 * self.secondPieChart.coordinateAxisCellWidth, 0)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                             context:nil];
    size = CGSizeMake(rect.size.width + 5, rect.size.height + 5);
    self.secondHintLabel.frame = CGRectMake(0, 0, size.width, size.height);
    self.secondHintLabel.center = CGPointMake(CGRectGetWidth(self.secondPieChart.bounds) - size.width / 2, CGRectGetMidY(self.secondPieChart.bounds));
    self.secondHintLabel.hidden = NO;
}

- (void)dismissSecondPieChart {
    self.mainHintLabel.attributedText = nil;
    self.mainHintLabel.hidden = YES;
    self.secondHintLabel.attributedText = nil;
    self.secondHintLabel.hidden = YES;

    [self.secondPieChart dismissChart:NO];
}

/**
 * 把柱状图图的multiData和secondMultiData缓存起来
 */
- (void)cacheMultiData {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (self.mainPieChart.multiData.count > 0) {
        dataDic[@"multiData"] = self.mainPieChart.multiData;
    }
    if (self.mainPieChart.secondMultiData.count > 0) {
        dataDic[@"secondMultiData"] = self.mainPieChart.secondMultiData;
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
        if (self.mainPieChart.multiData.count > 0) {
            [mutableArray addObjectsFromArray:self.mainPieChart.multiData];
        }
        [mutableArray addObjectsFromArray:parts];
        self.mainPieChart.multiData = mutableArray.copy;
    } else {
        self.mainPieChart.multiData = parts;
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

        [self.mainPieChart drawChart];

        // 保存数据
        [self cacheMultiData];

    } else {

        // 加载保存的数据信息（颜色等）
        NSDictionary *chartDic = [DTManager queryByChartId:self.chartId];
        NSDictionary *dataDic = chartDic[@"data"];
        NSArray *multiData = dataDic[@"multiData"];
        NSArray *secondMultiData = dataDic[@"secondMultiData"];

        [self checkMultiData:multiData compare:self.mainPieChart.multiData];
        [self checkMultiData:secondMultiData compare:self.mainPieChart.secondMultiData];
        [self cacheMultiData];

        [self.mainPieChart drawChart];
    }
}

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation {
}


- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation {
}


@end
