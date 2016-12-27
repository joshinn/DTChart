//
//  DTPiePart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/26.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTPiePart.h"

@implementation DTPiePart


+ (instancetype)piePartCenter:(CGPoint)center radius:(CGFloat)radius startPercentage:(CGFloat)startPercentage endPercentage:(CGFloat)endPercentage {

    DTPiePart *part = [DTPiePart layer];
    part.fillColor = nil;
    part.path = [DTPiePart arcPathCenter:center radius:radius].CGPath;
    part.lineWidth = radius;
    part.strokeStart = startPercentage;
    part.strokeEnd = endPercentage;
    return part;
}

+ (UIBezierPath *)arcPathCenter:(CGPoint)center radius:(CGFloat)radius {
    return [UIBezierPath bezierPathWithArcCenter:center radius:radius / 2 startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
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

@end
