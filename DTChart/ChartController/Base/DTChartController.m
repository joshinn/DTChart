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
#import "DTChartData.h"


@implementation DTChartControllerAxisFormatter

+ (instancetype)axisFormatter {
    DTChartControllerAxisFormatter *formatter = [[DTChartControllerAxisFormatter alloc] init];
    return formatter;
}

- (instancetype)init {
    if (self = [super init]) {
        _mainAxisScale = 1;
        _secondAxisScale = 1;
    }
    return self;
}

- (NSString *)mainAxisFormat {
    if (!_mainAxisFormat) {
        _mainAxisFormat = @"%.0f";
    }
    return _mainAxisFormat;
}

- (NSString *)secondAxisFormat {
    if (!_secondAxisFormat) {
        _secondAxisFormat = @"%.0f";
    }
    return _secondAxisFormat;
}

@end


@interface DTChartController ()

@property(nonatomic, readwrite) NSUInteger mainAxisDataCount;

@end

@implementation DTChartController

//@synthesize mainAxisDataCount = _mainAxisDataCount;

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

- (DTChartControllerAxisFormatter *)axisFormatter {
    if (!_axisFormatter) {
        _axisFormatter = [DTChartControllerAxisFormatter axisFormatter];
    }
    return _axisFormatter;
}

- (NSUInteger)mainAxisDataCount {
    _mainAxisDataCount = 0;
    if ([self.chartView isKindOfClass:[DTChartBaseComponent class]]) {
        _mainAxisDataCount = ((DTChartBaseComponent *) self.chartView).multiData.count;
    }

    return _mainAxisDataCount;
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
        if (isMainAxis) {
            title = [NSString stringWithFormat:self.axisFormatter.mainAxisFormat, y * self.axisFormatter.mainAxisScale];
        } else {
            title = [NSString stringWithFormat:self.axisFormatter.secondAxisFormat, y * self.axisFormatter.secondAxisScale];
        }
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:y]];
    }

    return yAxisLabelDatas;
}


- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTChartControllerAxisFormatter *)axisFormatter {
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
