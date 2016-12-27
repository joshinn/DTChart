//
//  DTPiePart.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/26.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

@import UIKit;

@interface DTPiePart : CAShapeLayer

@property(nonatomic) UIColor *partColor;
@property(nonatomic) UIColor *selectColor;
@property (nonatomic) CGFloat selectBorderWidth;



+ (instancetype)piePartCenter:(CGPoint)center radius:(CGFloat)radius startPercentage:(CGFloat)startPercentage endPercentage:(CGFloat)endPercentage;

+ (UIBezierPath *)arcPathCenter:(CGPoint)center radius:(CGFloat)radius;
@end

