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
    DTBarOrientationRight       // 方向朝右
};


typedef NS_ENUM(NSInteger, DTBarBorderStyle) {
    DTBarBorderStyleNone,              // 没有边线
    DTBarBorderStyleTopBorder,         // 边线在顶部
    DTBarBorderStyleSidesBorder        // 边线在两侧
};

@class DTChartItemData;
@class DTBar;


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
/**
 * 柱状体方向
 */
@property(nonatomic) DTBarOrientation barOrientation;
/**
 * 柱状体边线风格
 */
@property(nonatomic) DTBarBorderStyle barBorderStyle;
/**
 * 标记用
 */
@property(nonatomic) CGFloat barTag;

/**
 * 存储数据model
 */
@property(nonatomic, weak) DTChartItemData *barData;
/**
 * 柱状体主颜色
 */
@property(nonatomic) UIColor *barColor;
/**
 * 柱状体边线颜色
 */
@property(nonatomic) UIColor *barBorderColor;
/**
 * 是否可以被选中
 */
@property(nonatomic, getter=isBarSelectable) BOOL barSelectable;


/**
 * 实例化
 * @param orientation 方向
 * @param style 柱状体样式
 * @return instance
 */
+ (instancetype)bar:(DTBarOrientation)orientation style:(DTBarBorderStyle)style;

/**
 * 柱状体被选中
 */
- (void)barDidSelected;

/**
 * 显示柱状体出现动画
 */
- (void)startAppearAnimation;

/**
 * 被选择的动画
 */
- (void)startSelectedAnimation;

@end
