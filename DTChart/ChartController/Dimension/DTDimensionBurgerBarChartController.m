//
//  DTDimensionBurgerBarChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/9.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBurgerBarChartController.h"
#import "DTDimensionBurgerBarChart.h"
#import "DTDimensionModel.h"

@interface DTDimensionBurgerBarChartController ()

@property(nonatomic) DTDimensionBurgerBarChart *chart;

@end


@implementation DTDimensionBurgerBarChartController

@synthesize chartView = _chartView;
@synthesize chartId = _chartId;


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _chart = [[DTDimensionBurgerBarChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _chartView = _chart;

        _chart.barWidth = 2;

        WEAK_SELF;
        [_chart setBarChartTouchBlock:^NSString *(NSUInteger touchIndex) {
            if (weakSelf.dimensionBarChartControllerTouchBlock) {
                return weakSelf.dimensionBarChartControllerTouchBlock(touchIndex);
            }
            return nil;
        }];
    }
    return self;
}


#pragma mark - private method

/**
 * 给chartId加上前缀
 * @param chartId 赋值的chartId
 */
- (void)setChartId:(NSString *)chartId {
    _chartId = [@"vDimBar-" stringByAppendingString:chartId];
}

- (void)setBarChartStyle:(DTBarChartStyle)barChartStyle {
    _barChartStyle = barChartStyle;

    self.chart.barChartStyle = barChartStyle;
}

#pragma mark - override


- (void)drawChart {
    [super drawChart];

    [self.chart drawChart];
}

#pragma mark - public method

- (void)setItem:(DTDimensionModel *)dimensionModel {
    self.chart.dimensionModel = dimensionModel;

//    self.chart.xOffset = (CGRectGetWidth(self.chart.contentView.bounds) - returnModel.sectionWidth) / 2;
//    self.chart.xOffset = (NSInteger) (self.chart.xOffset / 15) * 15;

    // y轴label data
    NSMutableArray<DTAxisLabelData *> *yLabelDatas = [NSMutableArray arrayWithCapacity:11];
    for (NSUInteger i = 0; i < 11; i++) {
        DTAxisLabelData *labelData = [[DTAxisLabelData alloc] initWithTitle:[NSString stringWithFormat:@"%@%%", @(i * 10)] value:i * 0.1f];
        [yLabelDatas addObject:labelData];
    }
    self.chart.yAxisLabelDatas = yLabelDatas;

}


@end
