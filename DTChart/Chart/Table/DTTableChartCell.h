//
//  DTTableChartCell.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/5.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTableChart.h"

@class DTChartItemData;
@class DTTableAxisLabelData;
@class DTTableChartSingleData;

extern CGFloat const DTTableChartCellHeight;


@protocol DTTableChartCellDelegate <NSObject>

- (void)chartCellToExpandTouched:(NSString *)seriesId;

- (void)chartCellToCollapseTouched:(NSString *)seriesId;

/**
 * 升降序排列回调
 */
- (void)chartCellOrderTouched:(BOOL)isMainAxis column:(NSUInteger)column;

- (void)chartCellHintTouchBegin:(NSString *)text index:(NSUInteger)index isMainAxis:(BOOL)isMainAxis touch:(UITouch *)touch;

- (void)chartCellHintTouchEnd;

@end

@interface DTTableChartCell : UITableViewCell

@property(nonatomic, weak) id <DTTableChartCellDelegate> delegate;

/**
 * 展开收起column，小于0表示无展开收起功能
 * @note 该column后一列会显示“展开…/收起…”
 */
@property(nonatomic) NSInteger collapseColumn;
/**
 * 表格的左偏移，默认0
 * 为了能让表格与某些东西对齐
 */
@property(nonatomic) CGFloat labelLeftOffset;

@property(nonatomic) BOOL selectable;

/**
 * 设置cell风格
 * @param style cell风格
 * @param widths label和gap的宽度
 */
- (void)setStyle:(DTTableChartStyle)style widths:(NSArray *)widths;

/**
 *  设置table的标题，即第一行
 * @param titleDatas 主表标题数据
 * @param secondTitleDatas 副表标题数据
 */
- (void)setCellTitle:(NSArray<DTTableAxisLabelData *> *)titleDatas secondTitles:(NSArray<DTTableAxisLabelData *> *)secondTitleDatas;


/**
 * 设置table的表格内容数据
 * @param singleData 主表每行的数据
 * @param secondSingleData 副表每行数据
 * @param indexPath 该行的indexPath
 */
- (void)setCellData:(DTTableChartSingleData *)singleData second:(DTTableChartSingleData *)secondSingleData indexPath:(NSIndexPath *)indexPath;

@end
