//
//  DTMeasureDimensionBurgerBarChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/9.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTBarChart.h"

@class DTDimensionModel;
@class DTDimensionBarModel;
@class DTDimensionBar;
@class DTDimensionHeapBar;

@interface DTMeasureDimensionBurgerBarChart : DTBarChart

/**
 * 第二个度量x轴标签数组
 */
@property(nonatomic, copy) NSArray<DTAxisLabelData *> *xSecondAxisLabelDatas;
/**
 * 第一个度量柱状图的数据model
 */
@property(nonatomic) DTDimensionModel *mainDimensionModel;
/**
 * 第二个度量柱状图的数据model
 */
@property(nonatomic) DTDimensionModel *secondDimensionModel;

/**
 * 记录ptName不一样的层级最低的柱状体，同时生成对应的颜色
 */
@property(nonatomic) NSMutableArray<DTDimensionBarModel *> *levelLowestBarModels;
/**
 * 第一度量，x轴最大值
 */
@property(nonatomic) CGFloat mainAxisMaxX;
/**
 * 第二度量，x轴最大值
 */
@property(nonatomic) CGFloat secondAxisMaxX;

/**
 * y轴第一个柱状体偏移量，默认0，让所有柱状体居中时使用
 */
@property(nonatomic) CGFloat yOffset;
/**
 * 柱状体之间的距离，默认2个单元格
 */
@property(nonatomic) CGFloat barGap;

/**
 * 第二度量里，存储所有柱状体
 */
@property(nonatomic) NSMutableArray<DTDimensionHeapBar *> *secondChartBars;

@property(nonatomic, copy) NSString *(^touchMainSubBarBlock)(NSArray<DTDimensionModel *> *allSubData, DTDimensionModel *touchData, NSUInteger dimensionIndex);
@property(nonatomic, copy) void (^mainSubBarInfoBlock)(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, NSUInteger dimensionIndex);

@property(nonatomic, copy) NSString *(^touchSecondSubBarBlock)(NSArray<DTDimensionModel *> *allSubData, DTDimensionModel *touchData, NSUInteger dimensionIndex);
@property(nonatomic, copy) void (^secondSubBarInfoBlock)(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, NSUInteger dimensionIndex);

/**
 * 设置高亮的柱状体
 * @param highlightTitle 柱状体对应的标题
 * @param dimensionIndex 该柱状体所在的维度序号
 */
- (void)setHighlightTitle:(NSString *)highlightTitle dimensionIndex:(NSUInteger)dimensionIndex;
@end
