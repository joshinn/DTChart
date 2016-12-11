//
//  DTBarChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"

@interface DTBarChart : DTChartBaseComponent


@property(nonatomic) NSUInteger barMaxCount;
/**
 * 柱形图柱子宽度，默认是1个单元格
 */
@property(nonatomic) CGFloat barWidth;

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
@end
