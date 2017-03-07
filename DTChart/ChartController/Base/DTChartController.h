//
//  DTChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAxisFormatter.h"
#import "DTCommonData.h"
#import "DTChartBlockModel.h"

@class DTAxisLabelData;


typedef NS_ENUM(NSInteger, DTChartMode) {
    DTChartModeThumb = 0,   // 小图模式
    DTChartModePresentation = 1,    // 大图模式
};

#define DTManager DTDataManager.shareManager

/**
 * 主轴颜色，type，id回调
 * @note DTLineChart type:0 圆形 1:方形 2:三角形
 */
typedef void(^MainAxisColorsCompletionBlock)(NSArray<DTChartBlockModel *> *infos);

/**
 * 副轴颜色，type，id回调
 * @note DTLineChart type:0 圆形 1:方形 2:三角形
 */
typedef void(^SecondAxisColorsCompletionBlock)(NSArray<DTChartBlockModel *> *infos);

@interface DTChartController : NSObject

@property(nonatomic, readonly) UIView *chartView;
/**
 * 坐标系contentView的背景色
 */
@property(nonatomic) UIColor *axisBackgroundColor;
/**
 * 显示坐标系的网格
 */
@property(nonatomic, getter=isShowCoordinateAxisGrid) BOOL showCoordinateAxisGrid;

@property(nonatomic) CGPoint ctrlOrigin;
@property(nonatomic) NSUInteger ctrlXCount;
@property(nonatomic) NSUInteger ctrlYCount;

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
 * 自定义y主轴数据量
 */
@property(nonatomic) NSUInteger preferMainYAxisDataCount;
/**
 * 自定义y副轴数据量
 */
@property(nonatomic) NSUInteger preferSecondYAxisDataCount;
/**
 * 自定义x轴数据量
 */
@property(nonatomic) NSUInteger preferXAxisDataCount;
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
 * @return instancet
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
 * 删除指定seriesId的数据
 * @param seriesIds 要删除的series id
 * @param animation 动画
 */
- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation;

/**
 * 彻底销毁DTChart和缓存的数据
 */
- (void)destroyChart __attribute__((objc_requires_super));
@end
