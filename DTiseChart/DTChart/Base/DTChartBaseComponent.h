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

@interface DTChartBaseComponent : UIView
/**
 * 表格内容view，坐标轴不在里面
 */
@property (nonatomic) UIView *contentView;
/**
 * 坐标轴原点
 */
@property(nonatomic) CGPoint originPoint;

@property (nonatomic) CGFloat coordinateAxisCellWidth;
/**
 * 坐标轴距离边界的距离，决定了坐标轴标签文字的大小
 * 一般是左边和下边
 */
@property(nonatomic) UIEdgeInsets coordinateAxisInsets;
/**
 * x轴标签数组
 */
@property(nonatomic, copy) NSArray<DTAxisLabelData *> *xAxisLabelDatas;
/**
 * y轴标签数组
 */
@property(nonatomic, copy) NSArray<DTAxisLabelData *> *yAxisLabelDatas;
/**
 * 坐标轴线
 */
@property(nonatomic) CAShapeLayer *coordinateAxisLine;
/**
 * 显示坐标轴，默认YES
 */
@property(nonatomic) BOOL showCoordinateAxis;
/**
 * 显示坐标轴线，默认YES
 */
@property(nonatomic) BOOL showCoordinateAxisLine;

@property(nonatomic, copy) NSArray<DTChartItemData *> *values;

@property(nonatomic) CGFloat xAxisMaxValue;
@property(nonatomic) CGFloat yAxisMaxValue;

@property(nonatomic) CGFloat xAxisOriginValue;
@property(nonatomic) CGFloat yAxisOriginValue;
/**
 * x轴长度
 */
@property (nonatomic) CGFloat xAxisLength;
/**
 * y轴长度
 */
@property (nonatomic) CGFloat yAxisLength;
/**
 * x轴每个区间长度
 */
@property (nonatomic) CGFloat xAxisSectionLength;
/**
 * y轴长度每个区间长度
 */
@property (nonatomic) CGFloat yAxisSectionLength;

- (void)initial;

- (void)drawChart;

@end
