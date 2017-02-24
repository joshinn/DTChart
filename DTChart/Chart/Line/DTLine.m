//
//  DTLine.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/14.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTLine.h"
#import "UIBezierPath+DTExternal.h"


@interface DTLine ()

@property(nonatomic) CAShapeLayer *pointLayer;

@end

@implementation DTLine

static CGFloat const DTLineDefaultLineWidth = 5;


+ (instancetype)line:(DTLinePointType)pointType {
    DTLine *dtLine = [DTLine layer];
    dtLine.fillColor = nil;
    dtLine.lineCap = kCALineCapRound;
    dtLine.lineJoin = kCALineJoinBevel;
    dtLine.lineWidth = DTLineDefaultLineWidth;
    dtLine.pointType = pointType;
    dtLine.strokeStart = 0;
    dtLine.strokeEnd = 1;
    return dtLine;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;

    self.strokeColor = lineColor.CGColor;
}

- (void)setSingleData:(DTChartSingleData *)singleData {
    _singleData = singleData;

    self.lineWidth = singleData.lineWidth;
    if (singleData.color) {
        self.lineColor = singleData.color;
    }
    if (singleData.secondColor) {
        self.pointLayer.fillColor = singleData.secondColor.CGColor;
    }
}


- (void)setLineWidth:(CGFloat)lineWidth {
    [super setLineWidth:lineWidth];

    self.pointLayer.lineWidth = MAX(lineWidth / 2, 1);
}


- (CAShapeLayer *)pointLayer {
    if (!_pointLayer) {
        _pointLayer = [CAShapeLayer layer];
        _pointLayer.fillColor = [UIColor whiteColor].CGColor;
        _pointLayer.lineCap = kCALineCapRound;
        _pointLayer.lineJoin = kCALineJoinBevel;
        _pointLayer.lineWidth = DTLineDefaultLineWidth / 2;
        _pointLayer.strokeStart = 0;
        _pointLayer.strokeEnd = 1;
    }
    return _pointLayer;
}

- (void)setLinePath:(UIBezierPath *)linePath {
    [super setPath:linePath.CGPath];

    _linePath = linePath;

}


#pragma mark - private method

/**
 * 绘制最大最小值点
 */
- (void)drawEdgePoint {
    DTChartItemData *minData = self.singleData.itemValues[self.singleData.minValueIndex];
    DTChartItemData *maxData = self.singleData.itemValues[self.singleData.maxValueIndex];


    CGFloat r = self.lineWidth;
    UIBezierPath *minPointPath;
    UIBezierPath *maxPointPath;
    switch (self.pointType) {
        case DTLinePointTypeCircle: {
            minPointPath = [UIBezierPath bezierPathWithArcCenter:minData.position radius:r startAngle:0 endAngle:(CGFloat) (2 * M_PI) clockwise:YES];
            maxPointPath = [UIBezierPath bezierPathWithArcCenter:maxData.position radius:r startAngle:0 endAngle:(CGFloat) (2 * M_PI) clockwise:YES];
        }
            break;
        case DTLinePointTypeTriangle: {
            minPointPath = [UIBezierPath bezierPathWithTriangle:minData.position radius:2 * r];
            maxPointPath = [UIBezierPath bezierPathWithTriangle:maxData.position radius:2 * r];
        }
            break;
        case DTLinePointTypeSquare: {
            minPointPath = [UIBezierPath bezierPathWithRect:CGRectMake(minData.position.x - r, minData.position.y - r, 2 * r, 2 * r)];
            maxPointPath = [UIBezierPath bezierPathWithRect:CGRectMake(maxData.position.x - r, maxData.position.y - r, 2 * r, 2 * r)];
        }
            break;
        default: {
            minPointPath = [UIBezierPath bezierPathWithArcCenter:minData.position radius:r startAngle:0 endAngle:(CGFloat) (2 * M_PI) clockwise:YES];
            maxPointPath = [UIBezierPath bezierPathWithArcCenter:maxData.position radius:r startAngle:0 endAngle:(CGFloat) (2 * M_PI) clockwise:YES];
        }
    }

    if (self.superlayer) {
        [self addSublayer:self.pointLayer];
    }
    [minPointPath appendPath:maxPointPath];
    self.pointLayer.strokeColor = self.lineColor.CGColor;
    if (self.singleData.secondColor) {
        self.pointLayer.fillColor = self.singleData.secondColor.CGColor;
    }
    self.pointLayer.path = minPointPath.CGPath;
}

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

- (void)startPathUpdateAnimation:(UIBezierPath *)updatePath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (id) self.path;
    animation.toValue = (id) updatePath.CGPath;
    animation.duration = 0.5;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;

    [self addAnimation:animation forKey:@"changeLine"];

    self.linePath = updatePath;
}

- (void)startDisappearAnimation {

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @1;
    animation.toValue = @0;
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = NO;

    [self addAnimation:animation forKey:@"eraseLine"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperlayer];
    });
}


- (void)drawEdgePoint:(NSTimeInterval)delay{
    if (delay == 0) {
        [self drawEdgePoint];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self drawEdgePoint];
        });
    }


}


- (void)removeEdgePoint {
    if (self.pointLayer.superlayer) {
        [self.pointLayer removeFromSuperlayer];
    }
}

@end
