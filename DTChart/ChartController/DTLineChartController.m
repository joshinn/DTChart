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

@interface DTLineChartController ()

@property(nonatomic) DTLineChart *lineChart;

@end


@implementation DTLineChartController

static NSUInteger const ChartModeThumbYAxisCount = 3;
static NSUInteger const ChartModePresentationYAxisCount = 7;

static NSUInteger const ChartModeThumbXAxisMaxCount = 5;


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


- (void)addItem:(NSString *)itemId seriesName:(NSString *)seriesName values:(NSArray<DTCommonData *> *)values {
    [super addItem:itemId seriesName:seriesName values:values];

    BOOL isOverLimit = values.count > self.lineChart.xAxisCellCount;
    NSUInteger maxXAxisCount = ChartModeThumbXAxisMaxCount;
    NSUInteger maxYAxisCount = ChartModeThumbYAxisCount;
    switch (self.chartMode) {
        case DTChartModeThumb:
            maxYAxisCount = ChartModeThumbYAxisCount;
            maxXAxisCount = ChartModeThumbXAxisMaxCount;
            break;
        case DTChartModePresentation:
            maxYAxisCount = ChartModePresentationYAxisCount;
            maxXAxisCount = 18;
            break;
    }

    CGFloat maxY = 0;

    NSUInteger divide = values.count / maxXAxisCount;   // x轴平均划分有关
    CGFloat decimal = values.count * 1.0f / maxXAxisCount - values.count / maxXAxisCount;
    if (decimal > 0) {
        divide += 1;
    }

    // x axis , points

    NSMutableArray<DTAxisLabelData *> *xAxisLabelDatas = [NSMutableArray array];
    NSMutableArray<DTChartItemData *> *points = [NSMutableArray array];

    for (NSUInteger i = 0; i < values.count; ++i) {

        DTCommonData *data = values[i];

        DTAxisLabelData *xLabelData = [[DTAxisLabelData alloc] initWithTitle:data.ptName value:i];
        if (values.count > maxXAxisCount) {

            if (isOverLimit) { // x轴跳点

                if (i % divide != 0) {
                    xLabelData.hidden = YES;
                } else {
                    xLabelData.hidden = NO;
                }

            } else { // 最多显示maxXAxisCount个点
                xLabelData.hidden = i % divide != 0;
            }

        } else {    // 全部显示
            xLabelData.hidden = NO;
        }
        if (xLabelData) {
            [xAxisLabelDatas addObject:xLabelData];
        }


        if (isOverLimit) {
            NSUInteger pointDivide = values.count / self.lineChart.xAxisCellCount + 1;
            if (i % pointDivide != 0) {
                DTLog(@"hide point index = %@", @(i));
                continue;
            }
        }

        DTChartItemData *itemData = [DTChartItemData chartData];
        itemData.itemValue = ChartItemValueMake(i, data.ptValue);
        [points addObject:itemData];


        if (data.ptValue > maxY) {
            maxY = data.ptValue;
        }
    }

    self.lineChart.xAxisLabelDatas = xAxisLabelDatas;

    DTLineChartSingleData *singleData = [DTLineChartSingleData singleData:points];

    self.lineChart.multiData = @[singleData];


    // y axis

    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];

    for (NSUInteger i = 0; i <= maxYAxisCount; ++i) {
        CGFloat y = maxY / maxYAxisCount * i;

        NSString *title = [NSString stringWithFormat:@"%@", @(y)];

        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:y]];
    }

    self.lineChart.yAxisLabelDatas = yAxisLabelDatas;
}

- (void)drawChart {
    [super drawChart];

    DTLog(@"x axis = %@", @(self.lineChart.xAxisCellCount));

    [self.lineChart drawChart];
}

@end
