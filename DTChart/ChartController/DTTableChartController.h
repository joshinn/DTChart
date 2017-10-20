//
//  DTTableChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/13.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"
#import "DTTableChart.h"

@class DTTableChartTitleOrderModel;

/**
 * 展开/收起block
 * @seriesId 展开row的id
 */
typedef void(^DTTableChartExpandTouchBlock)(NSString *seriesId);

/**
 * 排序block
 * @column 排序列的序号
 */
typedef void(^DTTableChartOrderTouchBlock)(BOOL isMainAXis, NSUInteger column);

@interface DTTableChartController : DTChartController
/**
 * table cell布局风格
 * @attention 要在[- (void)setItems:listData:axisFormat:]之后设置，否则无效
 */
@property(nonatomic) DTTableChartStyle tableChartStyle;
/**
 * 头view
 */
@property(nonatomic) UIView *headView;
/**
 * 头view的高度，默认0
 * @note 单位dp
 */
@property(nonatomic) CGFloat headViewHeight;
/**
 * 展开收起column，小于0表示无展开收起功能
 * @note 该column后一列会显示“展开…/收起…”
 */
@property(nonatomic) NSInteger collapseColumn;

/**
 * 设定主表每列的升降序图标
 */
@property(nonatomic) NSArray<DTTableChartTitleOrderModel *> *mainTitleOrderModels;
/**
 * 设定副表每列的升降序图标
 */
@property(nonatomic) NSArray<DTTableChartTitleOrderModel *> *secondTitleOrderModels;

/**
 * 展开/收起 回调
 */
@property(nonatomic, copy) DTTableChartExpandTouchBlock tableChartExpandTouchBlock;
/**
 * 排序回调
 */
@property(nonatomic, copy) DTTableChartOrderTouchBlock tableChartOrderTouchBlock;
/**
 * 表格的左偏移，默认0
 * 为了能让表格与某些东西对齐
 */
@property(nonatomic) CGFloat tableLeftOffset;

/**
 * 触摸提示回调
 */
@property(nonatomic, copy) NSString *(^chartHintTouchBlock)(NSInteger row, NSInteger index);
/**
 * 表格标题行的高度，默认35
 */
@property(nonatomic) CGFloat titleLabelHeight;
/**
 * 主数据的颜色标识，会在标题行的第一列里显示颜色标识
 */
@property(nonatomic) UIColor *mainColor;
/**
 * 副数据的颜色标识，会在标题行的副表第一列里显示颜色标识
 */
@property(nonatomic) UIColor *secondColor;

/**
 * 实例化
 * @param origin 等同于frame.origin
 * @param xCount frame.size.width 换算成单元格数
 * @param yCount frame.size.height 换算成单元格数
 * @param widths 自定义各个列的宽度
 * @return instance
 * @note widths规则详见 DTTableChart.presetTableChartCellWidth
*/
- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount custom:(NSArray *)widths;

/**
 * 设置自定义的列宽，赋值后，tableChartStyle变为DTTableChartStyleCustom
 * @param widths 列宽数据
 */
- (void)setCustomCellWidths:(NSArray *)widths;

/**
 * 增加展开行的详细项
 * @param listData 详细项
 */
- (void)addExpandItems:(NSArray<DTListCommonData *> *)listData;

@end

