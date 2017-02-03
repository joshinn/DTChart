//
//  DTTableChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/13.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"

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
typedef void(^DTTableChartOrderTouchBlock)(NSUInteger column);

@interface DTTableChartController : DTChartController
/**
 * 展开收起column，小于0表示无展开收起功能
 * @note 该column后一列会显示“展开…/收起…”
 */
@property(nonatomic) NSInteger collapseColumn;

/**
 * 设定每列的升降序图标
 */
@property(nonatomic) NSArray<DTTableChartTitleOrderModel *> *titleOrderModels;

/**
 * 展开/收起 回调
 */
@property(nonatomic, copy) DTTableChartExpandTouchBlock tableChartExpandTouchBlock;
/**
 * 排序回调
 */
@property(nonatomic, copy) DTTableChartOrderTouchBlock tableChartOrderTouchBlock;

/**
 * 增加展开行的详细项
 * @param listData 详细项
 */
- (void)addExpandItems:(NSArray<DTListCommonData *> *)listData;

@end

