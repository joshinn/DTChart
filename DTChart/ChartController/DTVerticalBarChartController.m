//
//  DTVerticalBarChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/13.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTVerticalBarChartController.h"
#import "DTCommonData.h"
#import "DTVerticalBarChart.h"
#import "DTAxisFormatter.h"

@interface DTVerticalBarChartController()

@property(nonatomic) DTVerticalBarChart *barChart;

@property(nonatomic) NSUInteger mMaxXAxisCount;
@property(nonatomic) NSUInteger mMaxYAxisCount;


@end

@implementation DTVerticalBarChartController

static NSUInteger const ChartModeThumbYAxisCount = 3;
static NSUInteger const ChartModePresentationYAxisCount = 7;


@synthesize chartView = _chartView;

- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _barChart = [[DTVerticalBarChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _chartView = _barChart;

        _barChart.contentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];

        __weak typeof(self) weakSelf = self;
        [_barChart setColorsCompletionBlock:^(NSArray<UIColor *> *colors, NSArray<NSString *> *seriesIds) {
            if (weakSelf.mainAxisColorsCompletionBlock) {
                weakSelf.mainAxisColorsCompletionBlock(colors, seriesIds);
            }
        }];
        [_barChart setSecondAxisColorsCompletionBlock:^(NSArray<UIColor *> *colors, NSArray<NSString *> *seriesIds) {
            if (weakSelf.secondAxisColorsCompletionBlock) {
                weakSelf.secondAxisColorsCompletionBlock(colors, seriesIds);
            }
        }];
    }
    return self;
}

- (NSUInteger)mMaxXAxisCount {
    _mMaxXAxisCount = self.barChart.xAxisCellCount;
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
 * @return 加工过的chartId
 */
- (NSString *)lineChartId {
    return [@"bar-" stringByAppendingString:self.chartId];
}


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
            self.barChart.xAxisLabelDatas = xAxisLabelDatas;
        }

        // 单条折线
        DTChartSingleData *singleData = [DTChartSingleData singleData:points];
        singleData.singleId = listCommonData.seriesId;
        singleData.singleName = listCommonData.seriesName;
        [lines addObject:singleData];
    }

    // 赋值折线数据
    self.barChart.multiData = lines;

    // y轴label data
    self.barChart.yAxisLabelDatas = [super generateYAxisLabelData:maxYAxisCount yAxisMaxValue:maxY isMainAxis:YES];


}

@end
