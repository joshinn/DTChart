//
//  DTDimensionBarChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTBarChart.h"
#import "DTDimension2Model.h"

@class DTDimension2Model;
@class DTDimension2ListModel;
@class DTDimensionBarModel;

UIKIT_EXTERN CGFloat const DimensionLabelWidth;
UIKIT_EXTERN CGFloat const DimensionLabelGap;


@interface DTDimensionBarChart : DTBarChart

@property(nonatomic) DTDimensionBarStyle chartStyle;

/**
 * 是否drawChart前先遍历所有的数据，确定柱状体的颜色，默认NO
 */
@property(nonatomic) BOOL preProcessBarInfo;

@property(nonatomic) DTDimension2ListModel *mainData;
@property(nonatomic) DTDimension2ListModel *secondData;

/**
 * 第二个度量x轴标签数组
 */
@property(nonatomic, copy) NSArray<DTAxisLabelData *> *xSecondAxisLabelDatas;

@property(nonatomic) NSString *mainNotation;
@property(nonatomic) NSString *secondNotation;

@property(nonatomic, copy) NSString *(^touchLabelBlock)(DTDimensionBarStyle chartStyle, NSUInteger row, DTDimension2Model *data, NSUInteger index);

@property(nonatomic, copy) NSString *(^touchBarBlock)(DTDimensionBarStyle chartStyle, NSUInteger row, DTDimension2Item *touchData, NSArray<DTDimension2Item *> *allSubData, BOOL isMainAxis);

@property(nonatomic, copy) void (^itemColorBlock)(NSArray<DTDimensionBarModel *> *barModels);

- (void)drawChart __attribute__((unavailable("use drawChart: replace")));

- (void)drawChart:(NSArray<DTDimensionBarModel *> *)itemBarInfos;

@end
