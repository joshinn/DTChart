//
//  DTLine.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/14.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTLineChartSingleData.h"


@interface DTLine : CAShapeLayer

@property(nonatomic) DTLinePointType pointType;
@property(nonatomic) UIColor *lineColor;
@property(nonatomic) UIBezierPath *linePath;
@property(nonatomic) DTChartSingleData *singleData;


+ (instancetype)line:(DTLinePointType)pointType;

- (void)startAppearAnimation;

- (void)startPathUpdateAnimation:(UIBezierPath *)updatePath;

- (void)startDisappearAnimation;

/**
 * 绘制最大最小值点
 * @param delay 延迟
 */
- (void)drawEdgePoint:(NSTimeInterval)delay;

- (void)removeEdgePoint;

@end
