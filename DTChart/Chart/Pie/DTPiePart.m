//
//  DTPiePart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/26.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTPiePart.h"

@interface DTPiePart ()

@property(nonatomic) CAShapeLayer *selectedLayer;

@end

@implementation DTPiePart


+ (instancetype)piePartCenter:(CGPoint)center radius:(CGFloat)radius startPercentage:(CGFloat)startPercentage endPercentage:(CGFloat)endPercentage {

    DTPiePart *part = [DTPiePart layer];
    part.fillColor = nil;
    part.center = center;
    part.path = [DTPiePart arcPathCenter:center radius:radius].CGPath;
    part.lineWidth = radius;
    part.strokeStart = startPercentage;
    part.strokeEnd = endPercentage;
    return part;
}

+ (UIBezierPath *)arcPathCenter:(CGPoint)center radius:(CGFloat)radius {
    return [UIBezierPath bezierPathWithArcCenter:center radius:radius / 2 startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
}


- (CAShapeLayer *)selectedLayer {
    if (!_selectedLayer) {
        _selectedLayer = [CAShapeLayer layer];
        _selectedLayer.fillColor = nil;

        [self addSublayer:_selectedLayer];
    }
    return _selectedLayer;
}

- (void)setPartColor:(UIColor *)partColor {
    _partColor = partColor;
    self.strokeColor = partColor.CGColor;
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
}

- (void)setSelectBorderWidth:(CGFloat)selectBorderWidth {
    _selectBorderWidth = selectBorderWidth;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;

    if (selected) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.selectedLayer.strokeColor = self.selectColor.CGColor;
        self.selectedLayer.lineWidth = self.selectBorderWidth;
        self.selectedLayer.path = [DTPiePart arcPathCenter:self.center radius:self.lineWidth*2 + self.selectBorderWidth].CGPath;
        self.selectedLayer.strokeStart = self.strokeStart;
        self.selectedLayer.strokeEnd = self.strokeEnd;
        [CATransaction commit];

    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.selectedLayer.strokeColor = [UIColor clearColor].CGColor;
        [CATransaction commit];
    }
}

#pragma mark - private method


@end
