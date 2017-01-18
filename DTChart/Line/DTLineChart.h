//
//  DTLineChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"


@class DTLineChartSingleData;

/**
 * 触摸手势回调
 * @param lineIndex 折线的序号(哪一组数据)
 * @param pointIndex 折线中的点的序号
 * @param isMainAxis 是否是主轴
 */
typedef void(^DTLineChartTouchBlock)(NSUInteger lineIndex, NSUInteger pointIndex, BOOL isMainAxis);



/**
 * 折线图
 *
 * @attention DTChartSingleData 需要使用子类 DTLineChartSingleData，扩展了折线点的形状
 */
@interface DTLineChart : DTChartBaseComponent

/**
 * 手势选择回调
 */
@property(nonatomic, copy) DTLineChartTouchBlock lineChartTouchBlock;
/**
 * x轴标签是否与格子对齐，默认是NO
 */
@property(nonatomic) BOOL xAxisAlignGrid;

@end
