//
//  DTVerticalBarChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/13.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"
#import "DTBarChart.h"

@interface DTVerticalBarChartController : DTChartController

@property (nonatomic) DTBarChartStyle barChartStyle;
/**
 * 柱状体宽度，以单元格为单位，默认1个单元格
 */
@property (nonatomic) CGFloat barWidth;

/**
 * 柱状图触摸回调
 * @return 触摸提示内容
 * @note param dataIndex 第几组数据
 * @note param barIndex  数据里的第几根柱状体
 */
@property(nonatomic) NSString *(^barChartControllerTouchBlock)(NSUInteger dataIndex, NSUInteger barIndex);

@end
