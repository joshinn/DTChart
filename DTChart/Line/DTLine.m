//
//  DTLine.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/14.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTLine.h"
#import "DTChartData.h"

@interface DTLine ()

@property(nonatomic) CAShapeLayer *minPointLayer;
@property(nonatomic) CAShapeLayer *maxPointLayer;

@end

@implementation DTLine


+ (instancetype)line:(DTLinePointType)pointType {
    DTLine *dtLine = [DTLine layer];
    dtLine.fillColor = nil;
    dtLine.lineCap = kCALineCapRound;
    dtLine.lineJoin = kCALineJoinBevel;
    dtLine.lineWidth = 2;
    dtLine.pointType = pointType;
    dtLine.strokeStart = 0;
    dtLine.strokeEnd = 1;
    return dtLine;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;

    self.strokeColor = lineColor.CGColor;
}

- (void)setValues:(NSArray<DTChartItemData *> *)values {
    _values = values;

}

- (void)setLineWidth:(CGFloat)lineWidth {
    [super setLineWidth:lineWidth];

    self.minPointLayer.lineWidth = lineWidth;
    self.maxPointLayer.lineWidth = lineWidth;
}

- (CAShapeLayer *)minPointLayer {
    if (!_minPointLayer) {
        _minPointLayer = [self pointLayer];
    }
    return _minPointLayer;
}

- (CAShapeLayer *)maxPointLayer {
    if (!_maxPointLayer) {
        _maxPointLayer = [self pointLayer];
    }
    return _maxPointLayer;
}

- (CAShapeLayer *)pointLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinBevel;
    layer.lineWidth = 2;
    layer.strokeStart = 0;
    layer.strokeEnd = 1;
    return layer;
}

- (void)setLinePath:(UIBezierPath *)linePath {
    [super setPath:linePath.CGPath];

    _linePath = linePath;
}


#pragma mark - private method


#pragma mark - public method

- (void)startAppearAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;

    [self addAnimation:animation forKey:@"drawLine"];

}

- (void)drawEdgePoint {
    DTChartItemData *minData = self.values.firstObject;
    DTChartItemData *maxData = self.values.firstObject;

    for (DTChartItemData *data in self.values) {
        if (data.itemValue.y >= maxData.itemValue.y) {
            maxData = data;
        }

        if (data.itemValue.y < minData.itemValue.y) {
            minData = data;
        }
    }


    if (minData == maxData) {
        return;
    }

    UIBezierPath *minPointPath = [UIBezierPath bezierPathWithArcCenter:minData.position radius:4 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    UIBezierPath *maxPointPath = [UIBezierPath bezierPathWithArcCenter:maxData.position radius:4 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    if (self.superlayer) {
        [self.superlayer addSublayer:self.minPointLayer];
        [self.superlayer addSublayer:self.maxPointLayer];
    }
    self.minPointLayer.strokeColor = self.lineColor.CGColor;
    self.minPointLayer.path = minPointPath.CGPath;

    self.maxPointLayer.strokeColor = self.lineColor.CGColor;
    self.maxPointLayer.path = maxPointPath.CGPath;

}

- (void)removeEdgePoint {
    if (self.minPointLayer.superlayer) {
        [self.minPointLayer removeFromSuperlayer];
    }
    if (self.maxPointLayer.superlayer) {
        [self.maxPointLayer removeFromSuperlayer];
    }
}

@end
