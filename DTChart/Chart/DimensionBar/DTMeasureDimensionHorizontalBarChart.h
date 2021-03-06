//
//  DTMeasureDimensionHorizontalBarChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/1.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTBarChart.h"

@class DTDimensionModel;
@class DTDimensionReturnModel;
@class DTDimensionBarModel;
@class DTDimensionBar;

@interface DTMeasureDimensionHorizontalBarChart : DTBarChart

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
 * 第二度量里，存储所有柱状体
 */
@property(nonatomic) NSMutableArray<DTDimensionBar *> *secondChartBars;

/**
 * 不绘制柱状体等view，计算第一度量，该柱状图大小，层级等信息
 * @param data 数据
 * @return 返回值包括x轴层级和宽度
 */
- (DTDimensionReturnModel *)calculateMain:(DTDimensionModel *)data;

/**
 * 不绘制柱状体等view，计算第二度量，该柱状图大小，层级等信息
 * @param data 数据
 * @return 返回值包括x轴层级和宽度
 */
- (DTDimensionReturnModel *)calculateSecond:(DTDimensionModel *)data;

- (void)drawChart:(DTDimensionReturnModel *)returnModel;
@end
