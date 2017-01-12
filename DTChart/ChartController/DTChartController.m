//
//  DTChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"
#import "DTCommonData.h"
#import "DTDataManager.h"
#import "DTChartBaseComponent.h"

@interface DTChartController ()


@end

@implementation DTChartController

- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super init]) {
        _chartMode = DTChartModeThumb;
        _showAnimation = YES;
    }
    return self;
}

- (void)initial {

}

- (NSString *)axisFormat {
    if (!_axisFormat) {
        _axisFormat = @"%.0f";
    }
    return _axisFormat;
}

#pragma mark - public method


- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(NSString *)axisFormat {
    self.chartId = chartId;
    self.axisFormat = axisFormat;
}


- (void)drawChart {
    if ([self.chartView isKindOfClass:[DTChartBaseComponent class]]) {
        ((DTChartBaseComponent *) self.chartView).showAnimation = self.showAnimation;
    }

}

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation {

}


- (void)dismissChart {
    [DTManager clearCacheByChartIds:@[self.chartId]];
    [self.chartView removeFromSuperview];
    self.chartView = nil;
}

@end
