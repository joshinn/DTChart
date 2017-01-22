//
//  DTPieChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/26.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"

/**
 * 点击回调
 * @param index 点击的pie图成份序号
 */
typedef void(^DTPieChartTouch)(NSUInteger index);
/**
 * 取消点击
 * @param index 点击的pie图成份序号
 */
typedef void(^DTPieChartCancelTouch)(NSUInteger index);

/**
 * drawSingleDataIndex > - 1时，绘制单独一组数据时，itemValues所对应的颜色信息回调
 * @note seriesId 对应 ptName;
 */
typedef void(^ItemsColorsCompletion)(NSArray<DTChartBlockModel *> *infos);

@interface DTPieChart : DTChartBaseComponent

@property(nonatomic, copy) DTPieChartTouch pieChartTouchBlock;
@property(nonatomic, copy) DTPieChartCancelTouch pieChartTouchCancelBlock;

/**
 * 指定绘制multiData里的单独某个数据
 * @attention -1表示绘制全部，默认
 * @attention 范围：[-1, multiData.count)
 */
@property(nonatomic) NSInteger drawSingleDataIndex;

/**
 * pie圆形图的半径
 */
@property (nonatomic) CGFloat pieRadius;
/**
 * 选择后弧线的宽度，以单元格为单位，默认1
 */
@property (nonatomic) CGFloat selectBorderWidth;

/**
 * 存储pie图每个组成部分的百分比
 */
@property(nonatomic, readonly) NSMutableArray<NSNumber *> *percentages;
/**
 * 存储pie图每个组成部分的数值
 */
@property(nonatomic, readonly) NSMutableArray<NSNumber *> *singleTotal;

@property (nonatomic, copy) ItemsColorsCompletion itemsColorsCompletion;

/**
 * 更新原点位置
 * @param xOffset 距离contendView中心的x偏移，以单元格为单元，负为左偏，正为右偏
 * @param yOffset 距离contendView中心的y偏移，以单元格为单元，负为左偏，正为右偏
 */
- (void)updateOrigin:(CGFloat)xOffset yOffset:(CGFloat)yOffset;

/**
 * pie图里的数据和图形消失
 * @param animation 动画
 */
- (void)dismissChart:(BOOL)animation;
@end
