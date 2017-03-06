//
//  DTPieChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"

typedef void(^DTPieChartTouchBlock)(NSInteger partIndex);

typedef void(^MainChartItemsColorsCompletion)(NSArray<DTChartBlockModel *> *infos);

typedef void(^SecondChartItemsColorsCompletion)(NSArray<DTChartBlockModel *> *infos);


@interface DTPieChartController : DTChartController

/**
 * pie图半径，以单元格为单位
 */
@property(nonatomic) CGFloat chartRadius;

@property(nonatomic, copy) DTPieChartTouchBlock pieChartTouchBlock;

@property(nonatomic, copy) MainChartItemsColorsCompletion mainChartItemsColorsCompletionBlock;

@property(nonatomic, copy) SecondChartItemsColorsCompletion secondChartItemsColorsCompletionBlock;

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation __attribute__((unavailable("DTPieChartController can not add items")));

- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation __attribute__((unavailable("DTPieChartController can not delete items")));

- (void)setSecondChartItems:(NSArray<DTListCommonData *> *)listData;

- (void)drawSecondChart;
@end
