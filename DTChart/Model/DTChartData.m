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


@implementation DTChartSingleData

+ (instancetype)singleData {
    DTChartSingleData *data = [DTChartSingleData singleData:nil];

    return data;
}

+ (instancetype)singleData:(NSArray<DTChartItemData *> *)values {
    DTChartSingleData *data = [[DTChartSingleData alloc] init];
    data.itemValues = values;
    data.lineWidth = 2;
    return data;
}

- (CGFloat)lineWidth {
    if (_lineWidth == 0) {
        _lineWidth = 2;
    }
    return _lineWidth;
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