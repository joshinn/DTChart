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

static NSString *const DateFormatterFull = @"YYYY-MM-DD HH:mm";
static NSString *const DateFormatterFullWithoutTime = @"YYYY-MM-DD";
static NSString *const DateFormatterYear = @"YYYY";
static NSString *const DateFormatterMonth = @"MM";
static NSString *const DateFormatterDay = @"DD";
static NSString *const DateFormatterTime = @"HH:mm";

@implementation DTAxisFormatter

+ (instancetype)axisFormatter {
    DTAxisFormatter *formatter = [[DTAxisFormatter alloc] init];
    return formatter;
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

#pragma mark - private method

- (NSString *)handleDate:(NSString *)dateString dateSubType:(DTAxisFormatterDateSubType)subType {
    NSMutableString *mutableString = [NSMutableString string];

    if ([dateString containsString:@"~"]) {
        [mutableString appendString:[dateString componentsSeparatedByString:@"~"].firstObject];
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

- (NSString *)getAxisLabelTitle:(NSString *)string orValue:(CGFloat)value format:(NSString *)format scale:(CGFloat)scale type:(DTAxisFormatterType)type dateSubType:(DTAxisFormatterDateSubType)dateSubType {
    if (type == DTAxisFormatterTypeText) {
        return string;
    } else if (type == DTAxisFormatterTypeNumber) {
        return [NSString stringWithFormat:format, value * scale];
    } else if (type == DTAxisFormatterTypeDate) {
        return [self handleDate:string dateSubType:dateSubType];
    }
    return string;
}

#pragma mark - public method

- (NSString *)getMainYAxisLabelTitle:(NSString *)string orValue:(CGFloat)value {
    return [self getAxisLabelTitle:string orValue:value format:self.mainYAxisFormat scale:self.mainYAxisScale type:self.mainYAxisType dateSubType:self.mainYAxisDateSubType];
}

- (NSString *)getSecondYAxisLabelTitle:(NSString *)string orValue:(CGFloat)value {
    return [self getAxisLabelTitle:string orValue:value format:self.secondYAxisFormat scale:self.secondYAxisScale type:self.secondYAxisType dateSubType:self.secondYAxisDateSubType];
}

- (NSString *)getXAxisLabelTitle:(NSString *)string orValue:(CGFloat)value {
    return [self getAxisLabelTitle:string orValue:value format:self.xAxisFormat scale:self.xAxisScale type:self.xAxisType dateSubType:self.xAxisDateSubType];
}


@end
