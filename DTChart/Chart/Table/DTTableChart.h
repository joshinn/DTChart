//
//  DTTableChart.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"

@class DTTableChartSingleData;

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


/**
 * 展开/收起block
 * @seriesId 展开row的id
 */
typedef void(^DTTableChartExpandTouch)(NSString *seriesId);

/**
 * 排序block
 * @column 排序列的序号
 */
typedef void(^DTTableChartOrderTouch)(BOOL isMainAxis, NSUInteger column);

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
 * 展开收起column，小于0表示无展开收起功能
 * @note 该column后一列会显示“展开…/收起…”
 */
@property(nonatomic) NSInteger collapseColumn;
/**
 * 表格的左偏移，默认0
 * 为了能让表格与某些东西对齐
 */
@property(nonatomic) CGFloat tableLeftOffset;
/**
 * 行展开回调
 */
@property(nonatomic, copy) DTTableChartExpandTouch expandTouchBlock;
/**
 * 排序回调
 */
@property(nonatomic, copy) DTTableChartOrderTouch orderTouchBlock;

/**
 * 获取表格一行所有label和间隙的宽度
 * @param chartStyle 预设表格风格
 * @return 宽度
 *
 * @attention 宽度是px，需除以2
 */
+ (NSArray *)presetTableChartCellWidth:(DTTableChartStyle)chartStyle;

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

- (void)deleteItems:(NSArray<NSString *> *)seriesIds;

/**
 * 增加展开项的详细内容
 * @param mainData 详细内容
 * @attention 暂时只支持主表
 */
- (void)addExpandItems:(NSArray<DTTableChartSingleData *> *)mainData;

@end
