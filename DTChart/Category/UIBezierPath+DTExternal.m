//
//  UIBezierPath+DTExternal.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/15.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "UIBezierPath+DTExternal.h"

@implementation UIBezierPath (DTExternal)

+ (instancetype)bezierPathWithTriangle:(CGPoint)center radius:(CGFloat)radius {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(center.x, center.y - radius)];
    [bezierPath addLineToPoint:CGPointMake(center.x - radius / 2, center.y + radius / 2)];
    [bezierPath addLineToPoint:CGPointMake(center.x + radius / 2, center.y + radius / 2)];
    [bezierPath closePath];

    return bezierPath;
}

@end
