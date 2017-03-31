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
    DTTableChartStyleNone = 0,  ///< 无格式
    DTTableChartStyleCustom = 1,
    DTTableChartStyleC1C1 = 110, ///< web趋势分析，不要占比
    DTTableChartStyleC1C2 = 120,
    DTTableChartStyleC1C2B1 = 121,  ///< 趋势分析、累积趋势、效果广告（近期趋势）
    DTTableChartStyleC1C2B2 = 122,  ///< 时长分布、访问频率分布
    DTTableChartStyleC1C2B3 = 123,  ///< 创意主题分析、媒体分析
    DTTableChartStyleC1C3 = 130,
    DTTableChartStyleC1C3B1 = 131,   ///< 趋势分析、累积趋势、地理位置定向
    DTTableChartStyleC1C3B2 = 132,   ///< 终端分析 版本/终端机型/语言/操作系统/联网方式
    DTTableChartStyleC1C3B3 = 133,   ///< 创意主题分析、媒体分析
    DTTableChartStyleC1C3B4 = 134,   ///< 效果广告（广告位详情）
    DTTableChartStyleC1C4 = 140,
    DTTableChartStyleC1C4B1 = 141,   ///< 终端分析 地理位置
    DTTableChartStyleC1C5 = 150,
    DTTableChartStyleC1C5B1 = 151,   ///< 页面受访
    DTTableChartStyleC1C5B2 = 152,   ///< 新老访客、搜索广告（趋势分析）、搜索广告（搜索引擎）
    DTTableChartStyleC1C5B3 = 153,   ///< 终端分析 设备类型/操作系统/浏览器/屏幕分辨率/地理位置
    DTTableChartStyleC1C5B4 = 154,   ///< 广告位详情
    DTTableChartStyleC1C6 = 160,
    DTTableChartStyleC1C7 = 170,
    DTTableChartStyleC1C8 = 180,
    DTTableChartStyleC1C9 = 190,

    DTTableChartStyleC1C1C5 = 1150,     ///< 流量来源
    DTTableChartStyleC1C1C6 = 1160,     ///< 经典留存率、滚动留存率
    DTTableChartStyleC1C1C8 = 1180,     ///< 经典留存率、滚动留存率
    DTTableChartStyleC1C1C14 = 11140,   ///< 经典留存率、滚动留存率
    DTTableChartStyleC1C1C31 = 11310,

    DTTableChartStyleT2C1C1 = 20110, ///< web趋势分析，不要占比，对比
    DTTableChartStyleT2C1C2 = 20120,
    DTTableChartStyleT2C1C2B1 = 20121,  ///< 趋势分析 对比
    DTTableChartStyleT2C1C3 = 20130,
    DTTableChartStyleT2C1C3B1 = 20131,  ///< 趋势分析 对比
    DTTableChartStyleT2C1C4 = 20140,
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
 * @attention 宽度是dp
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
