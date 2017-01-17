//
//  DTChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTCommonData;
@class DTListCommonData;
@class DTAxisLabelData;
@class DTAxisFormatter;


typedef NS_ENUM(NSInteger, DTChartMode) {
    DTChartModeThumb = 0,   // 小图模式
    DTChartModePresentation = 1,    // 大图模式
};

#define DTManager DTDataManager.shareManager

typedef void(^MainAxisColorsCompletionBlock)(NSArray<UIColor *> *colors, NSArray<NSString *> *seriesIds);

typedef void(^SecondAxisColorsCompletionBlock)(NSArray<UIColor *> *colors, NSArray<NSString *> *seriesIds);



@interface DTChartController : NSObject

@property(nonatomic, readonly) UIView *chartView;
/**
 * DTChart的id，对应一系列独立的数据
 * 会根据该id缓存数据的信息，比如颜色等
 *
 */
@property(nonatomic) NSString *chartId;
/**
 * DtChart的模式，小图/大图
 */
@property(nonatomic) DTChartMode chartMode;
/**
 * 主副坐标轴格式
 */
@property(nonatomic) DTAxisFormatter *axisFormatter;
/**
 * 绘制DTChart，是否有动画
 */
@property(nonatomic, getter=isShowAnimation) BOOL showAnimation;
/**
 * 坐标系里的点、柱状体等是否可点击选择，默认NO
 */
@property(nonatomic, getter=isValueSelectable) BOOL valueSelectable;
/**
 * y主轴数据量
 */
@property(nonatomic, readonly) NSUInteger mainYAxisDataCount;
/**
 * y副轴数据量
 */
@property(nonatomic, readonly) NSUInteger secondYAxisDataCount;
/**
 * 主轴颜色回调
 */
@property(nonatomic, copy) MainAxisColorsCompletionBlock mainAxisColorsCompletionBlock;
/**
 * 副轴颜色回调
 */
@property(nonatomic, copy) SecondAxisColorsCompletionBlock secondAxisColorsCompletionBlock;

/**
 * 实例化
 * @param origin 等同于frame.origin
 * @param xCount frame.size.width 换算成单元格数
 * @param yCount frame.size.height 换算成单元格数
 * @return instance
 */
- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount;

/**
 * 构造y轴数据
 * @param maxYAxisCount y轴限制的label数量
 * @param maxY y轴最大值
 * @param isMainAxis 是否主轴
 * @return y轴label data
 */
- (NSMutableArray<DTAxisLabelData *> *)generateYAxisLabelData:(NSUInteger)maxYAxisCount yAxisMaxValue:(CGFloat)maxY isMainAxis:(BOOL)isMainAxis;

/**
 * 设置DTChart内容
 * @param chartId chartId
 * @param listData 数据内容
 * @param axisFormat y轴格式
 */
- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat __attribute__((objc_requires_super));

/**
 * 绘制DTChart
 */
- (void)drawChart;

/**
 * 添加数据
 * @param listData 若干组数据
 * @param animation 是否动画
 */
- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation;

/**
 * 删除指定主副轴某些数据
 * @param indexSet 要删除的序号
 * @param isMainAxis 主副轴
 * @param animation 动画
 */
- (void)deleteItems:(NSIndexSet *)indexSet isMainAxis:(BOOL)isMainAxis withAnimation:(BOOL)animation;

/**
 * 彻底销毁DTChart和缓存的数据
 */
- (void)destroyChart __attribute__((objc_requires_super));
@end
