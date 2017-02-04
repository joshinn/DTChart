//
//  DTFillChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"

@interface DTFillChartController : DTChartController

/**
 * 指定绘制数据的起始位置，默认0
 */
@property(nonatomic) NSUInteger beginRangeIndex;
/**
 * 指定绘制数据的结束位置，默认NSUIntegerMax
 */
@property(nonatomic) NSUInteger endRangeIndex;


@end
