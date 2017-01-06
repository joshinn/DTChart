//
//  DTTableAxisLabelData.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/6.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTTableAxisLabelData.h"

@implementation DTTableAxisLabelData

- (instancetype)initWithTitle:(NSString *)title value:(CGFloat)value {
    if (self = [super initWithTitle:title value:value]) {
        _showOrder = YES;
        _ascending = YES;
    }
    return self;
}


@end
