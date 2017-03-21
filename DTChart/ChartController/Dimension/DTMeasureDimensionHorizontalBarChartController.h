//
//  DTMeasureDimensionHorizontalBarChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/2.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"
#import "DTBarChart.h"

@class DTDimensionModel;
@class DTDimensionBarModel;

@interface DTMeasureDimensionHorizontalBarChartController : DTChartController

@property(nonatomic) DTBarChartStyle barChartStyle;

@property(nonatomic) NSArray<DTDimensionBarModel *> *levelLowestBarModels;

- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat __attribute__((unavailable("DTMeasureDimensionHorizontalBarChartController use -setMainItem:secondItem: replace")));

- (void)setMainItem:(DTDimensionModel *)mainItem secondItem:(DTDimensionModel *)secondItem;
@end
