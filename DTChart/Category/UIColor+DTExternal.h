//
//  UIColor+DTExternal.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/23.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DTExternal)

- (BOOL)compare:(UIColor *)color;

- (BOOL)compare:(UIColor *)color withTolerance:(CGFloat)tolerance;
@end
