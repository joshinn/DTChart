//
//  DTBarChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"
#import "DTBar.h"


typedef NS_ENUM(NSInteger, DTBarChartStyle) {
    DTBarChartStyleStartingLine,        // 同一个区间里，所有柱状体都从坐标轴开始，依次排序，默认属性
    DTBarChartStyleHeap,                // 同一个区间里的柱状条堆积一起逐层一个大的柱状体
    DTBarChartStyleLump,                 // 同一个区间里，一个是柱状条，其他是小的条形体
};


@interface DTBarChart : DTChartBaseComponent
/**
 * 柱状图风格，默认DTBarChartStyleStartingLine
 */
@property(nonatomic) DTBarChartStyle barChartStyle;

/**
 * 柱形图柱子宽度，默认是1个单元格
 */
@property(nonatomic) CGFloat barWidth;
/**
 * 柱状体边线风格
 */
@property(nonatomic) DTBarBorderStyle barBorderStyle;

@property(nonatomic) CALayer *touchSelectedLine;

@property(nonatomic) NSMutableArray<DTBar *> *chartBars;

@property(nonatomic) NSString *(^barChartTouchBlock)(NSUInteger touchIndex);

@end
