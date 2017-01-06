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

- (NSString *)description {
    return [NSString stringWithFormat:@"{ itemValue = %@,\n Position = %@ }",
                                      NSStringFromChartItemValue(self.itemValue),
                                      NSStringFromCGPoint(self.position)];
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
    data.lineWidth = 5;
    return data;
}

- (void)setItemValues:(NSArray<DTChartItemData *> *)itemValues {
    _itemValues = itemValues;

    DTChartItemData *minData = itemValues.firstObject;
    DTChartItemData *maxData = itemValues.firstObject;
    NSUInteger minIndex = 0;
    NSUInteger maxIndex = 0;

    for (NSUInteger i = 0; i < itemValues.count; ++i) {
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

- (NSString *)description {
    return [NSString stringWithFormat:@"{ itemValues = %@,\n maxValueIndex = %@,\n minValueIndex = %@,\n color = %@,\n secondColor = %@,\n lineWidth = %@ }",
                                      self.itemValues,
                                      @(self.maxValueIndex),
                                      @(self.minValueIndex),
                                      self.color,
                                      self.secondColor,
                                      @(self.lineWidth)];
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

- (NSString *)description {
    return [NSString stringWithFormat:@"{ title = %@,\n value = %@,\n axisPosition = %@,\n hidden = %@ }",
                                      self.title,
                                      @(self.value),
                                      @(self.axisPosition),
                                      self.hidden ? @"YES" : @"NO"];
}
@end


@implementation DTTableAxisLabelData

- (instancetype)initWithTitle:(NSString *)title value:(CGFloat)value {
    if (self = [super initWithTitle:title value:value]) {
        _showOrder = YES;
        _ascending = YES;
    }
    return self;
}

@end