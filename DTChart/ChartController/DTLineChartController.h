//
//  DTLineChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"

/**
 * 触摸手势回调
 * @param seriesId 折线的seriesId
 * @param pointIndex 折线中的点的序号
 */
typedef void(^DTLineChartTouchBlock)(NSString * seriesId, NSUInteger pointIndex);


@interface DTLineChartController : DTChartController


/**
 * 手势选择回调
 */
@property(nonatomic, copy) DTLineChartTouchBlock lineChartTouchBlock;


@end
