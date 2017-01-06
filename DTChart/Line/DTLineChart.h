//
//  DTLineChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"

@class DTLineChartSingleData;

/**
 * 触摸手势回调
 * @param lineIndex 折线的序号(哪一组数据)
 * @param pointIndex 折线中的点的序号
 * @param isMainAxis 是否是主轴
 */
typedef void(^DTLineChartTouchBlock)(NSUInteger lineIndex, NSUInteger pointIndex, BOOL isMainAxis);

typedef void(^SecondAxisColorsCompletionBlock)(NSArray<UIColor *> *colors);



/**
 * 折线图
 *
 * @attention DTChartSingleData 需要使用子类 DTLineChartSingleData，扩展了折线点的形状
 */
@interface DTLineChart : DTChartBaseComponent

/**
 * 手势选择回调
 */
@property(nonatomic, copy) DTLineChartTouchBlock lineChartTouchBlock;
/**
 * x轴标签是否与格子对齐，默认是NO
 */
@property(nonatomic) BOOL xAxisAlignGrid;


#pragma mark - 副轴相关

/**
 * y轴副轴标签数组
 */
@property(nonatomic, copy) NSArray<DTAxisLabelData *> *ySecondAxisLabelDatas;
/**
 * 副轴坐标系值数据源
 * @attention 和secondMultiData同时只能赋值一个
 */
@property(nonatomic) DTLineChartSingleData *secondSingleData;
/**
 * 副轴多组坐标系值数据源
 * @note 多个secondSingleData
 * @attention 和secondSingleData同时只能赋值一个
 */
@property(nonatomic, copy) NSArray<DTLineChartSingleData *> *secondMultiData;

@property(nonatomic, copy) SecondAxisColorsCompletionBlock secondAxisColorsCompletionBlock;

/**
 * 刷新副轴有关的所有(y轴、折线)
 */
- (void)drawSecondChart;

/**
 * 刷新副轴指定折线
 * @param indexes 要刷新的副轴折线序号
 * @param animation 是否有动画
 */
- (void)reloadChartSecondAxisItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation;

/**
 * 插入副轴折线
 * @param indexes 要插入的副轴折线序号
 * @param animation 是否有动画
 */
- (void)insertChartSecondAxisItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation;

/**
 * 删除副轴指定折线
 * @param indexes 要删除的副轴折线序号
 * @param animation 是否有动画
 */
- (void)deleteChartSecondAxisItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation;
@end
