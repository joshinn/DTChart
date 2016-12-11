//
//  DTBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTBarChart.h"

@interface DTBarChart ()


@end

@implementation DTBarChart

@synthesize coordinateAxisLine = _coordinateAxisLine;

static NSUInteger const DefaultBarWidth = 1;

- (void)initial {
    [super initial];

    _barWidth = DefaultBarWidth;
}

#pragma mark - delay init


#pragma mark - method

- (void)drawXAxisLabels {

//    CGFloat xSectionWidth = self.xAxisLength / self.xAxisLabelDatas.count;
//    self.xAxisSectionLength = xSectionWidth;
//
//    CGFloat x = self.coordinateAxisInsets.left;
//    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
//        DTAxisLabelData *data = self.xAxisLabelDatas[i];
//        DTChartLabel *xLabel = [DTChartLabel chartLabel];
//        xLabel.textAlignment = NSTextAlignmentCenter;
//        xLabel.text = data.title;
//        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: xLabel.font}];
//
//        xLabel.frame = CGRectMake(x, CGRectGetHeight(self.frame) - self.coordinateAxisInsets.bottom + 2, xSectionWidth, size.height);
//        data.axisPositionValue = x + xSectionWidth / 2;
//
//        x += xSectionWidth;
//
//        xLabel.hidden = !self.showCoordinateAxis;
//
//        [self addSubview:xLabel];
//    }
}

- (void)drawYAxisLabels {
//
//    CGFloat ySectionHeight = self.yAxisLength / self.yAxisLabelDatas.count;
//    self.yAxisSectionLength = ySectionHeight;
//
//    CGFloat y = 0;
//    for (NSUInteger i = 0; i < self.yAxisLabelDatas.count; ++i) {
//        DTAxisLabelData *data = self.yAxisLabelDatas[i];
//        DTChartLabel *yLabel = [DTChartLabel chartLabel];
//        yLabel.text = data.title;
//        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: yLabel.font}];
//
//        y = CGRectGetHeight(self.frame) - ySectionHeight * i - self.coordinateAxisInsets.bottom - size.height / 2;
//        yLabel.frame = CGRectMake(2, y, size.width, size.height);
//
//        data.axisPositionValue = y + size.height / 2;
//
//        yLabel.hidden = !self.showCoordinateAxis;
//
//        [self addSubview:yLabel];
//    }
//
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
    self.coordinateAxisLine.hidden = !self.showCoordinateAxisLine;
    [self.layer addSublayer:self.coordinateAxisLine];
}

- (void)drawValues {
//    [self.xAxisLabelDatas enumerateObjectsUsingBlock:^(DTAxisLabelData *obj, NSUInteger idx, BOOL *stop) {
//        NSLog(@"value = %.1f  ** %.3f", obj.value, obj.axisPositionValue);
//    }];
//
//    DTAxisLabelData *maxXLabelData = self.xAxisLabelDatas.lastObject;
//    DTAxisLabelData *maxYLabelData = self.yAxisLabelDatas.lastObject;
//
////    for (NSUInteger i = 0; i < self.values.count; ++i) {
////        DTChartItemData *itemData = self.values[i];
////
////        CGFloat xPosition = itemData.itemValue.x / maxXLabelData.value * self.xAxisLength - self.xAxisSectionLength / 2;
////        CGFloat yPosition = (1 - itemData.itemValue.y / maxYLabelData.value) * self.yAxisLength;
////
////
////        itemData.axisPosition = CGPointMake(xPosition, yPosition);
////
////        DTBar *bar = [[DTBar alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
////        bar.backgroundColor = [UIColor blueColor];
////        bar.center = itemData.axisPosition;
////
////        [self.contentView addSubview:bar];
////    }
}

#pragma mark - public method

- (void)drawChart {

    [super drawChart];

    [self drawAxisLine];

    [self drawXAxisLabels];
    [self drawYAxisLabels];

    [self drawValues];
}


@end
