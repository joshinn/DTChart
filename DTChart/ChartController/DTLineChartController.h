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
 * @param lineIndex 折线的序号(哪一组数据)
 * @param pointIndex 折线中的点的序号
 * @param isMainAxis 是否是主轴
 */
typedef void(^DTLineChartTouchBlock)(NSUInteger lineIndex, NSUInteger pointIndex, BOOL isMainAxis);


@interface DTLineChartController : DTChartController


/**
 * 手势选择回调
 */
@property(nonatomic, copy) DTLineChartTouchBlock lineChartTouchBlock;


@end
