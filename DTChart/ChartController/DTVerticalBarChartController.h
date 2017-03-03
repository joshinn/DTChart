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

@property(nonatomic) NSString *(^barChartControllerTouchBlock)(NSUInteger touchIndex);

@end
