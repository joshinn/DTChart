//
//  DTPieChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"
#import "DTPieChart.h"

static CGFloat const DefaultThumbChartRadius = 4.5;
static CGFloat const DefaultPresentationChartRadius = 12;

typedef void(^DTPieChartTouchBlock)(NSString *partName, NSInteger partIndex);

typedef void(^MainChartItemsColorsCompletion)(NSArray<DTChartBlockModel *> *infos);

typedef void(^SecondChartItemsColorsCompletion)(NSArray<DTChartBlockModel *> *infos);


@interface DTPieChartController : DTChartController

/**
 * pie图半径，以单元格为单位
 */
@property(nonatomic) CGFloat chartRadius;

@property(nonatomic, copy) DTPieChartTouchBlock pieChartTouchBlock;

@property(nonatomic, copy) void (^pieChartTouchCancelBlock)(NSUInteger index);

@property(nonatomic, copy) MainChartItemsColorsCompletion mainChartItemsColorsCompletionBlock;

@property(nonatomic, copy) SecondChartItemsColorsCompletion secondChartItemsColorsCompletionBlock;

@property(nonatomic, copy) NSString *(^pieControllerTouchOneCompleteBlock)(NSUInteger partIndex, NSString *partTitle, CGFloat partValue, CGFloat sum);

/**
 * 要高亮的部分对应的标题
 * @note 会使图表内所有对应该标题的部分高亮
 */
@property(nonatomic) NSString *highlightTitle;

@property(nonatomic) DTPieChartTouchMode touchMode;

- (void)dismissSecondPieChart;

/**
 * 自定义pieRadius后，自动修改图表的size
 * @note Presentation模式下只调整主表的大小
 */
- (void)fitPieRadius;

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation __attribute__((unavailable("DTPieChartController can not add items")));

- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation __attribute__((unavailable("DTPieChartController can not delete items")));

- (void)setSecondChartItems:(NSArray<DTListCommonData *> *)listData;

- (void)drawSecondChart;
@end
