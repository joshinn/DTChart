//
//  DTTableChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"

typedef NS_ENUM(NSInteger, DTTableChartStyle) {
    DTTableChartStyleNone = 0,  // 无格式
    DTTableChartStyleCustom = 1,
    DTTableChartStyleC1C2 = 12,
    DTTableChartStyleC1C3 = 13,
    DTTableChartStyleC1C4 = 14,
    DTTableChartStyleC1C5 = 15,
    DTTableChartStyleC1C6 = 16,
    DTTableChartStyleC1C7 = 17,
    DTTableChartStyleC1C8 = 18,
    DTTableChartStyleC1C9 = 19,

    DTTableChartStyleC1C1C14 = 114,
    DTTableChartStyleC1C1C31 = 1131,

    DTTableChartStyleT2C1C2 = 2012,
    DTTableChartStyleT2C1C3 = 2013,
    DTTableChartStyleT2C1C4 = 2014,
};


@interface DTTableChart : DTChartBaseComponent
/**
 * 头view
 */
@property(nonatomic, readonly) UIView *headView;
/**
 * 头view的高度，默认0
 * @note 单位dp
 */
@property(nonatomic) CGFloat headViewHeight;
/**
 * table cell布局风格
 */
@property(nonatomic) DTTableChartStyle tableChartStyle;


/**
 * 实例化，使用预设风格
 * @param chartStyle chartStyle 除DTTableChartStyleCustom外的其他项
 * @param origin 等同frame.origin
 * @param width 等同frame.size.width
 * @param height 等同frame.size.height
 * @return instance
 */
+ (instancetype)tableChart:(DTTableChartStyle)chartStyle origin:(CGPoint)origin widthCellCount:(NSUInteger)width heightCellCount:(NSUInteger)height;
/**
 * 实例化，DTTableChartStyleCustom
 * @param widths 所有label和gap的宽度
 * @param origin 等同frame.origin
 * @param width 等同frame.size.width
 * @param height 等同frame.size.height
 * @return instance
 * @attention widths格式是@[ @{@"label" : @170}, @{@"gap" : @10} ]
 */
+ (instancetype)tableChartCustom:(NSArray *)widths origin:(CGPoint)origin widthCellCount:(NSUInteger)width heightCellCount:(NSUInteger)height;
@end
