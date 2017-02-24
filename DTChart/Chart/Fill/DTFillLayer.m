//
//  DTFillLayer.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTFillLayer.h"
#import "DTChartData.h"

@interface DTFillLayer ()

@property(nonatomic) CAShapeLayer *borderLine;

@end

@implementation DTFillLayer

+ (instancetype)fillLayer {
    DTFillLayer *dtLine = [DTFillLayer layer];

    return dtLine;
}

- (instancetype)init {
    if (self = [super init]) {
        _highLighted = NO;
        _normalFillColor = DTRGBColor(0x5981c6, 1);

        _borderLine = [CAShapeLayer layer];
        _borderLine.lineWidth = 1;
        _borderLine.fillColor = [UIColor clearColor].CGColor;
        _borderLine.strokeColor = DTRGBColor(0x3067b9, 1).CGColor;
        [self addSublayer:_borderLine];
    }
    return self;
}

- (void)setBorderLineColor:(UIColor *)borderLineColor {
    _borderLineColor = borderLineColor;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _borderLine.strokeColor = _borderLineColor.CGColor;
    [CATransaction commit];
}

- (void)setFillColor:(CGColorRef)fillColor {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [super setFillColor:fillColor];
    [CATransaction commit];
}

- (void)setHighLighted:(BOOL)highLighted {
    _highLighted = highLighted;

    if (highLighted) {
        self.fillColor = self.highlightedFillColor.CGColor;
    } else {
        self.fillColor = self.normalFillColor.CGColor;
    }
}

#pragma mark - public method

- (void)draw {
    self.borderLine.path = self.borderLinePath.CGPath;
    self.path = self.fillPath.CGPath;

    if (self.isHighLighted) {
        self.fillColor = self.highlightedFillColor.CGColor;
    } else {
        self.fillColor = self.normalFillColor.CGColor;
    }
    self.borderLine.strokeColor = self.borderLineColor.CGColor;
}

@end
