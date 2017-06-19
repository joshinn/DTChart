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
        [_chart setTouchSubBarBlock:^NSString *(NSArray<DTDimensionModel *> *allSubData, DTDimensionModel *touchData, NSUInteger dimensionIndex) {
            if (weakSelf.touchBurgerSubBarBlock) {
                id dimensionData = nil;
                if (dimensionIndex < weakSelf.dimensionDatas.count) {
                    dimensionData = weakSelf.dimensionDatas[dimensionIndex];
                }
                return weakSelf.touchBurgerSubBarBlock(allSubData, touchData, dimensionData, weakSelf.measureData);
            } else {
                return nil;
            }
        }];

        [_chart setSubBarInfoBlock:^(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, NSUInteger dimensionIndex) {
            if (weakSelf.burgerSubBarInfoBlock) {
                weakSelf.burgerSubBarInfoBlock(allSubData, barAllColor, dimensionIndex);
            }
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

- (void)setChartMode:(DTChartMode)chartMode {
    [super setChartMode:chartMode];

    if (chartMode == DTChartModeThumb) {
        _chart.barWidth = 1;
        _chart.barGap = 2;
        _chart.xOffset = 2;
    } else if (chartMode == DTChartModePresentation) {
        _chart.barWidth = 2;
        _chart.barGap = 6;
        _chart.xOffset = 6;
    }
}

- (void)setHighlightTitle:(NSString *)highlightTitle {
    _highlightTitle = highlightTitle;

    _chart.highlightTitle = highlightTitle;
}

#pragma mark - override


- (void)drawChart {
    [super drawChart];

    [self.chart drawChart];
}

#pragma mark - public method

- (void)setItem:(DTDimensionModel *)dimensionModel {
    self.chart.dimensionModel = dimensionModel;

    // y轴label data
    NSUInteger divideParts = 0;
    if (self.chartMode == DTChartModeThumb) {
        divideParts = 3;
    } else if (self.chartMode == DTChartModePresentation) {
        divideParts = 11;
    }
    NSMutableArray<DTAxisLabelData *> *yLabelDatas = [NSMutableArray arrayWithCapacity:3];
    CGFloat itemValue = 1.0f / (divideParts - 1);
    for (NSUInteger i = 0; i < divideParts; i++) {
        DTAxisLabelData *labelData = [[DTAxisLabelData alloc] initWithTitle:[NSString stringWithFormat:@"%@%%", @(i * (NSUInteger) (itemValue * 100))] value:i * itemValue];
        [yLabelDatas addObject:labelData];
    }
    self.chart.yAxisLabelDatas = yLabelDatas;
}


@end
