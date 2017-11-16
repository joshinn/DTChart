//
//  DTAxisFormatter.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/16.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTAxisFormatter.h"


@interface DTAxisFormatter ()

@property(nonatomic) NSDateFormatter *dateFormatter;

@end

static NSString *const DateFormatterFull = @"yyyy-MM-dd HH:mm";
static NSString *const DateFormatterFullWithoutTime = @"yyyy-MM-dd";
static NSString *const DateFormatterYear = @"yyyy";
static NSString *const DateFormatterMonth = @"MM";
static NSString *const DateFormatterDay = @"dd";
static NSString *const DateFormatterTime = @"HH:mm";

@implementation DTAxisFormatter

+ (instancetype)axisFormatter {
    DTAxisFormatter *formatter = [[DTAxisFormatter alloc] init];
    return formatter;
}

+ (instancetype)axisFormatterExClone:(DTAxisFormatter *)origin {
    DTAxisFormatter *axisFormatter = [[DTAxisFormatter alloc] init];

    axisFormatter.mainYAxisType = origin.mainYAxisType;
    axisFormatter.mainYAxisDateSubType = origin.mainYAxisDateSubType;
    axisFormatter.mainYAxisFormat = origin.mainYAxisFormat;
    axisFormatter.mainYAxisUnit = origin.mainYAxisUnit;
    axisFormatter.mainYAxisNotation = origin.mainYAxisNotation;
    axisFormatter.mainYAxisScale = origin.mainYAxisScale;

    axisFormatter.secondYAxisType = origin.secondYAxisType;
    axisFormatter.secondYAxisDateSubType = origin.secondYAxisDateSubType;
    axisFormatter.secondYAxisFormat = origin.secondYAxisFormat;
    axisFormatter.secondYAxisUnit = origin.secondYAxisUnit;
    axisFormatter.secondYAxisNotation = origin.secondYAxisNotation;
    axisFormatter.secondYAxisScale = origin.secondYAxisScale;

    axisFormatter.xAxisType = origin.xAxisType;
    axisFormatter.xAxisDateSubType = origin.xAxisDateSubType;
    axisFormatter.xAxisFormat = origin.xAxisFormat;
    axisFormatter.xAxisNotation = origin.xAxisNotation;
    axisFormatter.xAxisUnit = origin.xAxisUnit;
    axisFormatter.xAxisScale = origin.xAxisScale;

    return axisFormatter;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}


- (instancetype)init {
    if (self = [super init]) {
        _mainYAxisScale = 1;
        _secondYAxisScale = 1;
        _xAxisScale = 1;
        _mainYAxisNotation = 0;
        _secondYAxisNotation = 0;
    }
    return self;
}

- (NSString *)mainYAxisFormat {
    if (!_mainYAxisFormat) {
        _mainYAxisFormat = @"%.0f";
    }
    return _mainYAxisFormat;
}

- (NSString *)secondYAxisFormat {
    if (!_secondYAxisFormat) {
        _secondYAxisFormat = @"%.0f";
    }
    return _secondYAxisFormat;
}

- (NSString *)xAxisFormat {
    if (!_xAxisFormat) {
        _xAxisFormat = @"%.0f";
    }
    return _xAxisFormat;
}


#pragma mark - private method

- (NSString *)handleDate:(NSString *)dateString dateSubType:(DTAxisFormatterDateSubType)subType {
    NSMutableString *mutableString = [NSMutableString string];

    if ([dateString containsString:@"~"]) {
        [mutableString appendString:[dateString componentsSeparatedByString:@"~"].firstObject];
    } else {
        [mutableString appendString:dateString];
    }

    if (mutableString.length == 10) {
        self.dateFormatter.dateFormat = DateFormatterFullWithoutTime;
    } else if (mutableString.length == 16) {
        self.dateFormatter.dateFormat = DateFormatterFull;
    }

    NSDate *date = [self.dateFormatter dateFromString:mutableString];

    if (!date) {
        return mutableString;
    }

    [mutableString deleteCharactersInRange:NSMakeRange(0, mutableString.length)];

    if (subType & DTAxisFormatterDateSubTypeYear) {
        self.dateFormatter.dateFormat = DateFormatterYear;
        [mutableString appendString:[self.dateFormatter stringFromDate:date]];
    }
    if (subType & DTAxisFormatterDateSubTypeMonth) {
        if (mutableString.length > 0) {
            [mutableString appendString:@"/"];
        }
        self.dateFormatter.dateFormat = DateFormatterMonth;
        [mutableString appendString:[self.dateFormatter stringFromDate:date]];
    }
    if (subType & DTAxisFormatterDateSubTypeDay) {
        if (mutableString.length > 0) {
            [mutableString appendString:@"/"];
        }
        self.dateFormatter.dateFormat = DateFormatterDay;
        [mutableString appendString:[self.dateFormatter stringFromDate:date]];
    }
    if (subType & DTAxisFormatterDateSubTypeTime) {
        if (mutableString.length > 0) {
            [mutableString appendString:@" "];
        }
        self.dateFormatter.dateFormat = DateFormatterTime;
        [mutableString appendString:[self.dateFormatter stringFromDate:date]];
    }

    return mutableString;
}

- (NSString *)handleTypeSecond:(CGFloat)value {
    NSMutableString *mutableString = [NSMutableString string];

    if (value > 3600) {
        NSUInteger hour = (NSUInteger) (value / 3600);
        value -= hour * 3600;
        [mutableString appendString:[NSString stringWithFormat:@"%@h", @(hour)]];
    }

    if (value > 60) {
        NSUInteger min = (NSUInteger) (value / 60);
        value -= min * 60;
        [mutableString appendString:[NSString stringWithFormat:@"%@min", @(min)]];
    }

    if (value > 0) {
        [mutableString appendString:[NSString stringWithFormat:@"%@s", @(value)]];
    }

    return mutableString;
}

#pragma mark - public method


- (NSString *)getAxisLabelTitle:(NSString *)string orValue:(CGFloat)value format:(NSString *)format scale:(CGFloat)scale type:(DTAxisFormatterType)type dateSubType:(DTAxisFormatterDateSubType)dateSubType {
    if (type == DTAxisFormatterTypeText) {
        return string;
    } else if (type == DTAxisFormatterTypeNumber) {
        if (!format) {
            format = @"%.0f";
        }
        return [NSString stringWithFormat:format, value * scale];
    } else if (type == DTAxisFormatterTypeDate) {
        return [self handleDate:string dateSubType:dateSubType];
    } else if (type == DTAxisFormatterTypeSecond) {
        return [self handleTypeSecond:value];
    }
    return string;
}

- (NSString *)getMainYAxisLabelTitle:(NSString *)string orValue:(CGFloat)value {
    return [self getAxisLabelTitle:string orValue:value format:self.mainYAxisFormat scale:self.mainYAxisScale type:self.mainYAxisType dateSubType:self.mainYAxisDateSubType];
}

- (NSString *)getSecondYAxisLabelTitle:(NSString *)string orValue:(CGFloat)value {
    return [self getAxisLabelTitle:string orValue:value format:self.secondYAxisFormat scale:self.secondYAxisScale type:self.secondYAxisType dateSubType:self.secondYAxisDateSubType];
}

- (NSString *)getXAxisLabelTitle:(NSString *)string orValue:(CGFloat)value {
    return [self getAxisLabelTitle:string orValue:value format:self.xAxisFormat scale:self.xAxisScale type:self.xAxisType dateSubType:self.xAxisDateSubType];
}


- (NSString *)getNotationLabelText:(BOOL)isMain {
    NSInteger notation = isMain ? self.mainYAxisNotation : self.secondYAxisNotation;
    NSString *unit = isMain ? self.mainYAxisUnit : self.secondYAxisUnit;
    if (!unit) {
        unit = @"";
    }

    if (notation > 0) {
        NSMutableString *mutableString = [NSMutableString string];
        [mutableString appendString:@"×10"];

        NSString *notationStr = [NSString stringWithFormat:@"%@", @(notation)];
        for (NSUInteger idx = 0; idx < notationStr.length; ++idx) {
            NSString *sub = [notationStr substringWithRange:NSMakeRange(idx, 1)];
            NSInteger index = sub.integerValue;
            NSString *p = Powers[(NSUInteger) index];
            [mutableString appendString:p];
        }

        [mutableString appendString:unit];

        return mutableString;
    } else {
        return unit;
    }
}

@end
