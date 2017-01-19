//
//  DTPieChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"

/**
 * 触摸手势回调
 * @param seriesId 该组数据的seriesId
 * @param partIndex -1 表示当前pie chart是不同seriesId的搜游数据展示，0,1...表示是同一个seriesId数据细分展示
 */
typedef void(^DTPieChartTouchBlock)(NSString *seriesId, NSInteger partIndex);


@interface DTPieChartController : DTChartController

/**
 * pie图半径，以单元格为单位
 */
@property(nonatomic) CGFloat chartRadius;

@property (nonatomic) DTPieChartTouchBlock pieChartTouchBlock;

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation __attribute__((unavailable("DTPieChartController can not add items")));

- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation __attribute__((unavailable("DTPieChartController can not delete items")));

@end
