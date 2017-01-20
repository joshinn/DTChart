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
@property (nonatomic) NSInteger startHour;
/**
 * 最弱颜色，默认 01081a
 */
@property (nonatomic) UIColor *lowLevelColor;
/**
 * 中等颜色，默认 014898
 */
@property (nonatomic) UIColor *middleLevelColor;
/**
 * 强颜色，默认 0095d9
 */
@property (nonatomic) UIColor *highLevelColor;
/**
 * 最强颜色，默认 5ac3d9
 */
@property (nonatomic) UIColor *supremeLevelColor;

@end
