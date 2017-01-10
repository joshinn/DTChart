//
//  DTTableChartCell.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/5.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTableChart.h"

@class DTChartLabel;
@class DTChartItemData;
@class DTTableAxisLabelData;

extern CGFloat const DTTableChartCellHeight;


typedef void(^DTTableChartCellOrderClickBlock)(NSInteger index);

@interface DTTableChartCell : UITableViewCell
/**
 * 升降序排列回调
 */
@property(nonatomic, copy) DTTableChartCellOrderClickBlock orderClickBlock;

/**
 * 设置cell风格
 * @param style cell风格
 * @param widths label和gap的宽度
 */
- (void)setStyle:(DTTableChartStyle)style widths:(NSArray *)widths;

/**
 *  设置table的标题，即第一行
 * @param titleDatas 标题数据
 */
- (void)setCellTitle:(NSArray<DTTableAxisLabelData *> *)titleDatas;

/**
 * 设置table的表格内容数据
 * @param data 每行的数据
 * @param indexPath 该行的indexPath
 */
- (void)setCellData:(NSArray<DTChartItemData *> *)data indexPath:(NSIndexPath *)indexPath;

@end
