//
//  DTFillLayer.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTFillLayer : CAShapeLayer

@property(nonatomic) CGPoint startPoint;
@property(nonatomic) CGPoint endPoint;
@property(nonatomic) UIBezierPath *borderPath;
@property(nonatomic) UIBezierPath *fillPath;

+ (instancetype)fillLayer;

- (void)draw;
@end
