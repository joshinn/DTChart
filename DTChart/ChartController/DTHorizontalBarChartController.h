//
//  DTHorizontalBarChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"

@interface DTHorizontalBarChartController : DTChartController

/**
 * 柱状体宽度，以单元格为单位，默认1个单元格
 */
@property(nonatomic) CGFloat barWidth;

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation __attribute__((unavailable("DTHorizontalBarChart can not add items")));

- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation __attribute__((unavailable("DTHorizontalBarChart can not delete items")));
@end
