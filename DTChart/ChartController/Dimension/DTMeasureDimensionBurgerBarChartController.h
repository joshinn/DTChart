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

/**
 * 所有维度数据，用于触摸提示用
 * @note 数据格式自定义
 */
@property(nonatomic) NSArray *dimensionDatas;

/**
 * 第一度量数据，用于触摸提示用
 * @note 数据格式自定义
 */
@property(nonatomic) id mainMeasureData;

/**
 * 第二度量数据，用于触摸提示用
 * @note 数据格式自定义
 */
@property(nonatomic) id secondMeasureData;

@property(nonatomic, copy) NSString *(^touchBurgerMainSubBarBlock)(NSArray<DTDimensionModel *> *allSubData, DTDimensionModel *touchData, id dimensionData, id measureData);
@property(nonatomic, copy) void (^burgerMainSubBarInfoBlock)(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, id dimensionData, NSUInteger dimensionIndex);

@property(nonatomic, copy) NSString *(^touchBurgerSecondSubBarBlock)(NSArray<DTDimensionModel *> *allSubData, DTDimensionModel *touchData, id dimensionData, id measureData);
@property(nonatomic, copy) void (^burgerSecondSubBarInfoBlock)(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, id dimensionData, NSUInteger dimensionIndex);

- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat __attribute__((unavailable("DTMeasureDimensionHorizontalBarChartController use -setMainItem:secondItem: replace")));

- (void)setMainItem:(DTDimensionModel *)mainItem secondItem:(DTDimensionModel *)secondItem;

/**
 * 设置高亮的柱状体
 * @param highlightTitle 柱状体对应的标题
 * @param dimensionIndex 该柱状体所在的维度序号
 */
- (void)setHighlightTitle:(NSString *)highlightTitle dimensionIndex:(NSUInteger)dimensionIndex;

@end
