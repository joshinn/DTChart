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

/**
 * 柱状图触摸回调
 * @return 触摸提示内容
 * @note param dataIndex 第几组数据
 * @note param barIndex  数据里的第几根柱状体
 */
@property(nonatomic) NSString *(^barChartControllerTouchBlock)(NSUInteger dataIndex, NSUInteger barIndex);


- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation __attribute__((unavailable("DTHorizontalBarChart can not add items")));

- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation __attribute__((unavailable("DTHorizontalBarChart can not delete items")));
@end
