//
//  DTDimensionVerticalBarChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/28.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"
#import "DTBarChart.h"

@class DTDimensionModel;
@class DTDimensionBarModel;

@interface DTDimensionVerticalBarChartController : DTChartController

@property(nonatomic) DTBarChartStyle barChartStyle;

@property (nonatomic, readonly) NSArray<DTDimensionBarModel *> *levelLowestBarModels;

@property(nonatomic) NSString *(^dimensionBarChartControllerTouchBlock)(NSUInteger touchIndex);

- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat __attribute__((unavailable("DTDimensionVerticalBarChartController use -setItem replace")));

/**
 * 赋值，柱状图的所有值
 * @param dimensionModel 数据
 * @return 图表内容宽度是否超过了contentView
 */
- (BOOL)setItem:(DTDimensionModel *)dimensionModel;
@end
