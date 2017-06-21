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
 * 空值的上限值，默认0
 * @note 范围 (-∞, 0)
 */
@property(nonatomic) CGFloat nullLevel;

/**
 * 最弱的上限值，默认100
 * @note 范围 [0, 100)
 */
@property(nonatomic) CGFloat lowLevel;

/**
 * 中等的上限值，默认500
 * @note 范围 [100, 500)
 */
@property(nonatomic) CGFloat middleLevel;

/**
 * 强的上限值，默认1000
 * @note 范围 [500, 1000)
 */
@property(nonatomic) CGFloat highLevel;

/**
 * 空值的标识文字，默认 "空"
 */
@property(nonatomic) NSString *nullLevelTitle;
/**
 * 最弱的标识文字，默认 "~100"
 */
@property(nonatomic) NSString *lowLevelTitle;
/**
 * 中等的标识文字，默认 "~500"
 */
@property(nonatomic) NSString *middleLevelTitle;
/**
 * 强的标识文字，默认 "~1000"
 */
@property(nonatomic) NSString *highLevelTitle;
/**
 * 最强的标识文字，默认 ">=1000"
 */
@property(nonatomic) NSString *supremeLevelTitle;

@property(nonatomic) UIColor *nullLevelColor;
@property(nonatomic) UIColor *lowLevelColor;
@property(nonatomic) UIColor *middleLevelColor;
@property(nonatomic) UIColor *highLevelColor;
@property(nonatomic) UIColor *supremeLevelColor;

@property(nonatomic, copy) NSString *(^mainDistributionControllerTouchBlock)(NSString *seriesId, NSInteger time);
/**
 * 副表 空值的上限值，默认0
 * @note 范围 (-∞, 0)
 */
@property(nonatomic) CGFloat secondNullLevel;
/**
 * 副表 最弱的上限值，默认100
 * @note 范围 [0, 100)
 */
@property(nonatomic) CGFloat secondLowLevel;
/**
 * 副表 中等的上限值，默认500
 * @note 范围 [100, 500)
 */
@property(nonatomic) CGFloat secondMiddleLevel;
/**
 * 副表 强的上限值，默认1000
 * @note 范围 [500, 1000)
 */
@property(nonatomic) CGFloat secondHighLevel;

/**
 * 副表 空值的标识文字，默认 "空"
 */
@property(nonatomic) NSString *secondNullLevelTitle;
/**
 * 副表 最弱的标识文字，默认 "~100"
 */
@property(nonatomic) NSString *secondLowLevelTitle;
/**
 * 副表 中等的标识文字，默认 "~500"
 */
@property(nonatomic) NSString *secondMiddleLevelTitle;
/**
 * 副表 强的标识文字，默认 "~1000"
 */
@property(nonatomic) NSString *secondHighLevelTitle;
/**
 * 副表 最强的标识文字，默认 ">=1000"
 */
@property(nonatomic) NSString *secondSupremeLevelTitle;

@property(nonatomic) UIColor *secondNullLevelColor;
@property(nonatomic) UIColor *secondLowLevelColor;
@property(nonatomic) UIColor *secondMiddleLevelColor;
@property(nonatomic) UIColor *secondHighLevelColor;
@property(nonatomic) UIColor *secondSupremeLevelColor;


@property(nonatomic, copy) NSString *(^secondDistributionControllerTouchBlock)(NSString *seriesId, NSInteger time);
@end
