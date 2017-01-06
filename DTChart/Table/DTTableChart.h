//
//  DTTableChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"

typedef NS_ENUM(NSInteger, DTTableChartStyle) {
    DTTableChartStyleCustom = 0,
    DTTableChartStyleC1C6,
    DTTableChartStyleC1C2,
    DTTableChartStyleC1C5,
    DTTableChartStyleC1C1C14,
    DTTableChartStyleT2C1C4,
    DTTableChartStyleC1C9,
    DTTableChartStyleT2C1C3,
    DTTableChartStyleC1C3,
    DTTableChartStyleC1C1C31,
    DTTableChartStyleT2C1C2,
    DTTableChartStyleC1C7,
    DTTableChartStyleC1C4,
    DTTableChartStyleC1C8,
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
 * 实例化，使用预设风格
 * @param chartStyle 除DTTableChartStyleCustom外的其他项
 * @param origin 等同frame.origin
 * @param height 等同frame.size.width
 * @return instance
 */
+ (instancetype)tableChart:(DTTableChartStyle)chartStyle origin:(CGPoint)origin heightCellCount:(NSUInteger)height;

/**
 * 实例化，DTTableChartStyleCustom
 * @param widths 所有label和gap的宽度
 * @param origin 等同frame.origin
 * @param height 等同frame.size.width
 * @return instance
 * @attention widths格式是@[ @{@"label" : @170}, @{@"gap" : @10} ]
 */
+ (instancetype)tableChartCustom:(NSArray<NSDictionary *> *)widths origin:(CGPoint)origin heightCellCount:(NSUInteger)height;

@end
