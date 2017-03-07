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
        _ctrlOrigin = origin;
        _ctrlXCount = xCount;
        _ctrlYCount = yCount;

        _chartMode = DTChartModeThumb;
        _showAnimation = YES;

        _preferMainYAxisDataCount = 0;
        _preferSecondYAxisDataCount = 0;
        _preferXAxisDataCount = 0;
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

- (void)setAxisBackgroundColor:(UIColor *)axisBackgroundColor {
    _axisBackgroundColor = axisBackgroundColor;

    if ([self.chartView isKindOfClass:[DTChartBaseComponent class]]) {
        ((DTChartBaseComponent *) self.chartView).contentView.backgroundColor = axisBackgroundColor;
    }
}

- (void)setShowCoordinateAxisGrid:(BOOL)showCoordinateAxisGrid {
    _showCoordinateAxisGrid = showCoordinateAxisGrid;

    if ([self.chartView isKindOfClass:[DTChartBaseComponent class]]) {
        ((DTChartBaseComponent *) self.chartView).showCoordinateAxisGrid = showCoordinateAxisGrid;
    }
}


#pragma mark - private method


#pragma mark - public method

- (NSMutableArray<DTAxisLabelData *> *)generateYAxisLabelData:(NSUInteger)maxYAxisCount yAxisMaxValue:(CGFloat)maxY isMainAxis:(BOOL)isMainAxis {

    if (maxY == 0) {    // 最大值是0，只显示0标签
        maxY = 1;

        NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];

        for (NSUInteger i = 0; i <= maxYAxisCount; ++i) {
            CGFloat y = maxY * 1.0f / maxYAxisCount * i;

            NSString *title = [self.axisFormatter getMainYAxisLabelTitle:nil orValue:y];
            [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:y]];

            yAxisLabelDatas.lastObject.hidden = i != 0;

        }

        return yAxisLabelDatas;
    }

    BOOL yScaled = NO;  // 需要缩放时，记录缩放行为

    if ((isMainAxis && [self.axisFormatter.mainYAxisFormat containsString:@"%.0f"])
            || (!isMainAxis && [self.axisFormatter.secondYAxisFormat containsString:@"%.0f"])) {

        maxY *= isMainAxis ? self.axisFormatter.mainYAxisScale : self.axisFormatter.secondYAxisScale;
        yScaled = YES;

        if (maxY < 10) {   // 1位整数
            NSUInteger y = 10;
            while (y % maxYAxisCount != 0) {
                ++y;
            }
            maxY = y;
        } else if (maxY < 100) {    // 2位数
            NSUInteger y = maxYAxisCount * 5;
            while (y < maxY) {
                y += maxYAxisCount * 5;
            }
            maxY = y;
        } else {    // 大于2位数
            NSUInteger limit = 100;
            while (maxY >= limit) {
                limit *= 10;
            }
            limit /= 1000;

            NSUInteger y = maxYAxisCount * 10 * limit;
            while (y < maxY) {
                y += maxYAxisCount * 10 * limit;
            }

            maxY = y;
        }
    }


    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];

    for (NSUInteger i = 0; i <= maxYAxisCount; ++i) {
        CGFloat y = maxY / maxYAxisCount * i;

        if (yScaled) {
            y /= isMainAxis ? self.axisFormatter.mainYAxisScale : self.axisFormatter.secondYAxisScale;
        }

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

- (void)deleteItems:(NSArray<NSString *> *)seriesIds withAnimation:(BOOL)animation {
}

- (void)destroyChart {
    [DTManager clearCacheByChartIds:@[self.chartId]];
    [self.chartView removeFromSuperview];
    self.chartView = nil;
}

@end
