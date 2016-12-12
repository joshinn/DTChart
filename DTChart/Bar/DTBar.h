//
//  DTBar.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DTBarOrientation) {
    DTBarOrientationUp,         // 方向朝上，默认方向
    DTBarOrientationDown,       // 方向朝下
    DTBarOrientationLeft,       // 方向朝左
    DTBarOrientationRight       // 方向朝右
};

typedef NS_ENUM(NSInteger, DTBarStyle) {
    DTBarStyleTopBorder,         // 边线在顶部
    DTBarStyleSidesBorder        // 边线在两侧
};


@interface DTBar : UIView

@property(nonatomic, readonly) DTBarOrientation barOrientation;
@property(nonatomic, readonly) DTBarStyle barStyle;
@property(nonatomic) UIColor *barColor;
@property(nonatomic) UIColor *barBorderColor;

/**
 * 实例化，DTBarOrientationUp，DTBarStyleTopBorder
 * @return instance
 */
+ (instancetype)bar;

/**
 * 实例化
 * @param orientation 方向
 * @param style 柱状体样式
 * @return instance
 */
+ (instancetype)bar:(DTBarOrientation)orientation style:(DTBarStyle)style;

/**
 * 显示动画
 */
- (void)startAnimation;


@end
