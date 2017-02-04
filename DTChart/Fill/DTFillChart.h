//
//  DTFillChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"

@interface DTFillChart : DTChartBaseComponent

/**
 * x轴标签是否与格子对齐，默认是NO
 */
@property(nonatomic) BOOL xAxisAlignGrid;

/**
 * 指定绘制数据的起始位置，默认0
 */
@property(nonatomic) NSUInteger beginRangeIndex;
/**
 * 指定绘制数据的结束位置，默认NSUIntegerMax
 */
@property(nonatomic) NSUInteger endRangeIndex;

@end
