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

- (void)setXLabelLimitWidth:(BOOL)xLabelLimitWidth {
    if ([self.chartView isKindOfClass:[DTChartBaseComponent class]]) {
        _xLabelLimitWidth = xLabelLimitWidth;
        ((DTChartBaseComponent *) self.chartView).xLabelLimitWidth = xLabelLimitWidth;
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

            NSString *title = nil;
            if (isMainAxis) {
                title = [self.axisFormatter getMainYAxisLabelTitle:nil orValue:y];
            } else {
                title = [self.axisFormatter getSecondYAxisLabelTitle:nil orValue:y];
            }
            [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:y]];

            yAxisLabelDatas.lastObject.hidden = i != 0;

        }

        return yAxisLabelDatas;
    }


    BOOL yScaled = NO;  // 需要缩放时，记录缩放行为
    CGFloat scale = isMainAxis ? self.axisFormatter.mainYAxisScale : self.axisFormatter.secondYAxisScale;
    CGFloat maxLimit = isMainAxis ? self.mainYAxisMaxValueLimit : self.secondYAxisMaxValueLimit;
    maxLimit *= scale;

    // 确定坐标轴最大值
    if ((isMainAxis && [self.axisFormatter.mainYAxisFormat containsString:@"%.0f"])
            || (!isMainAxis && [self.axisFormatter.secondYAxisFormat containsString:@"%.0f"])) {

        maxY *= scale;
        yScaled = YES;

        if (maxY <= 3) {    // 最大值在不大于3时，Y轴会取小数

            CGFloat divide = 0.1f * maxYAxisCount;
            CGFloat y = 0;
            while (y < maxY) {
                y += divide;
            }

            maxY = y;

            if (isMainAxis) {
                NSMutableString *st = [NSMutableString stringWithString:self.axisFormatter.mainYAxisFormat];
                self.axisFormatter.mainYAxisFormat = [st stringByReplacingOccurrencesOfString:@"%.0f" withString:@"%.1f"];
            } else {
                NSMutableString *st = [NSMutableString stringWithString:self.axisFormatter.secondYAxisFormat];
                self.axisFormatter.secondYAxisFormat = [st stringByReplacingOccurrencesOfString:@"%.0f" withString:@"%.1f"];
            }

        } else if (maxY <= maxYAxisCount && maxYAxisCount < 10) {  // 10以内，从0，1，2...maxYAxisCount
            maxY = maxYAxisCount;

        } else if (maxY <= 10) {   // 10以内
            NSUInteger y = 10;
            while (y % maxYAxisCount != 0) {
                ++y;
            }
            maxY = y;
        } else if (maxY <= 100) {    // 100以内
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

        if (maxY > maxLimit && maxLimit > 0) {
            maxY = maxLimit;

            while (maxYAxisCount >= 1 && maxLimit / maxYAxisCount != (NSInteger) (maxY / maxYAxisCount)) {
                --maxYAxisCount;
            }
        }
    }


    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];
    NSInteger unitScale = 1;

    for (NSUInteger i = 0; i <= maxYAxisCount; ++i) {
        CGFloat y = maxY / maxYAxisCount * i;

        if (i == 1) {
            NSInteger intY = (NSInteger) y;

            NSInteger notation = 1000000000;
            while (notation >= 1000) {
                if (intY != 0 && intY % notation == 0) {
                    unitScale = notation;
                    if (isMainAxis) {
                        self.axisFormatter.mainYAxisNotation = notation;
                    } else {
                        self.axisFormatter.secondYAxisNotation = notation;
                    }

                    break;
                } else {
                    notation /= 1000;
                }
            }
        }

        if (yScaled) {
            y /= scale;
        }

        NSString *title;
        DTAxisFormatterType axisType = isMainAxis ? self.axisFormatter.mainYAxisType : self.axisFormatter.secondYAxisType;
        if (axisType == DTAxisFormatterTypeText || axisType == DTAxisFormatterTypeDate) {
            if (isMainAxis) {
                title = [self.axisFormatter getMainYAxisLabelTitle:[NSString stringWithFormat:@"%@", @(y)] orValue:0];
            } else {
                title = [self.axisFormatter getSecondYAxisLabelTitle:[NSString stringWithFormat:@"%@", @(y)] orValue:0];
            }
        } else if (axisType == DTAxisFormatterTypeNumber) {
            if (isMainAxis) {
                title = [self.axisFormatter getMainYAxisLabelTitle:nil orValue:y / unitScale];
            } else {
                title = [self.axisFormatter getSecondYAxisLabelTitle:nil orValue:y / unitScale];
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
