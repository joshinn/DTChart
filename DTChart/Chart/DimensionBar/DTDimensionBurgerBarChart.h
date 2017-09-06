//
//  DTDimensionBurgerBarChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/9.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTBarChart.h"

@class DTDimensionModel;

@interface DTDimensionBurgerBarChart : DTBarChart

/**
 * 柱状图的数据model
 */
@property(nonatomic) DTDimensionModel *dimensionModel;
/**
 * x轴第一个柱状体偏移量，默认0，让所有柱状体居中时使用
 */
@property(nonatomic) CGFloat xOffset;
/**
 * 柱状体之间的距离，默认2个单元格
 */
@property(nonatomic) CGFloat barGap;

@property(nonatomic, copy) NSString *(^touchSubBarBlock)(NSArray<DTDimensionModel *> *allSubData, DTDimensionModel *touchData, NSUInteger dimensionIndex);

@property(nonatomic, copy) void (^allSubBarInfoBlock)(NSArray<NSArray<DTDimensionModel *> *> *allSubData, NSArray<NSArray<UIColor *> *> *barAllColor, NSArray<DTDimensionModel *> *touchDatas);

/**
 * 设置高亮的柱状体
 * @param highlightTitle 柱状体对应的标题
 * @param dimensionIndex 该柱状体所在的维度序号
 */
- (void)setHighlightTitle:(NSString *)highlightTitle dimensionIndex:(NSUInteger)dimensionIndex;

@end
