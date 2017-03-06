//
//  DTDimensionBar.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/3.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBar.h"
#import "DTDimensionModel.h"

@implementation DTDimensionBar

+ (instancetype)bar:(DTBarOrientation)orientation style:(DTBarBorderStyle)style {
    DTDimensionBar *bar = [[DTDimensionBar alloc] init];
    bar.barOrientation = orientation;
    bar.barBorderStyle = style;
    return bar;
}


@end
