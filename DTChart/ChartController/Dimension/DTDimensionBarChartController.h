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
@class DTDimensionBarModel;

typedef void(^ControllerChartBarInfoBlock)(NSArray<DTDimensionBarModel *> *_Nullable listBarInfos, id _Nullable dimensionData);

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

/**
 * 是否drawChart前先遍历所有的数据，确定柱状体的颜色，默认NO
 * @note 2017-09-04 update: YES时，会自动修正左侧维度标题的宽度  NO时: 左侧维度标题的宽度为固定值
 */
@property(nonatomic) BOOL preProcessBarInfo;

/**
 * 要高亮的子柱状体对应的标题
 * @note 会使图表内所有对应该标题的柱状体高亮
 */
@property(nonatomic) NSString *_Nullable highlightTitle;

/**
 * 柱状体可以左右滑动触发事件
 */
@property(nonatomic) BOOL chartBarCanSwipe;

/**
 * 柱状体左右滑动回调
 * @param isLeft 滑动方向，YES:向左  NO:向右
 * @param title 滑动的柱状体最后一个维度名称
 * @param otherTitles 除了title之外，所有柱状体最后一个维度名称的集合
 */


@property(nonatomic, copy) NSString *_Nullable (^ _Nullable controllerTouchLabelBlock)(DTDimensionBarStyle chartStyle, NSUInteger row, DTDimension2Model *_Nullable data, NSUInteger index);

@property(nonatomic, copy) NSString *_Nullable (^ _Nullable controllerTouchBarBlock)(DTDimensionBarStyle chartStyle, NSUInteger row, DTDimension2Item *_Nullable touchData, NSArray<DTDimension2Item *> *_Nullable allSubData, id _Nullable dimensionData, id _Nullable measureData, BOOL isMainAxis);

@property(nonatomic, copy) ControllerChartBarInfoBlock _Nullable controllerBarInfoBlock;

/**
 * 柱状体维度标题开始长按回调
 * @param fakeView 长按产生的可以拖动的view
 * @param title 长按的维度标题
 * @param dimensionIndex 长按的维度序号
 * @return (l, r) 是否可以左右滑动 l:方向左，r:方向右，0:NO，1:YES
 */
@property(nonatomic, copy) CGPoint (^ _Nullable controllerLongPressBeginBlock)(UIView *_Nonnull fakeView, NSString *_Nullable title, NSUInteger dimensionIndex);

/**
 * 柱状体维度标题开始长按回调
 * @param fakeView 长按产生的可以拖动的view
 * @param isSwipe 是否产生滑动
 * @param isLeft 滑动方向，在isSwipe为YES时生效
 * @param title 长按的维度标题
 * @param dimensionIndex 长按的维度序号
 */
@property(nonatomic, copy) void (^ _Nullable controllerLongPressEndBlock)(UIView *_Nonnull fakeView, BOOL isSwipe, BOOL isLeft, NSString *_Nullable title, NSUInteger dimensionIndex);

- (void)setMainData:(DTDimension2ListModel *_Nonnull)mainData secondData:(DTDimension2ListModel *_Nullable)secondData;

@end
