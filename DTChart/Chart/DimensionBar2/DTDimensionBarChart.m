//
//  DTDimensionBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBarChart.h"
#import "DTDimensionBarChartCell.h"
#import "DTDimension2Model.h"
#import "DTChartLabel.h"

CGFloat const DimensionLabelWidth = 70;
CGFloat const DimensionLabelGap = 5;

@interface DTDimensionBarChart () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) UITableView *tableView;

@property(nonatomic, getter=isPrepare) BOOL prepare;

#pragma mark - ##############第一度量##############

@property(nonatomic) UILabel *mainTitleLabel;                ///< 第一度量标题
@property(nonatomic) CGFloat mainZeroX; ///< 第一度量0的x值
@property(nonatomic) CGFloat mainPositiveLimitValue;    ///< 第一度量正值的最大值
@property(nonatomic) CGFloat mainPositiveLimitX;        ///< 第一度量正值的最大值的x
@property(nonatomic) CGFloat mainNegativeLimitValue;    ///< 第一度量负值的最小值
@property(nonatomic) CGFloat mainNegativeLimitX;        ///< 第一度量负值的最小值的x

#pragma mark - ##############第二度量##############

@property(nonatomic) UILabel *secondTitleLabel;
@property(nonatomic) CGFloat secondZeroX;
@property(nonatomic) CGFloat secondPositiveLimitValue;
@property(nonatomic) CGFloat secondPositiveLimitX;
@property(nonatomic) CGFloat secondNegativeLimitValue;
@property(nonatomic) CGFloat secondNegativeLimitX;

@end

@implementation DTDimensionBarChart

static NSString *const DTDimensionBarChartCellId = @"DTDimensionBarChartCellId";

- (void)initial {
    [super initial];

    _prepare = NO;

    self.coordinateAxisInsets = ChartEdgeInsetsMake(0, 1, self.coordinateAxisInsets.right, self.coordinateAxisInsets.bottom);

    self.tableView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.tableView];

    [self addSubview:self.mainTitleLabel];
    [self addSubview:self.secondTitleLabel];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 15 * 2;

        [_tableView registerClass:[DTDimensionBarChartCell class] forCellReuseIdentifier:DTDimensionBarChartCellId];
    }
    return _tableView;
}

- (UILabel *)mainTitleLabel {
    if (!_mainTitleLabel) {
        _mainTitleLabel = [[UILabel alloc] init];
        _mainTitleLabel.font = [UIFont systemFontOfSize:12];
        _mainTitleLabel.textAlignment = NSTextAlignmentCenter;
        _mainTitleLabel.textColor = MainBarColor;
    }
    return _mainTitleLabel;
}

- (UILabel *)secondTitleLabel {
    if (!_secondTitleLabel) {
        _secondTitleLabel = [[UILabel alloc] init];
        _secondTitleLabel.font = [UIFont systemFontOfSize:12];
        _secondTitleLabel.textAlignment = NSTextAlignmentCenter;
        _secondTitleLabel.textColor = SecondBarColor;
    }
    return _secondTitleLabel;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isPrepare) {
        return self.mainData.listDimensions.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTDimensionBarChartCell *barChartCell = [tableView dequeueReusableCellWithIdentifier:DTDimensionBarChartCellId];

    barChartCell.cellSize = CGSizeMake(CGRectGetWidth(tableView.bounds), tableView.rowHeight);
    barChartCell.titleWidth = DimensionLabelWidth;
    barChartCell.titleGap = DimensionLabelGap;

    barChartCell.mainZeroX = self.mainZeroX;
    barChartCell.mainPositiveLimitValue = self.mainPositiveLimitValue;
    barChartCell.mainPositiveLimitX = self.mainPositiveLimitX;
    barChartCell.mainNegativeLimitValue = self.mainNegativeLimitValue;
    barChartCell.mainNegativeLimitX = self.mainNegativeLimitX;

    barChartCell.secondZeroX = self.secondZeroX;
    barChartCell.secondPositiveLimitValue = self.secondPositiveLimitValue;
    barChartCell.secondPositiveLimitX = self.secondPositiveLimitX;
    barChartCell.secondNegativeLimitValue = self.secondNegativeLimitValue;
    barChartCell.secondNegativeLimitX = self.secondNegativeLimitX;

    NSUInteger index = (NSUInteger) indexPath.row;
    DTDimension2Model *data = self.mainData.listDimensions[index];
    DTDimension2Model *secondData = self.secondData.listDimensions[index];
    DTDimension2Model *prev;
    if (index > 0) {
        prev = self.mainData.listDimensions[index - 1];
    } else {
        prev = nil;
    }
    DTDimension2Model *next;
    if (index < self.mainData.listDimensions.count - 1) {
        next = self.mainData.listDimensions[index + 1];
    } else {
        next = nil;
    }

    [barChartCell setCellData:data second:secondData prev:prev next:next];

    return barChartCell;
}


#pragma mark - override

- (BOOL)drawXAxisLabels {
    if (self.xAxisLabelDatas.count < 2) {
        DTLog(@"Error: x轴标签数量小于2");
        return NO;
    }

    NSUInteger yLabelContentCellCount = (NSUInteger) (self.mainData.listDimensions.firstObject.ptNames.count * (DimensionLabelWidth + DimensionLabelGap) / self.coordinateAxisCellWidth);
    NSUInteger barContentCellCount = self.xAxisCellCount - yLabelContentCellCount;   ///< 柱状体最大的空间

    if (self.secondData) {
        barContentCellCount /= 2;
        self.mainTitleLabel.frame = CGRectMake((self.coordinateAxisInsets.left + yLabelContentCellCount) * self.coordinateAxisCellWidth,
                0, barContentCellCount * self.coordinateAxisCellWidth, self.coordinateAxisCellWidth);
        self.mainTitleLabel.text = self.mainData.title;
    } else {
        self.mainTitleLabel.text = nil;
    }

    NSUInteger sectionCellCount = barContentCellCount / (self.xAxisLabelDatas.count - 1);

    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i;

        if (data.hidden) {
            continue;
        }

        DTChartLabel *xLabel = [DTChartLabel chartLabel];
        if (self.secondData) {
            xLabel.textColor = MainBarColor;
        }

        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.text = data.title;

        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: xLabel.font}];

        CGFloat x = (yLabelContentCellCount + self.coordinateAxisInsets.left + data.axisPosition) * self.coordinateAxisCellWidth;
        CGFloat y = CGRectGetMaxY(self.bounds) - self.coordinateAxisInsets.bottom * self.coordinateAxisCellWidth;
        if (size.height < self.coordinateAxisCellWidth) {
            y += (self.coordinateAxisCellWidth - size.height) / 2;

            if (data.value == 0) {
                self.mainZeroX = x;
            }
            if (i == 0 && data.value < 0) {
                self.mainNegativeLimitX = x;
                self.mainNegativeLimitValue = data.value;
            }
            if (i == self.xAxisLabelDatas.count - 1) {
                self.mainPositiveLimitX = x;
                self.mainPositiveLimitValue = data.value;
            }
        }

        if (i == self.xAxisLabelDatas.count - 1) {
            x -= (size.width + 5);
        } else {
            x -= size.width / 2;
        }

        xLabel.frame = (CGRect) {CGPointMake(x, y), size};

        [self addSubview:xLabel];
    }

    return YES;
}

- (BOOL)drawYAxisLabels {
    return YES;
}

- (void)drawValues {
    [self.tableView reloadData];
}

- (void)drawChart {
    [super drawChart];
    self.prepare = YES;

    if (self.secondData) {
        self.mainTitleLabel.hidden = NO;
        self.secondTitleLabel.hidden = NO;
        [self drawSecondChart];
    } else {
        self.mainTitleLabel.hidden = YES;
        self.secondTitleLabel.hidden = YES;
    }
}

- (BOOL)drawXSecondAxisLabels {
    if (self.xSecondAxisLabelDatas.count < 2) {
        DTLog(@"Error: x轴标签数量小于2");
        return NO;
    }

    NSUInteger yLabelContentCellCount = (NSUInteger) (self.secondData.listDimensions.firstObject.ptNames.count * (DimensionLabelWidth + DimensionLabelGap) / self.coordinateAxisCellWidth);
    NSUInteger barContentCellCount = self.xAxisCellCount - yLabelContentCellCount;   ///< 柱状体最大的空间

    barContentCellCount /= 2;

    self.secondTitleLabel.frame = CGRectMake((self.coordinateAxisInsets.left + yLabelContentCellCount + barContentCellCount) * self.coordinateAxisCellWidth,
            0, barContentCellCount * self.coordinateAxisCellWidth, self.coordinateAxisCellWidth);
    self.secondTitleLabel.text = self.secondData.title;

    NSUInteger sectionCellCount = barContentCellCount / (self.xSecondAxisLabelDatas.count - 1);

    for (NSUInteger i = 0; i < self.xSecondAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xSecondAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i;

        if (data.hidden) {
            continue;
        }

        DTChartLabel *xLabel = [DTChartLabel chartLabel];
        xLabel.textColor = SecondBarColor;

        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.text = data.title;

        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: xLabel.font}];

        CGFloat x = (yLabelContentCellCount + barContentCellCount + self.coordinateAxisInsets.left + data.axisPosition) * self.coordinateAxisCellWidth;
        CGFloat y = CGRectGetMaxY(self.bounds) - self.coordinateAxisInsets.bottom * self.coordinateAxisCellWidth;
        if (size.height < self.coordinateAxisCellWidth) {
            y += (self.coordinateAxisCellWidth - size.height) / 2;

            if (data.value == 0) {
                self.secondZeroX = x;
            }
            if (i == 0 && data.value < 0) {
                self.secondNegativeLimitX = x;
                self.secondNegativeLimitValue = data.value;
            }
            if (i == self.xSecondAxisLabelDatas.count - 1) {
                self.secondPositiveLimitX = x;
                self.secondPositiveLimitValue = data.value;
            }
        }

        if (i == 0) {
            x += 5;
        } else {
            x -= size.width / 2;
        }

        xLabel.frame = (CGRect) {CGPointMake(x, y), size};

        [self addSubview:xLabel];
    }

    return YES;
}

- (BOOL)drawYSecondAxisLabels {
    return YES;
}

- (void)drawSecondValues {
}

- (void)drawSecondChart {
    [super drawSecondChart];

    [self drawXSecondAxisLabels];
}
@end
