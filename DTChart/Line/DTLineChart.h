//
//  DTLineChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"


typedef void(^DTLineChartTouchBlock)(NSUInteger lineIndex, NSUInteger pointIndex, DTChartItemData *itemData);

@interface DTLineChart : DTChartBaseComponent

@property(nonatomic, copy) DTLineChartTouchBlock lineChartTouchBlock;
/**
 * x轴标签是否与格子对齐
 */
@property(nonatomic) BOOL xAxisAlignGrid;

@end
