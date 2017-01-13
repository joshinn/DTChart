//
//  DTTableChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/13.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTTableChartController.h"
#import "DTTableChart.h"

@interface DTTableChartController ()

@property(nonatomic) DTTableChart *tableChart;

@end

@implementation DTTableChartController

@synthesize chartView = _chartView;

- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        _tableChart = [DTTableChart tableChart:DTTableChartStyleC1C2 origin:origin widthCellCount:xCount heightCellCount:yCount];
    }
    return self;
}

- (UIView *)chartView {
    if (!_chartView) {
        _chartView = self.tableChart;
    }
    return _chartView;
}


#pragma mark - private method



@end
