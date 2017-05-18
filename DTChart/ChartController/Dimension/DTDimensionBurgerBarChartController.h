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

@property (nonatomic) DTBarChartStyle barChartStyle;

@property(nonatomic, copy) NSString *(^touchBurgerSubBarBlock)(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, DTDimensionModel *touchData);

- (void)setItem:(DTDimensionModel *)dimensionModel;
@end
