//
//  DTColorManager.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/23.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

@import UIKit;

@interface DTColorManager : NSObject

/**
 * 颜色管理实例
 * @return instance
 */
+ (instancetype)manager;
/**
 * 颜色管理实例，颜色会随便排序
 * @return instance
 */
+ (instancetype)randomManager;

+ (UIColor *)getLightColor:(UIColor *)color;

/**
 * 获取主颜色
 * @return 颜色
 */
- (UIColor *)getColor;

/**
 * 获取副颜色
 * @param color 主颜色
 * @return 副颜色
 */
- (UIColor *)getLightColor:(UIColor *)color;
@end
