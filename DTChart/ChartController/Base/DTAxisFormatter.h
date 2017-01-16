//  DTAxisFormatterType
//  DTAxisFormatter.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/16.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

typedef NS_ENUM(NSInteger, DTAxisFormatterType) {
    DTAxisFormatterTypeText = 0,    // 文字
    DTAxisFormatterTypeNumber = 1,  // 数值
    DTAxisFormatterTypeDate = 2,    // 日期
};

typedef NS_ENUM(NSInteger, DTAxisFormatterDateSubType) {
    DTAxisFormatterDateSubTypeYear = 1 << 0,
    DTAxisFormatterDateSubTypeMonth = 1 << 1,
    DTAxisFormatterDateSubTypeDay = 1 << 2,
    DTAxisFormatterDateSubTypeTime = 1 << 3,
};

@interface DTAxisFormatter : NSObject

#pragma mark - y主轴

/**
 * y主轴type
 */
@property(nonatomic) DTAxisFormatterType mainYAxisType;
/**
 * DTAxisFormatterTypeDate下的日期type
 */
@property(nonatomic) DTAxisFormatterDateSubType mainYAxisDateSubType;
/**
 * DTAxisFormatterTypeNumber下，y主轴的文字格式，默认 "%.0f"
 */
@property(nonatomic) NSString *mainYAxisFormat;
/**
 * DTAxisFormatterTypeNumber下，y主轴数据缩放比，默认1
 */
@property(nonatomic) CGFloat mainYAxisScale;


#pragma mark - y副轴
/**
 * y副轴type
 */
@property(nonatomic) DTAxisFormatterType secondYAxisType;
/**
 * DTAxisFormatterTypeDate下的日期type
 */
@property(nonatomic) DTAxisFormatterDateSubType secondYAxisDateSubType;
/**
 * DTAxisFormatterTypeNumber下，y副轴的文字格式，默认 "%.0f"
 */
@property(nonatomic) NSString *secondYAxisFormat;
/**
 * DTAxisFormatterTypeNumber下，y副轴数据缩放比，默认1
 */
@property(nonatomic) CGFloat secondYAxisScale;

#pragma mark - x轴

/**
 * x轴type
 */
@property(nonatomic) DTAxisFormatterType xAxisType;
/**
 * DTAxisFormatterTypeDate下的日期type
 */
@property(nonatomic) DTAxisFormatterDateSubType xAxisDateSubType;
/**
 * DTAxisFormatterTypeNumber下，x轴的文字格式，默认 "%.0f"
 */
@property(nonatomic) NSString *xAxisFormat;
/**
 * DTAxisFormatterTypeNumber下，x轴数据缩放比，默认1
 */
@property(nonatomic) CGFloat xAxisScale;


+ (instancetype)axisFormatter;

- (NSString *)getMainYAxisLabelTitle:(NSString *)string orValue:(CGFloat)value;

- (NSString *)getSecondYAxisLabelTitle:(NSString *)string orValue:(CGFloat)value;

- (NSString *)getXAxisLabelTitle:(NSString *)string orValue:(CGFloat)value;
@end
