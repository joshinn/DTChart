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

@property(nonatomic, copy) NSString *(^controllerTouchLabelBlock)(NSUInteger row, NSUInteger index);

@property(nonatomic, copy) NSString *(^controllerTouchBarBlock)(NSUInteger row, BOOL isMainAxis);


- (void)setMainData:(nonnull DTDimension2ListModel *)mainData secondData:(nullable DTDimension2ListModel *)secondData;
@end
