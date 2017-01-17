//
//  DTChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"
#import "DTChartBaseComponent.h"
#import "DTDataManager.h"


@interface DTChartController ()

@property(nonatomic, readwrite) NSUInteger mainYAxisDataCount;

@property(nonatomic, readwrite) NSUInteger secondYAxisDataCount;

@end

@implementation DTChartController


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super init]) {
        _chartMode = DTChartModeThumb;
        _showAnimation = YES;
    }
    return self;
}


- (void)setChartView:(UIView *)chartView {
    _chartView = chartView;
}

- (DTAxisFormatter *)axisFormatter {
    if (!_axisFormatter) {
        _axisFormatter = [DTAxisFormatter axisFormatter];
    }
    return _axisFormatter;
}

- (NSUInteger)mainYAxisDataCount {
    _mainYAxisDataCount = 0;
    if ([self.chartView isKindOfClass:[DTChartBaseComponent class]]) {
        _mainYAxisDataCount = ((DTChartBaseComponent *) self.chartView).multiData.count;
    }

    return _mainYAxisDataCount;
}

- (NSUInteger)secondYAxisDataCount {
    _secondYAxisDataCount = 0;
    if ([self.chartView isKindOfClass:[DTChartBaseComponent class]]) {
        _secondYAxisDataCount = ((DTChartBaseComponent *) self.chartView).secondMultiData.count;
    }

    return _secondYAxisDataCount;
}

- (void)setShowAnimation:(BOOL)showAnimation {
    if ([self.chartView isKindOfClass:[DTChartBaseComponent class]]) {
        _showAnimation = showAnimation;
        ((DTChartBaseComponent *) self.chartView).showAnimation = _showAnimation;
    }
}

- (void)setValueSelectable:(BOOL)valueSelectable {
    if ([self.chartView isKindOfClass:[DTChartBaseComponent class]]) {
        _valueSelectable = valueSelectable;
        ((DTChartBaseComponent *) self.chartView).valueSelectable = _valueSelectable;
    }
}

#pragma mark - public method


- (NSMutableArray<DTAxisLabelData *> *)generateYAxisLabelData:(NSUInteger)maxYAxisCount yAxisMaxValue:(CGFloat)maxY isMainAxis:(BOOL)isMainAxis {

    if (maxY == 0) {
        maxY = 10;
    }

    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];

    for (NSUInteger i = 0; i <= maxYAxisCount; ++i) {
        CGFloat y = maxY / maxYAxisCount * i;

        NSString *title;
        if (self.axisFormatter.mainYAxisType == DTAxisFormatterTypeText || self.axisFormatter.mainYAxisType == DTAxisFormatterTypeDate) {
            if (isMainAxis) {
                title = [self.axisFormatter getMainYAxisLabelTitle:[NSString stringWithFormat:@"%@", @(y)] orValue:0];
            } else {
                title = [self.axisFormatter getSecondYAxisLabelTitle:[NSString stringWithFormat:@"%@", @(y)] orValue:0];
            }
        } else if (self.axisFormatter.mainYAxisType == DTAxisFormatterTypeNumber) {
            if (isMainAxis) {
                title = [self.axisFormatter getMainYAxisLabelTitle:nil orValue:y];
            } else {
                title = [self.axisFormatter getSecondYAxisLabelTitle:nil orValue:y];
            }
        }

        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:y]];
    }

    return yAxisLabelDatas;
}


- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormatter {
    self.chartId = chartId;
    self.axisFormatter = axisFormatter;
}

- (void)drawChart {
}

- (void)addItemsListData:(NSArray<DTListCommonData *> *)listData withAnimation:(BOOL)animation {
}

- (void)deleteItems:(NSIndexSet *)indexSet isMainAxis:(BOOL)isMainAxis withAnimation:(BOOL)animation {
}

- (void)destroyChart {
    [DTManager clearCacheByChartIds:@[self.chartId]];
    [self.chartView removeFromSuperview];
    self.chartView = nil;
}

@end
