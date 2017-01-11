//
//  DTChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTCommonData;


typedef NS_ENUM(NSInteger, DTChartMode) {
    DTChartModeThumb = 0,
    DTChartModePresentation = 1,
};

@interface DTChartController : NSObject

@property(nonatomic) UIView *chartView;

@property(nonatomic) NSString *chartId;

@property(nonatomic) DTChartMode chartMode;

- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount;

- (void)addItem:(NSString *)itemId seriesName:(NSString *)seriesName values:(NSArray<DTCommonData *> *)values;

- (void)drawChart;
@end
