//
//  DTDistributionChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/20.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDistributionChartController.h"
#import "DTDistributionChart.h"
#import "DTChartLabel.h"

@interface DTDistributionChartController ()

@property(nonatomic) DTDistributionChart *mainDistributionChart;
@property(nonatomic) DTDistributionChart *secondDistributionChart;

@property(nonatomic) DTChartLabel *mainTitleLabel;
@property(nonatomic) DTChartLabel *secondTitleLabel;

@property(nonatomic) UIView *mainLevelColorIndicator;
@property(nonatomic) UIView *secondLevelColorIndicator;

@end

@implementation DTDistributionChartController

@synthesize chartView = _chartView;
@synthesize chartId = _chartId;


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super initWithOrigin:origin xAxis:xCount yAxis:yCount]) {
        UIView *containerView = [[UIView alloc] init];
        _chartView = containerView;
        _startHour = 7;

        _mainTitleLabel = [self labelFactory];
        _secondTitleLabel = [self labelFactory];

        [containerView addSubview:_mainTitleLabel];
        [containerView addSubview:_secondTitleLabel];

        self.chartMode = DTChartModeThumb;

    }
    return self;
}

- (DTChartLabel *)labelFactory {
    DTChartLabel *label = [DTChartLabel chartLabel];
    label.textColor = DTRGBColor(0xc0c0c0, 1);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;

    return label;
}

- (void)setStartHour:(NSUInteger)startHour {
    _startHour = startHour;

    self.mainDistributionChart.startHour = startHour;
    self.secondDistributionChart.startHour = startHour;
}

/**
 * 给chartId加上前缀
 * @param chartId 赋值的chartId
 */
- (void)setChartId:(NSString *)chartId {
    _chartId = [@"distribution-" stringByAppendingString:chartId];
}

- (void)setChartMode:(DTChartMode)chartMode {
    [super setChartMode:chartMode];

    switch (chartMode) {

        case DTChartModeThumb: {

            [self loadMainChart];
            [self dismissSecondChart];
        }
            break;
        case DTChartModePresentation: {

            [self loadMainChart];
            [self loadSecondChart];
        }
            break;
    }
}


#pragma mark - private method

- (void)loadMainChart {
    if (self.mainDistributionChart.superview) {
        [self.mainDistributionChart removeFromSuperview];
    }
    if (self.mainLevelColorIndicator) {
        [self.mainLevelColorIndicator removeFromSuperview];
        self.mainLevelColorIndicator = nil;
    }

    if (self.chartMode == DTChartModeThumb) {
        self.mainDistributionChart = [[DTDistributionChart alloc] initWithOrigin:CGPointMake(0, 0) xAxis:17 yAxis:11];
        self.mainDistributionChart.chartYAxisStyle = DTDistributionChartYAxisStyleSmall;

        self.mainTitleLabel.hidden = YES;
    } else if (self.chartMode == DTChartModePresentation) {
        self.mainDistributionChart = [[DTDistributionChart alloc] initWithOrigin:CGPointMake(0, 6 * 15) xAxis:28 yAxis:29];
        self.mainDistributionChart.chartYAxisStyle = DTDistributionChartYAxisStyleNone;
        self.mainDistributionChart.coordinateAxisInsets = ChartEdgeInsetsMake(0, 0, 0, 2);

        self.mainTitleLabel.hidden = NO;
    }

    self.mainDistributionChart.startHour = self.startHour;

    [self.chartView addSubview:self.mainDistributionChart];
    self.chartView.frame = CGRectMake(self.ctrlOrigin.x,
            self.ctrlOrigin.y,
            self.ctrlXCount * self.mainDistributionChart.coordinateAxisCellWidth,
            self.ctrlYCount * self.mainDistributionChart.coordinateAxisCellWidth);

    // 移动位置
    if (self.chartMode == DTChartModeThumb) {
        // 居中
        CGRect frame = self.mainDistributionChart.frame;
        CGFloat x = (CGRectGetWidth(self.chartView.frame) - CGRectGetWidth(self.mainDistributionChart.frame)) / 2;
        frame.origin.x = x;
        self.mainDistributionChart.frame = frame;

    } else if (self.chartMode == DTChartModePresentation) {
        // 和副表一起，整体居中
        CGRect frame = self.mainDistributionChart.frame;
        CGFloat x = CGRectGetWidth(self.chartView.frame) / 2 - (CGRectGetWidth(self.mainDistributionChart.frame) + 4 * self.mainDistributionChart.coordinateAxisCellWidth);
        frame.origin.x = x;
        self.mainDistributionChart.frame = frame;

        self.mainLevelColorIndicator = [self levelColorIndicateView:
                        CGRectMake(CGRectGetMinX(self.mainDistributionChart.frame),
                                CGRectGetMinY(self.mainDistributionChart.frame) - 2 * self.mainDistributionChart.coordinateAxisCellWidth,
                                CGRectGetWidth(self.mainDistributionChart.frame) - 4 * self.mainDistributionChart.coordinateAxisCellWidth / 10,
                                self.mainDistributionChart.coordinateAxisCellWidth)
                                                              colos:@[self.mainDistributionChart.lowLevelColor,
                                                                      self.mainDistributionChart.middleLevelColor,
                                                                      self.mainDistributionChart.highLevelColor,
                                                                      self.mainDistributionChart.supremeLevelColor]];
        [self.chartView addSubview:self.mainLevelColorIndicator];
    }

    self.mainTitleLabel.frame = CGRectMake(CGRectGetMinX(self.mainDistributionChart.frame), 0,
            CGRectGetWidth(self.mainDistributionChart.frame), self.mainDistributionChart.coordinateAxisCellWidth);

}

- (void)loadSecondChart {
    if (self.secondDistributionChart.superview) {
        [self.secondDistributionChart removeFromSuperview];
    }

    self.secondDistributionChart = [[DTDistributionChart alloc]
            initWithOrigin:CGPointMake(CGRectGetMaxX(self.mainDistributionChart.frame) + self.mainDistributionChart.coordinateAxisCellWidth, CGRectGetMinY(self.mainDistributionChart.frame)) xAxis:35 yAxis:29];
    self.secondDistributionChart.chartYAxisStyle = DTDistributionChartYAxisStyleLarge;
    self.secondDistributionChart.startHour = self.startHour;
    self.secondDistributionChart.lowLevelColor = DTRGBColor(0x01081A, 1);
    self.secondDistributionChart.middleLevelColor = DTRGBColor(0x014898, 1);
    self.secondDistributionChart.highLevelColor = DTRGBColor(0x018E75, 1);
    self.secondDistributionChart.supremeLevelColor = DTRGBColor(0xAAC901, 1);

    [self.chartView addSubview:self.secondDistributionChart];
    self.secondTitleLabel.hidden = NO;
    self.secondTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.secondDistributionChart.frame) - CGRectGetWidth(self.mainTitleLabel.frame),
            0, CGRectGetWidth(self.mainTitleLabel.frame), self.secondDistributionChart.coordinateAxisCellWidth);

    self.secondLevelColorIndicator = [self levelColorIndicateView:
                    CGRectMake(CGRectGetMaxX(self.secondDistributionChart.frame) - CGRectGetWidth(self.secondDistributionChart.contentView.bounds),
                            CGRectGetMinY(self.mainLevelColorIndicator.frame),
                            CGRectGetWidth(self.mainLevelColorIndicator.frame),
                            CGRectGetHeight(self.mainLevelColorIndicator.frame))
                                                            colos:@[self.secondDistributionChart.lowLevelColor,
                                                                    self.secondDistributionChart.middleLevelColor,
                                                                    self.secondDistributionChart.highLevelColor,
                                                                    self.secondDistributionChart.supremeLevelColor]];

    [self.chartView addSubview:self.secondLevelColorIndicator];
}

- (void)dismissSecondChart {
    if (self.secondDistributionChart.superview) {
        [self.secondDistributionChart removeFromSuperview];
    }
    self.secondDistributionChart = nil;
    self.secondTitleLabel.hidden = YES;

    [self.secondLevelColorIndicator removeFromSuperview];
    self.secondLevelColorIndicator = nil;
}

/**
 * 生成强弱颜色指示view
 * @param frame view的frame
 * @param colors 强弱颜色数据
 * @return view
 */
- (UIView *)levelColorIndicateView:(CGRect)frame colos:(NSArray<UIColor *> *)colors {
    UIView *container = [[UIView alloc] initWithFrame:frame];

    DTChartLabel *label = [self labelFactory];
    label.numberOfLines = 1;
    label.text = @"会话次数 弱到强";

    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}];
    label.frame = CGRectMake(0, 0, size.width, CGRectGetHeight(frame));

    [container addSubview:label];

    CGFloat levelViewWidth = (CGRectGetWidth(frame) - size.width) / colors.count;
    CGFloat gap = 3;
    CGFloat x = CGRectGetMaxX(label.frame) + gap;
    for (UIColor *color in colors) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, 0, levelViewWidth - gap, CGRectGetHeight(frame))];
        v.backgroundColor = color;
        [container addSubview:v];

        x += levelViewWidth;
    }

    return container;
}

/**
 * 生成x轴数据和对应的柱状体数据
 * @param listCommonData 原始数据
 * @param xAxisLabelDatas x轴数据容器
 * @param n 序号，给x轴数据用
 * @param bars 柱状体数据容器
 */
- (void)processBarAndXLabel:(DTListCommonData *)listCommonData
                    xLabels:(NSMutableArray<DTAxisLabelData *> *)xAxisLabelDatas
                      index:(NSInteger)n
                       bars:(NSMutableArray<DTChartSingleData *> *)bars {
    NSArray<DTCommonData *> *values = listCommonData.commonDatas;

    NSMutableArray<DTChartItemData *> *bar = [NSMutableArray array];

    for (NSUInteger i = 0; i < values.count; ++i) {

        DTCommonData *data = values[i];

        // 单个时间点
        DTChartItemData *itemData = [DTChartItemData chartData];
        itemData.itemValue = ChartItemValueMake(data.ptValue, data.ptName.floatValue);
        [bar addObject:itemData];
    }


    DTAxisLabelData *xLabelData = [[DTAxisLabelData alloc] initWithTitle:[self.axisFormatter getXAxisLabelTitle:listCommonData.seriesName orValue:0] value:n];
    [xAxisLabelDatas addObject:xLabelData];

    // 单个柱状体
    DTChartSingleData *singleData = [DTChartSingleData singleData:bar];
    singleData.singleId = listCommonData.seriesId;
    singleData.singleName = listCommonData.seriesName;
    [bars addObject:singleData];
}


- (void)processDistributionParts:(NSArray<DTListCommonData *> *)listData {

    NSMutableArray<DTAxisLabelData *> *xAxisLabelDatas = [NSMutableArray array];
    NSMutableArray<DTChartSingleData *> *bars = [NSMutableArray arrayWithCapacity:listData.count];

    NSMutableArray<DTListCommonData *> *listSecondData = [NSMutableArray array];

    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];

        if (!listCommonData.isMainAxis) { // 是副轴 过滤
            [listSecondData addObject:listCommonData];
            continue;
        }

        [self processBarAndXLabel:listCommonData xLabels:xAxisLabelDatas index:n bars:bars];

    }

    self.mainDistributionChart.xAxisLabelDatas = xAxisLabelDatas;
    self.mainDistributionChart.multiData = bars;

    [self processSecondDistributionParts:listSecondData];
}

- (void)processSecondDistributionParts:(NSArray<DTListCommonData *> *)listData {

    NSMutableArray<DTAxisLabelData *> *xAxisLabelDatas = [NSMutableArray array];
    NSMutableArray<DTChartSingleData *> *bars = [NSMutableArray arrayWithCapacity:listData.count];

    for (NSUInteger n = 0; n < listData.count; ++n) {

        DTListCommonData *listCommonData = listData[n];

        [self processBarAndXLabel:listCommonData xLabels:xAxisLabelDatas index:n bars:bars];

    }

    self.secondDistributionChart.xAxisLabelDatas = xAxisLabelDatas;
    self.secondDistributionChart.multiData = bars;
}

#pragma mark - override


- (void)setItems:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData axisFormat:(DTAxisFormatter *)axisFormat {
    [super setItems:chartId listData:listData axisFormat:axisFormat];

    if (!self.axisFormatter) {
        self.axisFormatter = [DTAxisFormatter axisFormatter];
    }

    [self processDistributionParts:listData];
}


- (void)drawChart {
    [super drawChart];

    self.mainTitleLabel.text = self.mainTitle;

    [self.mainDistributionChart drawChart];
    if (self.secondDistributionChart) {
        self.secondTitleLabel.text = self.secondTitle;
        [self.secondDistributionChart drawChart];
    }
}


@end
