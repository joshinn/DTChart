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

- (void)setMainData:(DTDimension2ListModel *)mainData secondData:(DTDimension2ListModel *)secondData;
@end
