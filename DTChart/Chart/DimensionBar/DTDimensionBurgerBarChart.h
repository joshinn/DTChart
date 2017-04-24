//
//  DTDimensionBurgerBarChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/9.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTBarChart.h"

@class DTDimensionModel;

@interface DTDimensionBurgerBarChart : DTBarChart

/**
 * 柱状图的数据model
 */
@property(nonatomic) DTDimensionModel *dimensionModel;
/**
 * x轴第一个柱状体偏移量，默认0，让所有柱状体居中时使用
 */
@property(nonatomic) CGFloat xOffset;
/**
 * 柱状体之间的距离，默认2个单元格
 */
@property (nonatomic) CGFloat barGap;

@end
