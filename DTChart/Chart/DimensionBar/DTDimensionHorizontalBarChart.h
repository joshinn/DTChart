//
//  DTDimensionHorizontalBarChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/28.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTBarChart.h"

@class DTDimensionModel;
@class DTDimensionReturnModel;
@class DTDimensionBarModel;

@interface DTDimensionHorizontalBarChart : DTBarChart

/**
 * 柱状图的数据model
 */
@property(nonatomic) DTDimensionModel *dimensionModel;

/**
 * 记录ptName不一样的层级最低的柱状体，同时生成对应的颜色
 */
@property(nonatomic) NSMutableArray<DTDimensionBarModel *> *levelLowestBarModels;
/**
 * y最大值
 */
@property(nonatomic) CGFloat maxX;
/**
 * y轴第一个柱状体偏移量，默认0，让所有柱状体居中时使用
 */
@property(nonatomic) CGFloat yOffset;

/**
 * 不绘制柱状体等view，计算该柱状图大小，层级等信息
 * @param data 数据
 * @return 返回值包括x轴层级和宽度
 */
- (DTDimensionReturnModel *)calculate:(DTDimensionModel *)data;

@end
