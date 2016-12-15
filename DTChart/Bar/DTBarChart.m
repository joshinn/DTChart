//
//  DTBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTBarChart.h"
#import "DTChartLabel.h"

@interface DTBarChart ()


@end

@implementation DTBarChart

@synthesize coordinateAxisLine = _coordinateAxisLine;

static NSUInteger const DefaultBarWidth = 1;

- (void)initial {
    [super initial];

    _barWidth = DefaultBarWidth;
    _barSelectable = YES;
}

#pragma mark - delay init


#pragma mark - method

- (void)drawXAxisLabels {

}

- (void)drawYAxisLabels {
}

/**
 * 绘制坐标轴线
 */
- (void)drawAxisLine {

    // x axis line
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path moveToPoint:self.originPoint];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), self.originPoint.y)];

    // y axis line
    [path moveToPoint:self.originPoint];
    [path addLineToPoint:CGPointMake(self.originPoint.x, 0)];

    self.coordinateAxisLine.path = path.CGPath;
    self.coordinateAxisLine.hidden = !self.isShowCoordinateAxisLine;
    [self.layer addSublayer:self.coordinateAxisLine];
}

- (void)drawValues {

}

- (void)clearChartContent {
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            [obj removeFromSuperview];
        }
    }];
}

#pragma mark - public method

- (void)drawChart {

    [super drawChart];

    [self clearChartContent];

    [self drawAxisLine];

    [self drawXAxisLabels];
    [self drawYAxisLabels];

    [self drawValues];
}


@end
