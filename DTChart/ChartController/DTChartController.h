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



typedef NS_ENUM(NSInteger, DTChartMode) {
    DTChartModeThumb = 0,
    DTChartModePresentation = 1,
};

#define DTManager DTDataManager.shareManager

@interface DTChartController : NSObject

@property(nonatomic) UIView *chartView;

@property(nonatomic) NSString *chartId;

@property(nonatomic) DTChartMode chartMode;

@property(nonatomic) NSString *axisFormat;

@property (nonatomic, getter=isShowAnimation) BOOL showAnimation;

- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount;

- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(NSString *)axisFormat;

- (void)drawChart;

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation;

- (void)dismissChart;
@end
