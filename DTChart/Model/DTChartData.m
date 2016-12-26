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

- (void)setItemValues:(NSArray<DTChartItemData *> *)itemValues {
    _itemValues = itemValues;

    DTChartItemData *minData = itemValues.firstObject;
    DTChartItemData *maxData = itemValues.firstObject;
    NSUInteger minIndex = 0;
    NSUInteger maxIndex = 0;

    for(NSUInteger i = 0; i < itemValues.count; ++i){
        DTChartItemData *data = itemValues[i];

        if (data.itemValue.y >= maxData.itemValue.y) {
            maxData = data;
            maxIndex = i;
        }

        if (data.itemValue.y < minData.itemValue.y) {
            minData = data;
            minIndex = i;
        }
    }

    self.maxValueIndex = maxIndex;
    self.minValueIndex = minIndex;


}

- (CGFloat)lineWidth {
    if (_lineWidth == 0) {
        _lineWidth = 2;
    }
    return _lineWidth;
}

- (void)setMaxValueIndex:(NSUInteger)maxValueIndex {
    _maxValueIndex = maxValueIndex;
}

- (void)setMinValueIndex:(NSUInteger)minValueIndex {
    _minValueIndex = minValueIndex;
}

@end

@implementation DTAxisLabelData



- (instancetype)initWithTitle:(NSString *)title value:(CGFloat)value {
    if (self = [super init]) {
        _title = title;
        _value = value;
    }
    return self;
}
@end