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
    DTAxisFormatterTypeSecond = 3,    // 秒
};

typedef NS_ENUM(NSInteger, DTAxisFormatterDateSubType) {
    DTAxisFormatterDateSubTypeYear = 1 << 0,
    DTAxisFormatterDateSubTypeMonth = 1 << 1,
    DTAxisFormatterDateSubTypeDay = 1 << 2,
    DTAxisFormatterDateSubTypeTime = 1 << 3,
};

#define Powers @[@"⁰", @"¹", @"²", @"³", @"⁴", @"⁵", @"⁶", @"⁷", @"⁸", @"⁹"]

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
 * DTAxisFormatterTypeNumber下，y主轴的单位，默认nil
 */
@property(nonatomic) NSString *mainYAxisUnit;
/**
 * DTAxisFormatterTypeNumber下，y主轴的数值10的次方数，默认0
 * @note 一般是10的3、6、9次方…
 */
@property(nonatomic) NSInteger mainYAxisNotation;
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
 * DTAxisFormatterTypeNumber下，y副轴的单位，默认nil
 */
@property(nonatomic) NSString *secondYAxisUnit;
/**
 * DTAxisFormatterTypeNumber下，y副轴的数值10的次方数，默认0
 * @note 一般是10的3、6、9次方…
 */
@property(nonatomic) NSInteger secondYAxisNotation;

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
 * x轴作为度量轴时，DTAxisFormatterTypeNumber下，x轴的数值的倍数，默认1
 * @note 一般是10的3次方，6次方，9次方
 */
@property(nonatomic) NSInteger xAxisNotation;
/**
 * DTAxisFormatterTypeNumber下，x轴的单位，默认nil
 */
@property(nonatomic) NSString *xAxisUnit;
/**
 * DTAxisFormatterTypeNumber下，x轴数据缩放比，默认1
 */
@property(nonatomic) CGFloat xAxisScale;


+ (instancetype)axisFormatter;

/**
 * 从已有的formatter复制一个实例，交换主轴xy的值
 * @param origin 要复制的对象
 * @return instance
 */
+ (instancetype)axisFormatterExClone:(DTAxisFormatter *)origin;

- (NSString *)getAxisLabelTitle:(NSString *)string orValue:(CGFloat)value format:(NSString *)format scale:(CGFloat)scale type:(DTAxisFormatterType)type dateSubType:(DTAxisFormatterDateSubType)dateSubType;

- (NSString *)getMainYAxisLabelTitle:(NSString *)string orValue:(CGFloat)value;

- (NSString *)getSecondYAxisLabelTitle:(NSString *)string orValue:(CGFloat)value;

- (NSString *)getXAxisLabelTitle:(NSString *)string orValue:(CGFloat)value;

/**
 * 获取坐标轴倍数文字
 * @param isMain 是否主轴
 * @return 文字
 * @note y轴是度量时
 */
- (NSString *)getNotationLabelText:(BOOL)isMain;
@end
