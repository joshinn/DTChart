//
//  DTMeasureDimensionHorizontalBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/1.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTMeasureDimensionHorizontalBarChart.h"
#import "DTDimensionModel.h"
#import "DTDimensionReturnModel.h"
#import "DTDimensionBarModel.h"
#import "DTChartLabel.h"
#import "DTColor.h"

@interface DTMeasureDimensionHorizontalBarChart ()

@property(nonatomic) UIScrollView *scrollView;

@property(nonatomic) UIView *scrollMainContentView;
@property(nonatomic) UIView *scrollSecondContentView;

/**
 * 计算DTBar的x坐标
 */
@property(nonatomic) CGFloat barY;

@end


@implementation DTMeasureDimensionHorizontalBarChart

@synthesize barBorderStyle = _barBorderStyle;

- (void)initial {
    [super initial];

    self.userInteractionEnabled = YES;

    _barBorderStyle = DTBarBorderStyleSidesBorder;
    _barY = 0;
    _yOffset = self.coordinateAxisCellWidth;


    // scroll view
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0,
            self.coordinateAxisInsets.top * self.coordinateAxisCellWidth,
            CGRectGetWidth(self.bounds),
            CGRectGetHeight(self.bounds) - (self.coordinateAxisInsets.bottom + self.coordinateAxisInsets.top) * self.coordinateAxisCellWidth);

    _scrollView.clipsToBounds = YES;

    if (self.xAxisCellCount % 2 == 1) {

    }

    _scrollMainContentView = [[UIView alloc] init];
    [_scrollView addSubview:_scrollMainContentView];

    _scrollSecondContentView = [UIView new];
    [_scrollView addSubview:_scrollSecondContentView];

    [self addSubview:_scrollView];

    self.colorManager = [DTColorManager randomManager];
}

- (NSMutableArray<DTDimensionBarModel *> *)levelLowestBarModels {
    if (!_levelLowestBarModels) {
        _levelLowestBarModels = [NSMutableArray array];
    }
    return _levelLowestBarModels;
}

#pragma mark - private method

/**
 * 遍历数据源所有值，绘制柱状体和坐标轴标签
 * @param data 数据源
 * @param isDraw NO：不绘制柱状体和坐标轴标签，纯遍历数据源里的所有值
 * @return 遍历结果
 */
- (DTDimensionReturnModel *)layoutMainBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {

    CGFloat axisX = 0;
    CGFloat axisYMax = CGRectGetWidth(self.contentView.bounds);
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    DTDimensionReturnModel *returnModel = [[DTDimensionReturnModel alloc] init];
    returnModel.level = 0;
    returnModel.sectionWidth = self.barY;

    if (data.ptListValue.count > 0) {

        BOOL sectionStart = YES;

        for (DTDimensionModel *model in data.ptListValue) {
            if (model.ptListValue.count > 0) {
                DTDimensionReturnModel *returnModel2 = [self layoutMainBars:model drawSubviews:isDraw];

                DTLog(@"ptName = %@ sectionWidth = %@ level = %@", model.ptName, @(returnModel2.sectionWidth / 15), @(returnModel2.level));

                CGFloat labelY = self.barY - returnModel2.sectionWidth - 2 * self.coordinateAxisCellWidth;
                CGFloat labelX = (self.coordinateAxisInsets.left - returnModel2.level - 1) * self.coordinateAxisCellWidth;

                if (isDraw) {

                    CGFloat height;
                    if (returnModel2.level > 0) {
                        height = returnModel2.sectionWidth;
                    } else {
                        height = returnModel2.sectionWidth + self.coordinateAxisCellWidth;
                    }

                    DTChartLabel *titleLabel = [DTChartLabel chartLabel];
                    titleLabel.font = [UIFont systemFontOfSize:12];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    titleLabel.text = model.ptName;
                    titleLabel.frame = CGRectMake(labelX, labelY, self.coordinateAxisCellWidth, height);

                    if (returnModel2.level == 0) {
                        titleLabel.textColor = DTColorGray;
                    }

                    [self.scrollView addSubview:titleLabel];
                }

                if (sectionStart) {
                    returnModel.level = returnModel2.level + 1;
                    sectionStart = NO;
                } else {
                    if (returnModel2.level >= 0) {

                        if (isDraw) {
                            CGFloat y = labelY - 1 - self.coordinateAxisCellWidth;
                            CGFloat x = -returnModel2.level * self.coordinateAxisCellWidth;

                            CGFloat toX = axisYMax - (8 - returnModel2.level * 2) * self.coordinateAxisCellWidth;
                            CGFloat width = toX - x;

                            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, 2)];
                            line.backgroundColor = DTRGBColor(0x7b7b7b, 1);

                            [self.scrollMainContentView addSubview:line];
                        }
                    }
                }

                if (returnModel2.level == 0) {
                    self.barY += self.coordinateAxisCellWidth;
                }

            } else {


                if (!isDraw) {
                    __block BOOL exist = NO;
                    [self.levelLowestBarModels enumerateObjectsUsingBlock:^(DTDimensionBarModel *obj, NSUInteger idx, BOOL *stop) {
                        if ([obj.title isEqualToString:model.ptName]) {
                            exist = YES;
                            *stop = YES;
                        }
                    }];

                    if (!exist) {
                        DTDimensionBarModel *barModel = [[DTDimensionBarModel alloc] init];
                        barModel.title = model.ptName;
                        barModel.color = [self.colorManager getColor];
                        barModel.secondColor = [self.colorManager getLightColor:barModel.color];
                        [self.levelLowestBarModels addObject:barModel];
                    }
                }


                if (model.ptValue > self.maxX) {
                    self.maxX = model.ptValue;
                }


                if (isDraw) {

                    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
                    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

                    CGFloat width = self.coordinateAxisCellWidth * ((model.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * xMaxData.axisPosition;

                    DTBar *bar = [DTBar bar:DTBarOrientationRight style:self.barBorderStyle];
                    bar.frame = CGRectMake(axisX, self.barY, width, barWidth);

                    DTDimensionBarModel *barModel = [self getBarModelByName:model.ptName];
                    bar.barColor = barModel.color;
                    bar.barBorderColor = barModel.secondColor;

                    [self.scrollMainContentView addSubview:bar];

                    if (self.showAnimation) {
                        [bar startAppearAnimation];
                    }
                }

                self.barY += barWidth + self.coordinateAxisCellWidth;
            }
        }
        returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
        DTLog(@"level = %@,  cell count = %@", @(returnModel.level), @(returnModel.sectionWidth / 15));
        return returnModel;

    } else {

        if (!isDraw) {
            __block BOOL exist = NO;
            [self.levelLowestBarModels enumerateObjectsUsingBlock:^(DTDimensionBarModel *obj, NSUInteger idx, BOOL *stop) {
                if ([obj.title isEqualToString:data.ptName]) {
                    exist = YES;
                    *stop = YES;
                }
            }];

            if (!exist) {
                DTDimensionBarModel *barModel = [[DTDimensionBarModel alloc] init];
                barModel.title = data.ptName;
                barModel.color = [self.colorManager getColor];
                barModel.secondColor = [self.colorManager getLightColor:barModel.color];
                [self.levelLowestBarModels addObject:barModel];
            }
        }

        if (isDraw) {
            DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
            DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

            CGFloat width = self.coordinateAxisCellWidth * ((data.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * xMaxData.axisPosition;

            DTBar *bar = [DTBar bar:DTBarOrientationRight style:self.barBorderStyle];
            bar.frame = CGRectMake(axisX, self.barY, width, barWidth);

            DTDimensionBarModel *barModel = [self getBarModelByName:data.ptName];
            bar.barColor = barModel.color;
            bar.barBorderColor = barModel.secondColor;

            [self.scrollMainContentView addSubview:bar];

            if (self.showAnimation) {
                [bar startAppearAnimation];
            }
        }

        self.barY += barWidth + self.coordinateAxisCellWidth;
    }

    returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
    return returnModel;
}

- (DTDimensionReturnModel *)layoutSecondBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {

    CGFloat axisX = 0;
    CGFloat axisYMax = CGRectGetWidth(self.scrollSecondContentView.bounds);
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    DTDimensionReturnModel *returnModel = [[DTDimensionReturnModel alloc] init];
    returnModel.level = 0;
    returnModel.sectionWidth = self.barY;

    if (data.ptListValue.count > 0) {

        BOOL sectionStart = YES;

        for (DTDimensionModel *model in data.ptListValue) {
            if (model.ptListValue.count > 0) {
                DTDimensionReturnModel *returnModel2 = [self layoutMainBars:model drawSubviews:isDraw];

                DTLog(@"ptName = %@ sectionWidth = %@ level = %@", model.ptName, @(returnModel2.sectionWidth / 15), @(returnModel2.level));

                CGFloat labelY = self.barY - returnModel2.sectionWidth - 2 * self.coordinateAxisCellWidth;

                if (sectionStart) {
                    returnModel.level = returnModel2.level + 1;
                    sectionStart = NO;
                } else {
                    if (returnModel2.level >= 0) {

                        if (isDraw) {
                            CGFloat y = labelY - 1 - self.coordinateAxisCellWidth;
                            CGFloat x = -returnModel2.level * self.coordinateAxisCellWidth;

                            CGFloat toX = axisYMax - (8 - returnModel2.level * 2) * self.coordinateAxisCellWidth;
                            CGFloat width = toX - x;

                            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, 2)];
                            line.backgroundColor = DTRGBColor(0x7b7b7b, 1);

                            [self.scrollMainContentView addSubview:line];
                        }
                    }
                }

                if (returnModel2.level == 0) {
                    self.barY += self.coordinateAxisCellWidth;
                }

            } else {


                if (!isDraw) {
                    __block BOOL exist = NO;
                    [self.levelLowestBarModels enumerateObjectsUsingBlock:^(DTDimensionBarModel *obj, NSUInteger idx, BOOL *stop) {
                        if ([obj.title isEqualToString:model.ptName]) {
                            exist = YES;
                            *stop = YES;
                        }
                    }];

                    if (!exist) {
                        DTDimensionBarModel *barModel = [[DTDimensionBarModel alloc] init];
                        barModel.title = model.ptName;
                        barModel.color = [self.colorManager getColor];
                        barModel.secondColor = [self.colorManager getLightColor:barModel.color];
                        [self.levelLowestBarModels addObject:barModel];
                    }
                }


                if (model.ptValue > self.maxX) {
                    self.maxX = model.ptValue;
                }


                if (isDraw) {

                    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
                    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

                    CGFloat width = self.coordinateAxisCellWidth * ((model.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * xMaxData.axisPosition;

                    DTBar *bar = [DTBar bar:DTBarOrientationLeft style:self.barBorderStyle];
                    bar.frame = CGRectMake(axisX, self.barY, width, barWidth);

                    DTDimensionBarModel *barModel = [self getBarModelByName:model.ptName];
                    bar.barColor = barModel.color;
                    bar.barBorderColor = barModel.secondColor;

                    [self.scrollMainContentView addSubview:bar];

                    if (self.showAnimation) {
                        [bar startAppearAnimation];
                    }
                }

                self.barY += barWidth + self.coordinateAxisCellWidth;
            }
        }
        returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
        DTLog(@"level = %@,  cell count = %@", @(returnModel.level), @(returnModel.sectionWidth / 15));
        return returnModel;

    } else {

        if (!isDraw) {
            __block BOOL exist = NO;
            [self.levelLowestBarModels enumerateObjectsUsingBlock:^(DTDimensionBarModel *obj, NSUInteger idx, BOOL *stop) {
                if ([obj.title isEqualToString:data.ptName]) {
                    exist = YES;
                    *stop = YES;
                }
            }];

            if (!exist) {
                DTDimensionBarModel *barModel = [[DTDimensionBarModel alloc] init];
                barModel.title = data.ptName;
                barModel.color = [self.colorManager getColor];
                barModel.secondColor = [self.colorManager getLightColor:barModel.color];
                [self.levelLowestBarModels addObject:barModel];
            }
        }

        if (isDraw) {
            DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
            DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

            CGFloat width = self.coordinateAxisCellWidth * ((data.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * xMaxData.axisPosition;

            DTBar *bar = [DTBar bar:DTBarOrientationLeft style:self.barBorderStyle];
            bar.frame = CGRectMake(axisX, self.barY, width, barWidth);

            DTDimensionBarModel *barModel = [self getBarModelByName:data.ptName];
            bar.barColor = barModel.color;
            bar.barBorderColor = barModel.secondColor;

            [self.scrollMainContentView addSubview:bar];

            if (self.showAnimation) {
                [bar startAppearAnimation];
            }
        }

        self.barY += barWidth + self.coordinateAxisCellWidth;
    }

    returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
    return returnModel;
}


- (DTDimensionBarModel *)getBarModelByName:(NSString *)name {
    __block DTDimensionBarModel *model = nil;
    [self.levelLowestBarModels enumerateObjectsUsingBlock:^(DTDimensionBarModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.title isEqualToString:name]) {
            model = obj;
            *stop = YES;
        }
    }];

    return model;
}


#pragma mark - public method

- (DTDimensionReturnModel *)calculate:(DTDimensionModel *)data {
    [self.levelLowestBarModels removeAllObjects];
    self.barY = 0;
    return [self layoutMainBars:data drawSubviews:NO];
}


#pragma mark - override

- (void)setCoordinateAxisInsets:(ChartEdgeInsets)coordinateAxisInsets {
    [super setCoordinateAxisInsets:coordinateAxisInsets];

    self.scrollView.frame = CGRectMake(0,
            CGRectGetMinY(self.contentView.frame),
            CGRectGetWidth(self.contentView.frame) + self.coordinateAxisInsets.left * self.coordinateAxisCellWidth,
            CGRectGetHeight(self.contentView.frame));
}

- (void)clearChartContent {

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self.scrollMainContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}

- (void)clearSecondChartContent {

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self.scrollSecondContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}


- (BOOL)drawXAxisLabels {
    if (self.xAxisLabelDatas.count < 2) {
        DTLog(@"Error: x轴标签数量小于2");
        return NO;
    }

    NSUInteger sectionCellCount = self.xAxisCellCount / (self.xAxisLabelDatas.count - 1);

    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i;

        if (data.hidden) {
            continue;
        }

        DTChartLabel *xLabel = [DTChartLabel chartLabel];
        if (self.xAxisLabelColor) {
            xLabel.textColor = self.xAxisLabelColor;
        }
        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.text = data.title;

        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: xLabel.font}];

        CGFloat x = (self.coordinateAxisInsets.left + data.axisPosition) * self.coordinateAxisCellWidth - size.width / 2;
        CGFloat y = CGRectGetMaxY(self.scrollView.frame);
        if (size.height < self.coordinateAxisCellWidth) {
            y += (self.coordinateAxisCellWidth - size.height) / 2;
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
    self.barY = self.yOffset;

    [self layoutMainBars:self.mainDimensionModel drawSubviews:YES];
}


- (BOOL)drawXSecondAxisLabels {
    return YES;
}

- (void)drawSecondValues {
}


- (void)drawChart {

    DTDimensionReturnModel *returnModel = [self calculate:self.mainDimensionModel];
    CGRect frame = CGRectMake(CGRectGetMinX(self.contentView.frame), 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    CGFloat realHeight = self.yOffset + returnModel.sectionWidth;
    if (returnModel.level == 0) {
        realHeight += self.coordinateAxisCellWidth;
    }
    frame.size.height = realHeight;
    frame.size.height = MAX(frame.size.height, CGRectGetHeight(self.contentView.frame));

    if (realHeight < frame.size.height) {
        self.yOffset = (CGRectGetHeight(frame) - realHeight) / 2;
        self.yOffset = (NSInteger) (self.yOffset / self.coordinateAxisCellWidth) * self.coordinateAxisCellWidth;
    }

    self.scrollMainContentView.frame = frame;

    self.scrollView.contentSize = frame.size;

    [super drawChart];

    [super drawSecondChart];
}


- (void)drawSecondChart {
    [self clearSecondChartContent];

    if ([self drawXSecondAxisLabels]) {

        [self drawSecondValues];
    }
}

#pragma mark - DTBarDelegate

- (void)_DTBarSelected:(DTBar *)bar {
    DTLog(@"%@", NSStringFromChartItemValue(bar.barData.itemValue));
}


@end
