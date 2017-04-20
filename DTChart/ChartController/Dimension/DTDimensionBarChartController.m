//
//  DTDimensionBarChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/19.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBarChartController.h"
#import "DTDimensionBarChart.h"
#import "DTDimension2Model.h"

@interface DTDimensionBarChartController ()

@property(nonatomic) DTDimensionBarChart *chart;

@end


@implementation DTDimensionBarChartController

@synthesize chartView = _chartView;
@synthesize chartId = _chartId;


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _chart = [[DTDimensionBarChart alloc] initWithOrigin:origin xAxis:xCount yAxis:yCount];
        _chartView = _chart;
    }
    return self;
}

#pragma mark - private method

/**
 * 给chartId加上前缀
 * @param chartId 赋值的chartId
 */
- (void)setChartId:(NSString *)chartId {
    _chartId = [@"Dim2Bar-" stringByAppendingString:chartId];
}

- (void)processXLabelData:(NSUInteger)axisCount axisMaxValue:(CGFloat)maxValue axisMinValue:(CGFloat)minValue isMainAxis:(BOOL)isMainAxis {

    if (minValue >= 0) {
        self.chart.xAxisLabelDatas = [super generateYAxisLabelData:axisCount yAxisMaxValue:maxValue isMainAxis:YES];

    } else {
        CGFloat max = 0;
        CGFloat min = 0;
        BOOL isReverse = NO;
        if (-minValue <= maxValue) {
            max = maxValue;
            min = minValue;
        } else {
            max = -minValue;
            min = -maxValue;
            isReverse = YES;
        }

        for (NSUInteger i = 1; i < axisCount; ++i) {
            NSMutableArray<DTAxisLabelData *> *xLabelDatas = [super generateYAxisLabelData:axisCount - i yAxisMaxValue:max isMainAxis:YES];

            if (-min < xLabelDatas[i].value) {
                NSMutableArray<DTAxisLabelData *> *negativeLabelDatas = [NSMutableArray array];
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                for (NSUInteger j = 0; j < i; ++j) {
                    DTAxisLabelData *xLabelData = [[DTAxisLabelData alloc] initWithTitle:[NSString stringWithFormat:@"%@", @(-xLabelDatas[j + 1].value)] value:-xLabelDatas[j + 1].value];
                    [negativeLabelDatas insertObject:xLabelData atIndex:0];
                    [indexSet addIndex:j];
                }
                [xLabelDatas insertObjects:negativeLabelDatas atIndexes:indexSet];

                if (isReverse) {
                    NSMutableArray<DTAxisLabelData *> *reverseLabelDatas = [xLabelDatas mutableCopy];
                    [xLabelDatas removeAllObjects];

                    for (DTAxisLabelData *labelData in reverseLabelDatas) {
                        labelData.value = labelData.value == 0 ? labelData.value : -labelData.value;
                        labelData.title = [NSString stringWithFormat:@"%@", @(labelData.value)];
                        [xLabelDatas insertObject:labelData atIndex:0];
                    }
                }

                if (isMainAxis) {
                    self.chart.xAxisLabelDatas = xLabelDatas;
                } else {
                    self.chart.xSecondAxisLabelDatas = xLabelDatas;
                }

                break;
            }

        }
    }
}


#pragma mark - override


- (void)drawChart {
    [super drawChart];


    [self.chart drawChart];
}

#pragma mark - public method

- (void)setMainData:(DTDimension2ListModel *)mainData secondData:(DTDimension2ListModel *)secondData {
    if (mainData && secondData && mainData.listDimensions.count != secondData.listDimensions.count) {
        return;
    }

    self.chart.mainData = mainData;
    self.chart.secondData = secondData;

//    [self processXLabelData:4 axisMaxValue:300 axisMinValue:-950 isMainAxis:YES];
    [self processXLabelData:4 axisMaxValue:mainData.maxValue axisMinValue:mainData.minValue isMainAxis:YES];
    [self processXLabelData:4 axisMaxValue:secondData.maxValue axisMinValue:secondData.minValue isMainAxis:NO];
}


@end
