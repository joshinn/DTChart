//
//  DTChartBaseComponent.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTColorManager.h"
#import "DTChartData.h"

@class DTChartBlockModel;

CG_INLINE CGFloat CGPointGetDistance(CGPoint point1, CGPoint point2) {
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);
    return sqrtf((fx * fx + fy * fy));
}


/**
 * 默认一个单元格的宽度15
 */
UIKIT_EXTERN CGFloat const DefaultCoordinateAxisCellWidth;


struct ChartEdgeInsets {
    NSUInteger left;
    NSUInteger top;
    NSUInteger right;
    NSUInteger bottom;
};
typedef struct ChartEdgeInsets ChartEdgeInsets;

CG_INLINE ChartEdgeInsets ChartEdgeInsetsMake(NSUInteger left, NSUInteger top, NSUInteger right, NSUInteger bottom) {
    ChartEdgeInsets insets;
    insets.left = left;
    insets.top = top;
    insets.right = right;
    insets.bottom = bottom;
    return insets;
}


typedef void(^MainAxisColorsCompletion)(NSArray<DTChartBlockModel *> *infos);

typedef void(^SecondAxisColorsCompletion)(NSArray<DTChartBlockModel *> *infos);

@interface DTChartBaseComponent : UIView

#pragma mark - ####### public property #######

/**
 * 坐标系单元格宽度，默认是15
 */
@property(nonatomic, readonly) CGFloat coordinateAxisCellWidth;
/**
 * 坐标轴距离边界的距离，决定了坐标轴标签文字的大小
 * @note 一般是左边和下边
 */
@property(nonatomic) ChartEdgeInsets coordinateAxisInsets;

/**
 * x轴标签数组
 */
@property(nonatomic, copy) NSArray<DTAxisLabelData *> *xAxisLabelDatas;
/**
 * y轴标签数组
 */
@property(nonatomic, copy) NSArray<DTAxisLabelData *> *yAxisLabelDatas;
/**
 * x轴label的文字颜色
 */
@property(nonatomic) UIColor *xAxisLabelColor;
/**
 * y轴label的文字颜色
 */
@property(nonatomic) UIColor *yAxisLabelColor;
/**
 * 是否显示出现动画，默认YES
 */
@property(nonatomic, getter=isShowAnimation) BOOL showAnimation;

/**
 * 显示坐标轴线，NO
 */
@property(nonatomic, getter=isShowCoordinateAxisLine) BOOL showCoordinateAxisLine;
/**
 * 显示坐标系表格线，默认NO
 */
@property(nonatomic, getter=isShowCoordinateAxisGrid) BOOL showCoordinateAxisGrid;
/**
 * 坐标系里的点、柱状体等是否可点击选择，默认NO
 */
@property(nonatomic, getter=isValueSelectable) BOOL valueSelectable;

/**
 * 坐标系值数据源
 * @attention 和multiData同时只能赋值一个
 */
@property(nonatomic) DTChartSingleData *singleData;
/**
 * 多组坐标系值数据源
 * @note 多个singleData
 * @attention 和singleData同时只能赋值一个
 */
@property(nonatomic, copy) NSArray<DTChartSingleData *> *multiData;

/**
 * 主轴颜色回调
 */
@property(nonatomic, copy) MainAxisColorsCompletion colorsCompletionBlock;
/**
 * 副轴颜色回调
 */
@property(nonatomic, copy) SecondAxisColorsCompletion secondAxisColorsCompletionBlock;

#pragma mark - ####### protect property #######

/**
 * 整个Chart宽度，以单元格为单位
 */
@property(nonatomic, readonly) NSUInteger xCount;
/**
 * 整个Chart高度，以单元格为单位
 */
@property(nonatomic, readonly) NSUInteger yCount;
/**
 * x轴长度，xCount去除左右边距的大小
 */
@property(nonatomic, readonly) NSUInteger xAxisCellCount;
/**
 * y轴长度，yCount去除上下边距的大小
 */
@property(nonatomic, readonly) NSUInteger yAxisCellCount;
/**
 * 坐标轴原点
 * @note xy轴坐标系，在左下角，默认
 * @note pie图坐标系在圆心
 */
@property(nonatomic, readonly) CGPoint originPoint;
/**
 * 坐标轴线
 */
@property(nonatomic, readonly) CAShapeLayer *coordinateAxisLine;
/**
 * 坐标轴内容view，坐标轴不在里面
 */
@property(nonatomic, readonly) UIView *contentView;
/**
 * 颜色管理
 */
@property(nonatomic) DTColorManager *colorManager;


#pragma mark - ####### method #######

- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount;

/**
 * 实例化
 * @param origin 就是frame的那个origin
 * @param cell 单元格宽度，默认是15
 * @param xCount 坐标系view宽度
 * @param yCount 坐标系view高度
 * @return  坐标系实例
 */
- (instancetype)initWithOrigin:(CGPoint)origin cellWidth:(CGFloat)cell xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount;

/**
 * 初始化一些变量
 */
- (void)initial __attribute__((objc_requires_super));

/**
 * 给multiData生成颜色
 * @param needInitial 颜色是否需要重置
 */
- (void)generateMultiDataColors:(BOOL)needInitial;

/**
 * 绘制x轴标签
 * @return 绘制是否成功
 * @attention 父类判断了x轴标签是否过少(0)
 * @attention 子类需要实现方法
 */
- (BOOL)drawXAxisLabels;

/**
 * 绘制y轴标签
 * @return 绘制是否成功
 * @attention 父类判断了y轴标签是否过少(0)
 * @attention 子类需要实现方法
 */
- (BOOL)drawYAxisLabels;

/**
 * 绘制坐标轴线
 */
- (void)drawAxisLine;

/**
 * 绘制坐标轴里的所有的值
 * @attention 包含绘制副轴
 * @attention 子类实现
 */
- (void)drawValues;

/**
 * 清除坐标轴label，和坐标内的柱状体
 * @note 子类实现
 */
- (void)clearChartContent;

/**
 * 绘制整个坐标系
 */
- (void)drawChart;

#pragma mark - 主轴相关

/**
 * 刷新主轴项
 * @param indexes    项的序号
 * @param animation 是否有动画
 */
- (void)reloadChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation;

/**
 * 插入新的主轴项
 * @param indexes 项的序号
 * @param animation 是否有动画
 * @attention 父类实现了插入项的颜色生成
 */
- (void)insertChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation __attribute__((objc_requires_super));


/**
 * 删除主轴项
 * @param indexes 项的序号
 * @param animation 是否有动画
 * @attention 父类实现了删除项从multiData里移除
 */
- (void)deleteChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation __attribute__((objc_requires_super));


#pragma mark - 副轴相关

/**
 * y轴副轴标签数组
 */
@property(nonatomic, copy) NSArray<DTAxisLabelData *> *ySecondAxisLabelDatas;
/**
 * 副轴坐标系值数据源
 * @attention 和secondMultiData同时只能赋值一个
 */
@property(nonatomic) DTChartSingleData *secondSingleData;
/**
 * 副轴多组坐标系值数据源
 * @note 多个secondSingleData
 * @attention 和secondSingleData同时只能赋值一个
 */
@property(nonatomic, copy) NSArray<DTChartSingleData *> *secondMultiData;

/**
 * 清除坐标系里的副轴轴标签和值线条
 */
- (void)clearSecondChartContent;
/**
 * 给secondMultiData生成颜色
 * @param needInitial 颜色是否需要重置
 */
- (void)generateSecondMultiDataColors:(BOOL)needInitial;

/**
 * 绘制y轴副轴
 * @return 绘制结果
 * @attention 父类判断了y轴标签是否过少(0)
 * @attention 子类需要实现方法
 */
- (BOOL)drawYSecondAxisLabels;

- (void)drawSecondValues;

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
 * @attention 父类实现了插入项的颜色生成
 */
- (void)insertChartSecondAxisItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation __attribute__((objc_requires_super));

/**
 * 删除副轴指定折线
 * @param indexes 要删除的副轴折线序号
 * @param animation 是否有动画
 * @attention 父类实现了删除项从multiData里移除
 */
- (void)deleteChartSecondAxisItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation __attribute__((objc_requires_super));
@end
