//
//  DTDimensionBarChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/19.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"
#import "DTDimension2Model.h"

@class DTDimension2ListModel;

@interface DTDimensionBarChartController : DTChartController

@property(nonatomic) DTDimensionBarStyle chartStyle;

/**
 * 所有维度数据，用于触摸提示用
 * @note 数据格式自定义
 */
@property(nonatomic) NSArray *_Nullable dimensionDatas;

/**
 * 第一度量数据，用于触摸提示用
 * @note 数据格式自定义
 */
@property(nonatomic) id _Nullable mainMeasureData;

/**
 * 第二度量数据，用于触摸提示用
 * @note 数据格式自定义
 */
@property(nonatomic) id _Nullable secondMeasureData;


@property(nonatomic, copy) NSString *_Nullable (^ _Nullable controllerTouchLabelBlock)(DTDimensionBarStyle chartStyle, NSUInteger row, DTDimension2Model *_Nullable data, NSUInteger index);

@property(nonatomic, copy) NSString *_Nullable (^ _Nullable controllerTouchBarBlock)(DTDimensionBarStyle chartStyle, NSUInteger row, DTDimension2Item *_Nullable touchData, NSArray<DTDimension2Item *> *_Nullable allSubData, id _Nullable dimensionData, id _Nullable measureData, BOOL isMainAxis);

- (void)setMainData:(DTDimension2ListModel *_Nonnull)mainData secondData:(DTDimension2ListModel *_Nullable)secondData;

@end
