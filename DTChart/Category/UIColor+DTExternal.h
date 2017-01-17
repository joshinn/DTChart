//
//  UIColor+DTExternal.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/23.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DTExternal)
/**
 * 比较颜色 R G B A
 * @param color 对比的颜色
 * @return 是否一致
 */
- (BOOL)compare:(UIColor *)color;

/**
 * 比较颜色 R G B
 * @param color 对比的颜色
 * @return 是否一致
 */
- (BOOL)compareRGB:(UIColor *)color;

/**
 * 比较颜色 R G B A
 * @param color 颜色
 * @param tolerance 对比误差
 * @return 是否一致
 */
- (BOOL)compare:(UIColor *)color withTolerance:(CGFloat)tolerance;

/**
 * 比较颜色 R G B
 * @param color 颜色
 * @param tolerance 对比误差
 * @return 是否一致
 */
- (BOOL)compareRGB:(UIColor *)color withTolerance:(CGFloat)tolerance;
@end
