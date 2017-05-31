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
 * 所有维度数据，用于触摸提示用
 * @note 数据格式自定义
 */
@property(nonatomic) NSArray *dimensionDatas;

/**
 * 度量数据，用于触摸提示用
 * @note 数据格式自定义
 */
@property(nonatomic) id measureData;

@property(nonatomic, copy) NSString *(^touchBurgerSubBarBlock)(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, DTDimensionModel *touchData, id dimensionData, id measureData);

- (void)setItem:(DTDimensionModel *)dimensionModel;
@end
