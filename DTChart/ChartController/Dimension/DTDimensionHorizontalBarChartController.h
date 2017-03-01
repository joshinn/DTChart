//
//  DTDimensionHorizontalBarChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/1.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"

@class DTDimensionModel;

@interface DTDimensionHorizontalBarChartController : DTChartController

- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat __attribute__((unavailable("DTDimensionHorizontalBarChartController use -setItem replace")));

/**
 * 赋值，柱状图的所有值
 * @param dimensionModel 数据
 */
- (void)setItem:(DTDimensionModel *)dimensionModel;

@end
