//
//  DTChartData.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartData.h"

@implementation DTChartItemData

+ (instancetype)chartData {
    DTChartItemData *chartData = [[DTChartItemData alloc] init];
    return chartData;
}

@end


@implementation DTAxisLabelData

+ (instancetype)axisLabelData {
    DTAxisLabelData *labelData = [[DTAxisLabelData alloc] init];
    return labelData;
}

- (instancetype)initWithTitle:(NSString *)title value:(CGFloat)value {
    if (self = [super init]) {
        _title = title;
        _value = value;
    }
    return self;
}
@end