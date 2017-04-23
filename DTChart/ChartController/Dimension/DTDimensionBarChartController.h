//
//  DTDimensionBarChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/19.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"

@class DTDimension2ListModel;

@interface DTDimensionBarChartController : DTChartController

@property(nonatomic, copy) NSString *_Nullable(^ _Nullable controllerTouchLabelBlock)(NSUInteger row, NSUInteger index);

@property(nonatomic, copy) NSString *_Nullable(^ _Nullable controllerTouchBarBlock)(NSUInteger row, BOOL isMainAxis);


- (void)setMainData:( DTDimension2ListModel * _Nonnull )mainData secondData:(DTDimension2ListModel * _Nullable)secondData;
@end
