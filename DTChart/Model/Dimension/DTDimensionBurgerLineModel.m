//
//  DTDimensionBurgerLineModel.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/9.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBurgerLineModel.h"

@interface DTDimensionBurgerLineModel ()

@property(nonatomic) CAShapeLayer *upperLine;
@property(nonatomic) CAShapeLayer *lowerLine;

@end

@implementation DTDimensionBurgerLineModel

- (CAShapeLayer *)upperLine {
    if (!_upperLine) {
        _upperLine = [self lineFactory];
    }
    return _upperLine;
}

- (CAShapeLayer *)lowerLine {
    if (!_lowerLine) {
        _lowerLine = [self lineFactory];
    }
    return _lowerLine;
}

- (CAShapeLayer *)lineFactory {
    CAShapeLayer *line = [CAShapeLayer layer];
    line.fillColor = nil;
    line.lineWidth = 1;
    line.strokeColor = DTRGBColor(0x7b7b7b, 1).CGColor;
    line.strokeStart = 0;
    line.strokeEnd = 1;

    return line;
}

- (void)setUpperPath:(UIBezierPath *)upperPath {
    _upperPath = upperPath;

    self.upperLine.path = upperPath.CGPath;
}

- (void)setLowerPath:(UIBezierPath *)lowerPath {
    _lowerPath = lowerPath;

    self.lowerLine.path = lowerPath.CGPath;
}

- (void)show:(CALayer *)superLayer {
    [superLayer addSublayer:self.upperLine];
    [superLayer addSublayer:self.lowerLine];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.4;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;

    [self.upperLine addAnimation:animation forKey:@"appear"];
    [self.lowerLine addAnimation:animation forKey:@"appear"];
}

- (void)hide {
    [self.upperLine removeFromSuperlayer];
    [self.lowerLine removeFromSuperlayer];

}

@end
