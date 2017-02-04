//
//  DTFillLayer.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTFillLayer.h"

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
        self.fillColor = DTRGBColor(0x5981c6, 1).CGColor;

        _borderLine = [CAShapeLayer layer];
        _borderLine.lineWidth = 1;
        _borderLine.fillColor = [UIColor clearColor].CGColor;
        _borderLine.strokeColor = DTRGBColor(0x3067b9, 1).CGColor;
        [self addSublayer:_borderLine];
    }
    return self;
}

- (void)setStrokeColor:(CGColorRef)strokeColor {
    _borderLine.strokeColor = strokeColor;
}


#pragma mark - public method

- (void)draw {
    self.borderLine.path = self.borderPath.CGPath;
    self.path = self.fillPath.CGPath;
}

@end
