//
//  DTDimensionBurgerLineModel.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/9.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTDimensionBurgerLineModel : NSObject

@property(nonatomic) UIBezierPath *upperPath;
@property(nonatomic) UIBezierPath *lowerPath;

- (void)show:(CALayer *)superLayer;

- (void)hide;

@end
