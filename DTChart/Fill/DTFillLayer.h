//
//  DTFillLayer.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTChartSingleData;

@interface DTFillLayer : CAShapeLayer

@property(nonatomic) CGPoint startPoint;
@property(nonatomic) CGPoint endPoint;
@property(nonatomic) UIBezierPath *borderPath;
@property(nonatomic) UIBezierPath *fillPath;
@property(nonatomic) DTChartSingleData *singleData;

@property(nonatomic, getter=isHighLighted) BOOL highLighted;
@property(nonatomic) UIColor *normalFillColor;
@property(nonatomic) UIColor *highlightedFillColor;

+ (instancetype)fillLayer;

- (void)draw;
@end
