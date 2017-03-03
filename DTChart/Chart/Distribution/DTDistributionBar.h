//
//  DTDistributionBar.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/3.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTChartSingleData;
@class DTDistributionBar;
@class DTChartItemData;

/**
 * 每6个item之间的间距是CGRectGetHeight(contentView.frame)的比例
 */
extern NSUInteger const DTDistributionBarSectionGapRatio;
/**
 * 每个item之间的间距，默认1
 */
extern NSUInteger const DTDistributionBarItemGap;


@protocol DTDistributionBarDelegate <NSObject>

@optional
- (void)distributionBarItemBeginTouch:(DTChartSingleData *)singleData data:(DTChartItemData *)itemData location:(CGPoint)point;

- (void)distributionBarItemEndTouch;

@end


@interface DTDistributionBar : UIView

@property(nonatomic, weak) id <DTDistributionBarDelegate> delegate;

@property(nonatomic) NSInteger startHour;

@property(nonatomic) DTChartSingleData *singleData;

+ (instancetype)distributionBar;


- (void)drawSubItems;

@end
