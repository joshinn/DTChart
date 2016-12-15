//
//  DTBarChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"
#import "DTBar.h"

@interface DTBarChart : DTChartBaseComponent <DTBarDelegate>

/**
 * 柱形图柱子宽度，默认是1个单元格
 */
@property(nonatomic) CGFloat barWidth;
/**
 * 柱状体是否可点击选择
 */
@property(nonatomic, getter=isBarSelectable) BOOL barSelectable;
/**
 * 柱状体风格
 */
@property(nonatomic) DTBarStyle barStyle;
/**
 * 柱状体颜色
 */
@property(nonatomic) UIColor *barColor;
/**
 * 柱状体边线颜色
 */
@property(nonatomic) UIColor *barBorderColor;
/**
 * 绘制x轴标签
 */
- (void)drawXAxisLabels;

/**
 * 绘制y轴标签
 */
- (void)drawYAxisLabels;

/**
 * 绘制坐标轴线
 */
- (void)drawAxisLine;

/**
 * 绘制坐标轴里的值
 */
- (void)drawValues;

/**
 * 清除坐标轴label，和坐标内的柱状体
 */
- (void)clearChartContent;
@end
