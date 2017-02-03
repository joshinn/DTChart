//
//  DTTableChartSingleData.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/2.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartData.h"

typedef NS_ENUM(NSInteger, DTTableChartCellExpandType) {
    /**
     * 还没展开
     */
            DTTableChartCellWillExpand,
    /**
     * 展开中，网络请求等延时操作等待中
     */
            DTTableChartCellExpanding,
    /**
     * 已展开
     */
            DTTableChartCellDidExpand,
};

@interface DTTableChartSingleData : DTChartSingleData
/**
 * 是否是详细行的头部
 */
@property(nonatomic, getter=isHeaderRow) BOOL headerRow;
/**
 * 展开收起标志
 * @note YES:已收起  NO:已展开
 */
@property(nonatomic) DTTableChartCellExpandType expandType;
/**
 * 详细行
 */
@property(nonatomic) NSArray<DTTableChartSingleData *> *collapseRows;

@end
