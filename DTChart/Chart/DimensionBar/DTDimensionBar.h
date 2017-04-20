//
//  DTDimensionBar.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/3.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTBar.h"

@class DTDimensionModel;
@class DTDimensionBar;

@interface DTDimensionBar : DTBar

@property(nonatomic) NSArray<DTDimensionModel *> *dimensionModels;

@end
