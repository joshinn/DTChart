//
//  DTBar.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTBar;
@class DTChartItemData;

typedef NS_ENUM(NSInteger, DTBarOrientation) {
    DTBarOrientationUp,         // 方向朝上，默认方向
//    DTBarOrientationDown,       // 方向朝下
//    DTBarOrientationLeft,       // 方向朝左
    DTBarOrientationRight       // 方向朝右
};

typedef NS_ENUM(NSInteger, DTBarBorderStyle) {
    DTBarBorderStyleNone,              // 没有边线
    DTBarBorderStyleTopBorder,         // 边线在顶部
    DTBarBorderStyleSidesBorder        // 边线在两侧
};


@protocol DTBarDelegate <NSObject>

@optional
- (void)_DTBarSelected:(DTBar *)bar;

@end


/**
 * 柱状图里的柱状体
 *
 * @attention 不要直接使用init初始化
 */
@interface DTBar : UIView

@property(nonatomic, weak) id <DTBarDelegate> delegate;

@property(nonatomic) DTBarOrientation barOrientation;
@property(nonatomic) DTBarBorderStyle barBorderStyle;
@property(nonatomic) UIColor *barColor;
@property(nonatomic) UIColor *barBorderColor;
/**
 * 存储数据model
 */
@property(nonatomic, weak) DTChartItemData *barData;

/**
 * 实例化，DTBarOrientationUp，DTBarBorderStyleTopBorder
 * @return instance
 */
+ (instancetype)bar;

/**
 * 实例化
 * @param orientation 方向
 * @param style 柱状体样式
 * @return instance
 */
+ (instancetype)bar:(DTBarOrientation)orientation style:(DTBarBorderStyle)style;

/**
 * 显示柱状体出现动画
 */
- (void)startAppearAnimation;

/**
 * 被选择的动画
 */
- (void)startSelectedAnimation;

@end
