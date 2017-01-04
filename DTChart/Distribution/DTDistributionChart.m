//
//  DTDistributionChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/30.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTDistributionChart.h"
#import "DTDistributionBar.h"
#import "DTColor.h"
#import "DTChartLabel.h"


@interface DTDistributionChart ()

@property(nonatomic) NSMutableArray<DTDistributionBar *> *chartBars;

@property(nonatomic) NSArray<NSDictionary *> *largeYLabelTitles;

@end

@implementation DTDistributionChart


- (void)initial {
    [super initial];

    self.chartYAxisStyle = DTDistributionChartYAxisStyleNone;
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
            self.yAxisLabelDatas = nil;
            self.coordinateAxisInsets = ChartEdgeInsetsMake(0, 0, 0, 1);
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

#pragma mark - private method

/**
 * 生成small style的y轴数据
 */
- (void)smallYAxisData {
    self.coordinateAxisInsets = ChartEdgeInsetsMake(3, 0, 0, 1);

    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];
    NSArray<NSString *> *yTitles = @[@"01:00\n|\n6:59", @"19:00\n|\n00:59", @"13:00\n|\n18:59", @"07:00\n|\n12:59"];

    {
        [yTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:idx + 1]];
        }];
    }
    self.yAxisLabelDatas = yAxisLabelDatas.copy;
}

/**
 * 生成large style的y轴数据
 */
- (void)largeYAxisData {
    self.coordinateAxisInsets = ChartEdgeInsetsMake(7, 0, 0, 2);

    NSMutableArray<NSDictionary *> *largeYLabelTitles = [NSMutableArray array];
    [largeYLabelTitles addObject:@{@"startTime": @"07:00", @"endTime": @"08:59", @"chinese": @"辰"}];
    [largeYLabelTitles addObject:@{@"startTime": @"09:00", @"endTime": @"10:59", @"chinese": @"已"}];
    [largeYLabelTitles addObject:@{@"startTime": @"11:00", @"endTime": @"12:59", @"chinese": @"午"}];
    [largeYLabelTitles addObject:@{@"startTime": @"13:00", @"endTime": @"14:59", @"chinese": @"未"}];
    [largeYLabelTitles addObject:@{@"startTime": @"15:00", @"endTime": @"16:59", @"chinese": @"申"}];
    [largeYLabelTitles addObject:@{@"startTime": @"17:00", @"endTime": @"18:59", @"chinese": @"酉"}];
    [largeYLabelTitles addObject:@{@"startTime": @"19:00", @"endTime": @"20:59", @"chinese": @"戌"}];
    [largeYLabelTitles addObject:@{@"startTime": @"21:00", @"endTime": @"22:59", @"chinese": @"亥"}];
    [largeYLabelTitles addObject:@{@"startTime": @"23:00", @"endTime": @"00:59", @"chinese": @"子"}];
    [largeYLabelTitles addObject:@{@"startTime": @"01:00", @"endTime": @"02:59", @"chinese": @"丑"}];
    [largeYLabelTitles addObject:@{@"startTime": @"03:00", @"endTime": @"04:59", @"chinese": @"寅"}];
    [largeYLabelTitles addObject:@{@"startTime": @"05:00", @"endTime": @"06:59", @"chinese": @"卯"}];

    self.largeYLabelTitles = largeYLabelTitles;
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

        [self largeYAxisLabelFactory:yLabel startTime:dictionary[@"startTime"] endTime:dictionary[@"endTime"] chinese:dictionary[@"chinese"]];

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
        yLabel.textColor = DTRGBColor(0xbfc1c0, 1);
        chineseLabel.textColor = DTRGBColor(0xbfc1c0, 1);

    }
}


#pragma mark - override

- (void)setMultiData:(NSArray<DTChartSingleData *> *)multiData {
    [super setMultiData:multiData];

    for (DTChartSingleData *singleData in multiData) {
        for (DTChartItemData *itemData in singleData.itemValues) {
            if (itemData.itemValue.y == 0) {
                itemData.color = DTDistributionLowLevelColor;
            } else if (itemData.itemValue.y == 1) {
                itemData.color = DTDistributionMiddleLevelColor;
            } else if (itemData.itemValue.y == 2) {
                itemData.color = DTDistributionHighLevelColor;
            } else if (itemData.itemValue.y == 3) {
                itemData.color = DTDistributionSupremeLevelColor;
            }
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
        DTAxisLabelData *data = self.yAxisLabelDatas[i];


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
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (DTChartSingleData *sData in self.multiData) {
        DTChartItemData *itemData = sData.itemValues.firstObject;
        CGFloat value = itemData.itemValue.x;
        __block NSUInteger index = 0;

        [self.xAxisLabelDatas enumerateObjectsUsingBlock:^(DTAxisLabelData *obj, NSUInteger idx, BOOL *stop) {
            if (value == obj.value) {
                index = idx;
            }
        }];

        if (index < self.chartBars.count) {
            [indexSet addIndex:index];
            DTDistributionBar *bar = self.chartBars[index];
            bar.singleData = sData;
            [bar drawSubItems];
        }

    }

    // 绘制没有数据的bar
    for (NSUInteger i = 0; i < self.chartBars.count; ++i) {
        if ([indexSet containsIndex:i]) {
            continue;
        }

        DTDistributionBar *bar = self.chartBars[i];
        [bar drawSubItems];
    }


}


@end
