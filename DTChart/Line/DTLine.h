//
//  DTLine.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/14.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTChartItemData;

typedef NS_ENUM(NSInteger, DTLinePointType) {
    DTLinePointTypeCircle,      // 圆圈
    DTLinePointTypedTriangle,   // 三角形
    DTLinePointTypedSquare,     // 正方形
    DTLinePointTypedRound       // 圆形
};

@interface DTLine : CAShapeLayer

@property(nonatomic) DTLinePointType pointType;
@property(nonatomic) UIColor *lineColor;
@property(nonatomic) UIBezierPath *linePath;
@property(nonatomic, weak) NSArray<DTChartItemData *> *values;


+ (instancetype)line:(DTLinePointType)pointType;

- (void)startAppearAnimation;
/**
 * 绘制最大最小值点
 */
- (void)drawEdgePoint;

- (void)removeEdgePoint;
@end
