//
//  UIColor+DTExternal.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/23.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "UIColor+DTExternal.h"

@implementation UIColor (DTExternal)

- (BOOL)compare:(UIColor *)color {
    return [self compare:color withTolerance:0.00001];
}

- (BOOL)compare:(UIColor *)color withTolerance:(CGFloat)tolerance {
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color getRed:&r2 green:&g2 blue:&b2 alpha:&a2];

    return fabs(r1 - r2) <= tolerance
            && fabs(g1 - g2) <= tolerance
            && fabs(b1 - b2) <= tolerance
            && fabs(a1 - a2) <= tolerance;
}

@end
