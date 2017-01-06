//
//  DTTableChartCell.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/5.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTChartLabel;
@class DTChartItemData;
@class DTTableAxisLabelData;

extern CGFloat const DTTableChartCellHeight;


typedef void(^DTTableChartCellOrderClickBlock)(NSInteger index);

@interface DTTableChartCell : UITableViewCell

@property (nonatomic, copy) DTTableChartCellOrderClickBlock orderClickBlock;

/**
 * 初始化
 * @param widths label和gap的宽度
 * @param reuseIdentifier 复用id
 * @return cell
 */
- (instancetype)initWithWidths:(NSArray *)widths reuseIdentifier:(NSString *)reuseIdentifier;
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
