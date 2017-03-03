//
//  DTDistributionChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/20.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"

@class DTChartSingleData;
@class DTChartItemData;

@interface DTDistributionChartController : DTChartController

@property(nonatomic) NSString *mainTitle;
@property(nonatomic) NSString *secondTitle;

/**
 * y轴起始时间整点数，默认是7
 */
@property(nonatomic) NSUInteger startHour;

/**
 * 最弱的上限值，默认100
 */
@property(nonatomic) CGFloat lowLevel;
/**
 * 中等的上限值，默认500
 */
@property(nonatomic) CGFloat middleLevel;
/**
 * 强的上限值，默认1000
 */
@property(nonatomic) CGFloat highLevel;

@property(nonatomic, copy) NSString *(^mainDistributionControllerTouchBlock)(NSString *seriesId, NSInteger time);
/**
 * 副表 最弱的上限值，默认100
 */
@property(nonatomic) CGFloat secondLowLevel;
/**
 * 副表 中等的上限值，默认500
 */
@property(nonatomic) CGFloat secondMiddleLevel;
/**
 * 副表 强的上限值，默认1000
 */
@property(nonatomic) CGFloat secondHighLevel;

@property(nonatomic, copy) NSString *(^secondDistributionControllerTouchBlock)(NSString *seriesId, NSInteger time);
@end
