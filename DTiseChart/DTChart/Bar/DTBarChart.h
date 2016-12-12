//
//  DTBarChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"
#import "DTBar.h"

@interface DTBarChart : DTChartBaseComponent


/**
 * 柱形图柱子宽度，默认是1个单元格
 */
@property(nonatomic) CGFloat barWidth;
/**
 * 是否显示动画，默认YES
 */
@property(nonatomic, getter=isShowAnimation) BOOL showAnimation;
/**
 * 柱状体风格
 */
@property(nonatomic) DTBarStyle barStyle;
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

- (void)clearChartContent;
@end
