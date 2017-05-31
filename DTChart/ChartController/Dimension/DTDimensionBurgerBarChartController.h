//
//  DTDimensionBurgerBarChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/9.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"
#import "DTBarChart.h"

@class DTDimensionModel;

@interface DTDimensionBurgerBarChartController : DTChartController

@property(nonatomic) DTBarChartStyle barChartStyle;

/**
 * 所有维度名称，用于触摸提示用
 */
@property(nonatomic) NSArray<NSString *> *dimensionNames;

/**
 * 度量名称，用于触摸提示用
 */
@property(nonatomic) NSString *measureName;

@property(nonatomic, copy) NSString *(^touchBurgerSubBarBlock)(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, DTDimensionModel *touchData, NSString *dimensionName, NSString *measureName);

- (void)setItem:(DTDimensionModel *)dimensionModel;
@end
