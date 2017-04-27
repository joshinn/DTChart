//
//  DTDistributionChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/30.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"


typedef NS_ENUM(NSInteger, DTDistributionChartYAxisStyle) {
    DTDistributionChartYAxisStyleNone = 0,  // 无Y轴标签，默认
    DTDistributionChartYAxisStyleSmall = 1, // 预设小界面风格
    DTDistributionChartYAxisStyleLarge = 2, // 预设大界面风格
    DTDistributionChartYAxisStyleCustom = 3,    // 自定义风格
};

/** 程度最低 */
#define DTDistributionNullLevelColor DTRGBColor(0x01081a, 1)
/** 程度最低 */
#define DTDistributionLowLevelColor DTRGBColor(0xd8d8d8, 1)
/** 程度中等 */
#define DTDistributionMiddleLevelColor DTRGBColor(0x014898, 1)
/** 程度高 */
#define DTDistributionHighLevelColor DTRGBColor(0x0095d9, 1)
/** 程度最高 */
#define DTDistributionSupremeLevelColor DTRGBColor(0x5ac3d9, 1)


@interface DTDistributionChart : DTChartBaseComponent

/**
 * 设置y轴风格
 * @note DTDistributionChartYAxisStyleNone 无Y轴标签，默认
 * @note DTDistributionChartYAxisStyleSmall 预设小界面风格
 * @note DTDistributionChartYAxisStyleLarge 预设大界面风格
 * @note DTDistributionChartYAxisStyleCustom 自定义风格
 * @attention DTDistributionChartYAxisStyleCustom时，self.yAxisLabelDatas会置为nil，需要赋值
 * @attention 修改style，会修改self.coordinateAxisInsets
 */
@property(nonatomic) DTDistributionChartYAxisStyle chartYAxisStyle;

/**
 * y轴起始时间整点数，默认是7
 */
@property(nonatomic) NSInteger startHour;
/**
 * 空值颜色，默认 01081a
 */
@property(nonatomic) UIColor *nullLevelColor;
/**
 * 空值上限，默认0
 * @note 范围 (-∞, 0)
 */
@property(nonatomic) CGFloat nullLevel;
/**
 * 最弱颜色，默认 01081a
 */
@property(nonatomic) UIColor *lowLevelColor;
/**
 * 最弱的上限值，默认100
 * @note 范围 [0, 100)
 */
@property(nonatomic) CGFloat lowLevel;
/**
 * 中等颜色，默认 014898
 */
@property(nonatomic) UIColor *middleLevelColor;
/**
 * 中等的上限值，默认500
 * @note 范围 [100, 100)
 */
@property(nonatomic) CGFloat middleLevel;
/**
 * 强颜色，默认 0095d9
 */
@property(nonatomic) UIColor *highLevelColor;
/**
 * 强的上限值，默认1000
 * @note 范围 [500, 1000)
 */
@property(nonatomic) CGFloat highLevel;
/**
 * 最强颜色，默认 5ac3d9
 */
@property(nonatomic) UIColor *supremeLevelColor;

@property(nonatomic, copy) NSString *(^distributionChartTouchBlock)(DTChartSingleData *singleData, DTChartItemData *itemData);

@end
