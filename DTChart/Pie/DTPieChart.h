//
//  DTPieChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/26.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"

typedef void(^DTPieChartTouchBlock)(NSUInteger index);

@interface DTPieChart : DTChartBaseComponent

@property(nonatomic, copy) DTPieChartTouchBlock pieChartTouchBlock;

/**
 * 指定绘制multiData里的单独某个数据
 * @attention -1表示绘制全部，默认
 * @attention 范围：[0, multiData.count)
 */
@property(nonatomic) NSInteger drawSingleDataIndex;

/**
 * pie图距离边界的距离，默认是2
 */
@property (nonatomic) CGFloat pieMargin;

@end
