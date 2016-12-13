//
//  DTChartBaseComponent.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTAxisLabelData;
@class DTChartItemData;

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


@interface DTChartBaseComponent : UIView {

}

#pragma mark - ####### public property #######

/**
 * 坐标系单元格宽度，默认是15
 */
@property(nonatomic, readonly) CGFloat coordinateAxisCellWidth;
/**
 * 坐标轴距离边界的距离，决定了坐标轴标签文字的大小
 * 一般是左边和下边
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
 * 显示坐标轴，默认YES
 */
@property(nonatomic, getter=isShowCoordinateAxis) BOOL showCoordinateAxis;
/**
 * 显示坐标轴线，默认YES
 */
@property(nonatomic, getter=isShowCoordinateAxisLine) BOOL showCoordinateAxisLine;
/**
 * 显示坐标系表格线，默认NO
 */
@property(nonatomic, getter=isShowCoordinateAxisGrid) BOOL showCoordinateAxisGrid;
/**
 * 坐标轴值数据源
 */
@property(nonatomic, copy) NSArray<DTChartItemData *> *values;


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
 * 绘制整个坐标系
 */
- (void)drawChart;

@end
