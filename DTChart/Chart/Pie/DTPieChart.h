//
//  DTPieChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/26.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"

typedef NS_ENUM(NSUInteger, DTPieChartTouchMode) {
    DTPieChartTouchModeOneAfterOne = 0,     ///< 点一下选择，再点一下取消选择
    DTPieChartTouchModeOneComplete = 1,     ///< 按住选择，抬起取消选择
};

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

typedef NSString *(^DTPieChartTouchOneCompleteBlock)(NSUInteger partIndex, NSString *partTitle, CGFloat partValue, CGFloat sum);

@interface DTPieChart : DTChartBaseComponent

@property(nonatomic, copy) DTPieChartTouch pieChartTouchBlock;
@property(nonatomic, copy) DTPieChartCancelTouch pieChartTouchCancelBlock;

@property(nonatomic, copy) DTPieChartTouchOneCompleteBlock pieChartTouchOneCompleteBlock;

/**
 * pie圆形图的半径
 */
@property(nonatomic) CGFloat pieRadius;
/**
 * 选择后弧线的宽度，以单元格为单位，默认1
 */
@property(nonatomic) CGFloat selectBorderWidth;

/**
 * 存储pie图每个组成部分的百分比
 */
@property(nonatomic, readonly) NSMutableArray<NSNumber *> *percentages;
/**
 * 存储pie图每个组成部分的数值
 */
@property(nonatomic, readonly) NSMutableArray<NSNumber *> *singleTotal;

@property(nonatomic, copy) ItemsColorsCompletion itemsColorsCompletion;

/**
 * 要高亮的部分对应的标题
 * @note 会使图表内所有对应该标题的部分高亮
 */
@property(nonatomic) NSString *highlightTitle;

@property(nonatomic) DTPieChartTouchMode touchMode;

/**
 * 更新chart的frame
 * @param origin 等同frame.origin
 * @param xCount x轴长度
 * @param yCount y轴长度
 */
- (void)updateFrame:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount;


/**
 * pie图里的数据和图形消失
 * @param animation 动画
 */
- (void)dismissChart:(BOOL)animation;
@end
