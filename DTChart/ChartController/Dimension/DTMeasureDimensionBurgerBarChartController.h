//
//  DTMeasureDimensionBurgerBarChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/20.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"
#import "DTBarChart.h"

@class DTDimensionModel;

@interface DTMeasureDimensionBurgerBarChartController : DTChartController

- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat __attribute__((unavailable("DTMeasureDimensionHorizontalBarChartController use -setMainItem:secondItem: replace")));

- (void)setMainItem:(DTDimensionModel *)mainItem secondItem:(DTDimensionModel *)secondItem;

@property(nonatomic, copy) NSString *(^touchBurgerMainSubBarBlock)(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, DTDimensionModel *touchData);

@property(nonatomic, copy) NSString *(^touchBurgerSecondSubBarBlock)(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, DTDimensionModel *touchData);

@end
