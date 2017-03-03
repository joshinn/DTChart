//
//  DTDistributionChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/30.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTDistributionChart.h"
#import "DTDistributionBar.h"
#import "DTChartLabel.h"
#import "DTChartToastView.h"
#import "DTColor.h"


@interface DTDistributionChart () <DTDistributionBarDelegate>

@property(nonatomic) NSMutableArray<DTDistributionBar *> *chartBars;

@property(nonatomic) NSArray<NSDictionary *> *largeYLabelTitles;

/**
 * 上一个触摸选择的DTDistributionBar序号
 */
@property(nonatomic) NSInteger prevBarSelectedIndex;

@end

@implementation DTDistributionChart

static NSString *const kStartTimeKey = @"startTime";
static NSString *const kEndTimeKey = @"endTime";
static NSString *const kChineseTimeKey = @"chinese";

- (void)initial {
    [super initial];

    _startHour = 7;
    self.chartYAxisStyle = DTDistributionChartYAxisStyleNone;

    _lowLevelColor = DTDistributionLowLevelColor;
    _middleLevelColor = DTDistributionMiddleLevelColor;
    _highLevelColor = DTDistributionHighLevelColor;
    _supremeLevelColor = DTDistributionSupremeLevelColor;

    _lowLevel = 100;
    _middleLevel = 500;
    _highLevel = 1000;

    _prevBarSelectedIndex = -1;
}

- (NSMutableArray<DTDistributionBar *> *)chartBars {
    if (!_chartBars) {
        _chartBars = [NSMutableArray<DTDistributionBar *> array];
    }
    return _chartBars;
}

- (void)setChartYAxisStyle:(DTDistributionChartYAxisStyle)chartYAxisStyle {
    _chartYAxisStyle = chartYAxisStyle;

    switch (chartYAxisStyle) {
        case DTDistributionChartYAxisStyleNone: {
        }
            break;
        case DTDistributionChartYAxisStyleSmall: {
            self.coordinateAxisInsets = ChartEdgeInsetsMake(3, 0, 0, 1);
        }
            break;
        case DTDistributionChartYAxisStyleLarge: {
            self.coordinateAxisInsets = ChartEdgeInsetsMake(7, 0, 0, 2);
        }
            break;
        case DTDistributionChartYAxisStyleCustom: {
        }
            break;

    }
}

#pragma mark - private method

/**
 * 根据chartYAxisStyle生成y轴数据
 */
- (void)processYAxisStyle {

    switch (self.chartYAxisStyle) {
        case DTDistributionChartYAxisStyleNone: {
            self.yAxisLabelDatas = nil;
        }
            break;
        case DTDistributionChartYAxisStyleSmall: {
            [self smallYAxisData];
        }
            break;
        case DTDistributionChartYAxisStyleLarge: {
            [self largeYAxisData];
        }
            break;
        case DTDistributionChartYAxisStyleCustom: {
            self.yAxisLabelDatas = nil;
        }
            break;

    }
}

/**
 * 生成small style的y轴数据
 */
- (void)smallYAxisData {
    self.coordinateAxisInsets = ChartEdgeInsetsMake(3, 0, 0, 1);

    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];

    for (NSUInteger i = 0; i < 4; ++i) {
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:[self formatSmallStyleYLabelTitle:self.startHour + 6 * i] value:i + 1]];
    }
    self.yAxisLabelDatas = yAxisLabelDatas.copy;
}

- (NSString *)formatSmallStyleYLabelTitle:(NSInteger)hour {
    NSMutableString *string = [NSMutableString string];

    NSInteger endHour = hour + 5;

    if (hour >= 24) {
        hour -= 24;
    }
    if (endHour >= 24) {
        endHour -= 24;
    }
    if (hour < 10) {
        [string appendString:[NSString stringWithFormat:@"0%@:00", @(hour)]];
    } else {
        [string appendString:[NSString stringWithFormat:@"%@:00", @(hour)]];
    }
    [string appendString:@"\n|\n"];
    if (endHour < 10) {
        [string appendString:[NSString stringWithFormat:@"0%@:59", @(endHour)]];
    } else {
        [string appendString:[NSString stringWithFormat:@"%@:59", @(endHour)]];
    }

    return string;
}

/**
 * 生成large style的y轴数据
 */
- (void)largeYAxisData {
    self.coordinateAxisInsets = ChartEdgeInsetsMake(7, 0, 0, 2);

    NSMutableArray<NSDictionary *> *largeYLabelTitles = [NSMutableArray array];

    for (NSUInteger i = 0; i < 12; ++i) {
        [largeYLabelTitles addObject:[self formatLargeStyleYLabelTitle:self.startHour + i * 2]];
    }

    self.largeYLabelTitles = largeYLabelTitles;
}

- (NSDictionary *)formatLargeStyleYLabelTitle:(NSInteger)hour {
    NSInteger endHour = hour + 1;

    if (hour >= 24) {
        hour -= 24;
    }
    if (endHour >= 24) {
        endHour -= 24;
    }

    NSString *startTime;
    NSString *endTime;

    if (hour < 10) {
        startTime = [NSString stringWithFormat:@"0%@:00", @(hour)];
    } else {
        startTime = [NSString stringWithFormat:@"%@:00", @(hour)];
    }
    if (endHour < 10) {
        endTime = [NSString stringWithFormat:@"0%@:59", @(endHour)];
    } else {
        endTime = [NSString stringWithFormat:@"%@:59", @(endHour)];
    }

    return @{kStartTimeKey: startTime, kEndTimeKey: endTime, kChineseTimeKey: [self getChineseTime:hour]};
}

- (NSString *)getChineseTime:(NSInteger)hour {
    if (hour >= 1 && hour <= 2) {
        return @"丑";
    } else if (hour >= 3 && hour <= 4) {
        return @"寅";
    } else if (hour >= 5 && hour <= 6) {
        return @"卯";
    } else if (hour >= 7 && hour <= 8) {
        return @"辰";
    } else if (hour >= 9 && hour <= 10) {
        return @"已";
    } else if (hour >= 11 && hour <= 12) {
        return @"午";
    } else if (hour >= 13 && hour <= 14) {
        return @"未";
    } else if (hour >= 15 && hour <= 16) {
        return @"申";
    } else if (hour >= 17 && hour <= 18) {
        return @"酉";
    } else if (hour >= 19 && hour <= 20) {
        return @"戌";
    } else if (hour >= 21 && hour <= 22) {
        return @"亥";
    } else if (hour >= 23 || hour < 1) {
        return @"子";
    }

    return @"";
}

/**
 * 绘制large style的y轴
 */
- (void)drawLargeYAxisLabels {
    CGFloat sectionGap = CGRectGetHeight(self.contentView.frame) / DTDistributionBarSectionGapRatio;
    CGFloat sectionHeight = (CGRectGetHeight(self.contentView.frame) - sectionGap * 3) / 4;

    CGFloat y = self.coordinateAxisInsets.top * self.coordinateAxisCellWidth;

    for (NSUInteger i = 0; i < self.largeYLabelTitles.count; i++) {
        NSDictionary *dictionary = self.largeYLabelTitles[i];
        DTChartLabel *yLabel = [DTChartLabel chartLabel];

        yLabel.frame = CGRectMake(0, y + 1,
                self.coordinateAxisCellWidth * (self.coordinateAxisInsets.left - 1),
                sectionHeight / 3 - 2);

        [self largeYAxisLabelFactory:yLabel startTime:dictionary[kStartTimeKey] endTime:dictionary[kEndTimeKey] chinese:dictionary[kChineseTimeKey]];

        [self addSubview:yLabel];

        y += sectionHeight / 3;
        if ((i + 1) % 3 == 0) {
            y += sectionGap;
        }
    }
}

/**
 * large style的y轴标签label工厂
 * @param yLabel 标签label
 * @param startTime 开始时间
 * @param endTime 结束时间
 * @param chinese 对应的中文时间
 */
- (void)largeYAxisLabelFactory:(DTChartLabel *)yLabel startTime:(NSString *)startTime endTime:(NSString *)endTime chinese:(NSString *)chinese {
    CGFloat yLabelHeight = CGRectGetHeight(yLabel.frame);

    UIFont *largeFont = [UIFont systemFontOfSize:yLabelHeight * 0.42f];
    UIFont *smallFont = [UIFont systemFontOfSize:yLabelHeight * 0.32f];
    UIFont *chineseFont = [UIFont systemFontOfSize:yLabelHeight * 0.71f];

    yLabel.backgroundColor = DTRGBColor(0x000000, 0.4);
    yLabel.layer.cornerRadius = 4;
    yLabel.layer.masksToBounds = YES;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"    " attributes:@{NSFontAttributeName: smallFont}]];

    NSMutableAttributedString *startTimeAttributeString = [[NSMutableAttributedString alloc] initWithString:startTime];
    [startTimeAttributeString addAttribute:NSFontAttributeName value:smallFont range:NSMakeRange(0, startTimeAttributeString.length)];
    if ([[startTime substringToIndex:1] isEqualToString:@"0"]) {
        [startTimeAttributeString addAttribute:NSFontAttributeName value:largeFont range:NSMakeRange(1, 1)];
        [startTimeAttributeString addAttribute:NSBaselineOffsetAttributeName value:@((smallFont.capHeight - largeFont.capHeight) / 2) range:NSMakeRange(1, 1)];
    } else {
        [startTimeAttributeString addAttribute:NSFontAttributeName value:largeFont range:NSMakeRange(0, 2)];
        [startTimeAttributeString addAttribute:NSBaselineOffsetAttributeName value:@((smallFont.capHeight - largeFont.capHeight) / 2) range:NSMakeRange(0, 2)];
    }
    [attributedString appendAttributedString:startTimeAttributeString];

    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n        " attributes:@{NSFontAttributeName: smallFont}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:endTime attributes:@{NSFontAttributeName: smallFont}]];

    yLabel.attributedText = attributedString;

    DTChartLabel *chineseLabel = [DTChartLabel chartLabel];
    chineseLabel.textAlignment = NSTextAlignmentCenter;
    chineseLabel.text = chinese;
    chineseLabel.font = chineseFont;

    CGSize size = [chineseLabel.text sizeWithAttributes:@{NSFontAttributeName: chineseFont}];
    chineseLabel.frame = CGRectMake(CGRectGetWidth(yLabel.frame) - size.width - 10, 0, size.width, yLabelHeight);
    [yLabel addSubview:chineseLabel];

    if (self.yAxisLabelColor) {
        yLabel.textColor = self.yAxisLabelColor;
        chineseLabel.textColor = self.yAxisLabelColor;
    } else {
        yLabel.textColor = DTRGBColor(0xc0c0c0, 1);
        chineseLabel.textColor = DTRGBColor(0xc0c0c0, 1);

    }
}

- (UIColor *)getLevelColor:(CGFloat)value {
    if (value < self.lowLevel) {
        return self.lowLevelColor;
    } else if (value < self.middleLevel) {
        return self.middleLevelColor;
    } else if (value < self.highLevel) {
        return self.highLevelColor;
    } else {
        return self.supremeLevelColor;
    }
}

- (void)showTouchMessage:(NSString *)message touchPoint:(CGPoint)point {
    [self.toastView show:message location:point];
}


#pragma mark - touch event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.valueSelectable) {
        [super touchesBegan:touches withEvent:event];

    } else {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self.contentView];

        for (NSUInteger i = 0; i < self.chartBars.count; ++i) {
            DTDistributionBar *bar = self.chartBars[i];
            if (CGRectContainsPoint(bar.frame, touchPoint)) {
                self.prevBarSelectedIndex = i;

                [bar touchesBegan:touches withEvent:event];

                break;
            }
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.valueSelectable) {
        [super touchesMoved:touches withEvent:event];

    } else {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self.contentView];

        for (NSUInteger i = 0; i < self.chartBars.count; ++i) {
            DTDistributionBar *bar = self.chartBars[i];
            if (CGRectContainsPoint(bar.frame, touchPoint)) {
                if (self.prevBarSelectedIndex != i) {
                    if (self.prevBarSelectedIndex >= 0 && self.prevBarSelectedIndex < self.subviews.count) {
                        DTDistributionBar *prevBar = self.chartBars[(NSUInteger) self.prevBarSelectedIndex];
                        [prevBar touchesMoved:touches withEvent:event];
                    }
                }

                [bar touchesMoved:touches withEvent:event];

                self.prevBarSelectedIndex = i;

                break;
            }
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.valueSelectable) {
        [super touchesEnded:touches withEvent:event];

    } else {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self.contentView];

        for (NSUInteger i = 0; i < self.chartBars.count; ++i) {
            DTDistributionBar *bar = self.chartBars[i];
            if (CGRectContainsPoint(bar.frame, touchPoint)) {
                if (self.prevBarSelectedIndex != i) {
                    if (self.prevBarSelectedIndex >= 0 && self.prevBarSelectedIndex < self.subviews.count) {
                        DTDistributionBar *prevBar = self.chartBars[(NSUInteger) self.prevBarSelectedIndex];
                        [prevBar touchesEnded:touches withEvent:event];
                    }
                }

                [bar touchesEnded:touches withEvent:event];

                break;
            }
        }

        if (self.prevBarSelectedIndex >= 0 && self.prevBarSelectedIndex < self.subviews.count) {
            DTDistributionBar *prevBar = self.chartBars[(NSUInteger) self.prevBarSelectedIndex];
            [prevBar touchesEnded:touches withEvent:event];
        }
        self.prevBarSelectedIndex = -1;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.valueSelectable) {
        [super touchesCancelled:touches withEvent:event];

    } else {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self.contentView];

        for (NSUInteger i = 0; i < self.chartBars.count; ++i) {
            DTDistributionBar *bar = self.chartBars[i];
            if (CGRectContainsPoint(bar.frame, touchPoint)) {
                if (self.prevBarSelectedIndex != i) {
                    if (self.prevBarSelectedIndex >= 0 && self.prevBarSelectedIndex < self.subviews.count) {
                        DTDistributionBar *prevBar = self.chartBars[(NSUInteger) self.prevBarSelectedIndex];
                        [prevBar touchesCancelled:touches withEvent:event];
                    }
                }

                [bar touchesCancelled:touches withEvent:event];

                break;
            }
        }

        if (self.prevBarSelectedIndex >= 0 && self.prevBarSelectedIndex < self.subviews.count) {
            DTDistributionBar *prevBar = self.chartBars[(NSUInteger) self.prevBarSelectedIndex];
            [prevBar touchesCancelled:touches withEvent:event];
        }
        self.prevBarSelectedIndex = -1;

    }
}


#pragma mark - override

- (void)setMultiData:(NSArray<DTChartSingleData *> *)multiData {
    [super setMultiData:multiData];

    for (DTChartSingleData *singleData in multiData) {
        for (DTChartItemData *itemData in singleData.itemValues) {
            itemData.color = [self getLevelColor:itemData.itemValue.x];
        }
    }
}

/**
 * 清除坐标系里的轴标签和值线条
 */
- (void)clearChartContent {
    [self.contentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTDistributionBar class]]) {
            [obj removeFromSuperview];
        }
    }];

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self.chartBars removeAllObjects];
}


- (BOOL)drawXAxisLabels {
    if (![super drawXAxisLabels]) {
        return NO;
    }

    [self.chartBars removeAllObjects];

    CGFloat sectionWidth = CGRectGetWidth(self.contentView.frame) / self.xAxisLabelDatas.count;

    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];

        // 绘制x轴
        DTChartLabel *xLabel = [DTChartLabel chartLabel];
        if (self.xAxisLabelColor) {
            xLabel.textColor = self.xAxisLabelColor;
        } else {
            xLabel.textColor = DTRGBColor(0xc0c0c0, 1);
        }

        xLabel.backgroundColor = DTRGBColor(0x000000, 0.4);
        xLabel.layer.cornerRadius = 4;
        xLabel.layer.masksToBounds = YES;

        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.text = data.title;

        CGFloat x = self.coordinateAxisInsets.left * self.coordinateAxisCellWidth + sectionWidth * i;
        CGFloat y = CGRectGetMaxY(self.contentView.frame) + 1;
        CGFloat height = self.coordinateAxisInsets.bottom * self.coordinateAxisCellWidth - 2;

        xLabel.font = [UIFont systemFontOfSize:height / 2 + 1];
        xLabel.frame = CGRectMake(x, y, sectionWidth * 0.9f, height);

        [self addSubview:xLabel];

        // 绘制分布小方块
        DTDistributionBar *bar = [DTDistributionBar distributionBar];
        bar.frame = CGRectMake(sectionWidth * i, 0, sectionWidth, CGRectGetHeight(self.contentView.frame));
        [self.contentView addSubview:bar];
        [self.chartBars addObject:bar];
    }

    return YES;
}


- (BOOL)drawYAxisLabels {

    if (self.chartYAxisStyle == DTDistributionChartYAxisStyleLarge) {
        [self drawLargeYAxisLabels];

        return YES;
    }

    CGFloat sectionGap = CGRectGetHeight(self.contentView.frame) / 30;
    CGFloat sectionHeight = (CGRectGetHeight(self.contentView.frame) - sectionGap * 3) / 4;

    for (NSUInteger i = 0; i < self.yAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.yAxisLabelDatas[self.yAxisLabelDatas.count - i - 1];

        // 绘制y轴
        DTChartLabel *yLabel = [DTChartLabel chartLabel];
        if (self.yAxisLabelColor) {
            yLabel.textColor = self.xAxisLabelColor;
        }
        yLabel.backgroundColor = DTRGBColor(0x000000, 0.4);
        yLabel.layer.cornerRadius = 4;
        yLabel.layer.masksToBounds = YES;

        yLabel.textAlignment = NSTextAlignmentCenter;
        yLabel.text = data.title;

        CGFloat x = 0;
        CGFloat y = CGRectGetHeight(self.frame) - self.coordinateAxisInsets.bottom * self.coordinateAxisCellWidth - (sectionHeight + sectionGap) * i - sectionHeight + 1;
        CGFloat width = MAX(self.coordinateAxisInsets.left - 1, 0) * self.coordinateAxisCellWidth;
        CGFloat height = sectionHeight - 2;

        yLabel.frame = CGRectMake(x, y, width, height);

        [self addSubview:yLabel];
    }

    return YES;
}


- (void)drawValues {

    // 绘制有数据的bar
    for (NSUInteger i = 0; i < self.multiData.count; ++i) {
        DTChartSingleData *sData = self.multiData[i];

        if (i < self.chartBars.count) {
            DTDistributionBar *bar = self.chartBars[i];

            bar.delegate = self;
            bar.singleData = sData;
            bar.startHour = self.startHour;
            [bar drawSubItems];
        }
    }

}

- (void)drawChart {
    [self processYAxisStyle];

    [super drawChart];
}


#pragma mark - DTDistributionBarDelegate

- (void)distributionBarItemBeginTouch:(DTChartSingleData *)singleData data:(DTChartItemData *)itemData location:(CGPoint)point {
    NSString *message = nil;
    if (self.distributionChartTouchBlock) {
        message = self.distributionChartTouchBlock(singleData, itemData);
    }
    if (!message) {
        NSMutableString *mutableString = [NSMutableString string];
        [mutableString appendString:singleData.singleName];
        [mutableString appendString:@" "];
        NSDictionary *dictionary = [self formatLargeStyleYLabelTitle:(NSInteger) itemData.itemValue.y];
        [mutableString appendString:[NSString stringWithFormat:@"%@-%@", dictionary[kStartTimeKey], dictionary[kEndTimeKey]]];
        [mutableString appendString:@"\n"];
        [mutableString appendString:[NSString stringWithFormat:@"%@", @(itemData.itemValue.x)]];

        message = mutableString;
    }
    [self showTouchMessage:message touchPoint:point];

}

- (void)distributionBarItemEndTouch{
    [self.toastView hide];
}


@end
