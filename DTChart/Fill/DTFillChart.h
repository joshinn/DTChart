//
//  DTFillChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"

/**
 * 触摸手势回调
 * @param lineIndex 折线的序号(哪一组数据)
 * @param pointIndex 折线中的点的序号
 * @return 返回文本
 */
typedef NSString *(^DTFillChartTouch)(NSUInteger lineIndex, NSUInteger pointIndex);


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

@property(nonatomic, copy) DTFillChartTouch fillChartTouchBlock;

@end
