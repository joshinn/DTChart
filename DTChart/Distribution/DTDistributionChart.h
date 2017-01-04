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

@end
