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
#import "DTDimensionBar.h"
#import "DTChartToastView.h"
#import "DTChartScrollView.h"
#import "DTDimensionSectionLine.h"
#import "DTDimensionHeapBar.h"

@interface DTMeasureDimensionHorizontalBarChart ()

@property(nonatomic) DTChartScrollView *scrollView;

@property(nonatomic) UIView *scrollMainContentView;
@property(nonatomic) UIView *scrollSecondContentView;

/**
 * 计算DTBar的x坐标
 */
@property(nonatomic) CGFloat barY;

@property(nonatomic) UIView *yAxisLine;

@end


@implementation DTMeasureDimensionHorizontalBarChart

@synthesize barBorderStyle = _barBorderStyle;

- (void)initial {
    [super initial];

    self.userInteractionEnabled = YES;

    _barBorderStyle = DTBarBorderStyleNone;
    _barY = 0;
    _yOffset = 0;

    ChartEdgeInsets insets = self.coordinateAxisInsets;

    // scroll view
    _scrollView = [[DTChartScrollView alloc] init];
    WEAK_SELF;
    [_scrollView setScrollViewTouchBegin:^(CGPoint touchPoint) {
        [weakSelf processScrollViewTouch:touchPoint];
    }];
    [_scrollView setScrollViewTouchEnd:^{
        [weakSelf hideTouchMessage];
    }];
    _scrollView.frame = CGRectMake(0,
            insets.top * self.coordinateAxisCellWidth,
            CGRectGetWidth(self.bounds) - insets.right * self.coordinateAxisCellWidth,
            CGRectGetHeight(self.bounds) - (insets.bottom + insets.top) * self.coordinateAxisCellWidth);

    _scrollView.clipsToBounds = YES;

    _scrollMainContentView = [[UIView alloc] init];
    [_scrollView addSubview:_scrollMainContentView];

    _scrollSecondContentView = [[UIView alloc] init];
    [_scrollView addSubview:_scrollSecondContentView];

    [self addSubview:_scrollView];

    _yAxisLine = [UIView new];
    _yAxisLine.backgroundColor = DTRGBColor(0x7b7b7b, 1);
    [self addSubview:_yAxisLine];

    if (self.xAxisCellCount % 2 == 1) {
        self.coordinateAxisInsets = ChartEdgeInsetsMake(insets.left, insets.top, insets.right + 1, insets.bottom);
    } else {
        self.coordinateAxisInsets = insets;
    }


    self.colorManager = [DTColorManager randomManager];

    // 把提示view移到chart
    [self.toastView removeFromSuperview];
    [self addSubview:self.toastView];
}

- (NSMutableArray<DTDimensionBarModel *> *)levelLowestBarModels {
    if (!_levelLowestBarModels) {
        _levelLowestBarModels = [NSMutableArray array];
    }
    return _levelLowestBarModels;
}

- (NSMutableArray<DTDimensionBar *> *)secondChartBars {
    if (!_secondChartBars) {
        _secondChartBars = [NSMutableArray array];
    }
    return _secondChartBars;
}

#pragma mark - DTBarChartStyleHeap

/**
 * 第一度量
 * 遍历数据源所有值，绘制DTBarChartStyleHeap模式下的柱状图，会区别不同层级
 * @param data 数据源
 * @param isDraw NO：不绘制柱状体和坐标轴标签，纯遍历数据源里的所有值
 * @return 遍历结果
 */
- (DTDimensionReturnModel *)layoutHeapMainBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {
    if (data.ptListValue.count > 0 && data.ptListValue.firstObject.ptListValue.count > 0) {
        return [self layoutMainHighLevelHeapBars:data drawSubviews:isDraw];
    } else {
        return [self layoutMainLowLevelHeapBars:data drawSubviews:isDraw];
    }
}

/**
 * 第二度量
 * 遍历数据源所有值，绘制DTBarChartStyleHeap模式下的柱状图，会区别不同层级
 * @param data 数据源
 * @param isDraw NO：不绘制柱状体和坐标轴标签，纯遍历数据源里的所有值
 * @return 遍历结果
 */
- (DTDimensionReturnModel *)layoutHeapSecondBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {
    if (data.ptListValue.count > 0 && data.ptListValue.firstObject.ptListValue.count > 0) {
        return [self layoutSecondHighLevelHeapBars:data drawSubviews:isDraw];
    } else {
        return [self layoutSecondLowLevelHeapBars:data drawSubviews:isDraw];
    }
}


/**
 * 遍历层级大于2的数据源所有值，绘制DTBarChartStyleHeap模式下的柱状图
 * @param data 数据源
 * @param isDraw NO：不绘制柱状体和坐标轴标签，纯遍历数据源里的所有值
 * @return 遍历结果
 */
- (DTDimensionReturnModel *)layoutMainHighLevelHeapBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {
    CGFloat axisYMax = CGRectGetWidth(self.scrollMainContentView.bounds);
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    DTDimensionReturnModel *returnModel = [[DTDimensionReturnModel alloc] init];
    returnModel.level = 1;
    returnModel.sectionWidth = self.barY;

    if (data.ptListValue.count > 0) {

        BOOL sectionStart = YES;

        for (DTDimensionModel *model in data.ptListValue) {
            if (model.ptListValue.count > 0) {
                DTDimensionReturnModel *returnModel2 = [self layoutMainHighLevelHeapBars:model drawSubviews:isDraw];

                if (returnModel2.level > 0) {

                    // 将每一层级的DTDimensionModel存储在DTBar上
                    for (DTBar *bar in self.chartBars) {
                        if ([bar isKindOfClass:[DTDimensionBar class]]) {
                            DTDimensionBar *dimensionBar = (DTDimensionBar *) bar;

                            if (dimensionBar.dimensionModels.lastObject == model) {
                                NSMutableArray *models = [NSMutableArray arrayWithArray:dimensionBar.dimensionModels];
                                [models addObject:data];
                                dimensionBar.dimensionModels = models;
                            }
                        }
                    }

                    CGFloat labelY = self.barY - returnModel2.sectionWidth - 2 * self.coordinateAxisCellWidth;
                    CGFloat labelX = (self.coordinateAxisInsets.left - returnModel2.level - 1) * self.coordinateAxisCellWidth;

                    if (isDraw) {

                        CGFloat height;
                        if (returnModel2.level > 1) {
                            height = returnModel2.sectionWidth;
                        } else {
                            height = returnModel2.sectionWidth + self.coordinateAxisCellWidth;
                        }

                        DTChartLabel *titleLabel = [DTChartLabel chartLabel];
                        titleLabel.adjustsFontSizeToFitWidth = NO;
                        titleLabel.font = [UIFont systemFontOfSize:12];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        titleLabel.text = model.ptName;

                        titleLabel.frame = CGRectMake(labelX, labelY, self.coordinateAxisCellWidth, height);

                        [self.scrollView addSubview:titleLabel];
                    }

                    if (sectionStart) {
                        returnModel.level = returnModel2.level + 1;
                        sectionStart = NO;
                    } else {
                        if (returnModel2.level >= 0) {

                            if (isDraw) {
                                CGFloat y = labelY - 1 - self.coordinateAxisCellWidth;
                                CGFloat x = 0;

                                CGFloat toX = axisYMax - (8 - returnModel2.level * 2) * self.coordinateAxisCellWidth;
                                CGFloat width = toX - x;

                                DTDimensionSectionLine *sectionLine = [DTDimensionSectionLine layer];
                                sectionLine.frame = CGRectMake(x, y, width, 2);
                                [self.scrollMainContentView.layer addSublayer:sectionLine];

                            }
                        }
                    }

                    if (returnModel2.level == 1) {
                        self.barY += self.coordinateAxisCellWidth;
                    }

                } else {    // 加载柱状体

                    CGFloat sum = 0;
                    for (DTDimensionModel *item in model.ptListValue) {
                        sum += item.ptValue;

                        if (!isDraw) {
                            BOOL exist = NO;
                            for (DTDimensionBarModel *obj in self.levelLowestBarModels) {
                                if ([obj.title isEqualToString:item.ptName]) {
                                    exist = YES;
                                    break;
                                }
                            }

                            if (!exist) {
                                DTDimensionBarModel *barModel = [[DTDimensionBarModel alloc] init];
                                barModel.title = item.ptName;
                                barModel.color = [self.colorManager getColor];
                                barModel.secondColor = [self.colorManager getLightColor:barModel.color];
                                [self.levelLowestBarModels addObject:barModel];
                            }
                        }
                    }

                    if (sum > self.mainAxisMaxX) {
                        self.mainAxisMaxX = sum;
                    }


                    if (isDraw) {

                        // 柱状体对应坐标轴标签
                        DTChartLabel *titleLabel = [DTChartLabel chartLabel];
                        titleLabel.adjustsFontSizeToFitWidth = NO;
                        titleLabel.font = [UIFont systemFontOfSize:12];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        titleLabel.text = model.ptName;

                        CGRect bounding = [titleLabel.text boundingRectWithSize:CGSizeMake(0, self.coordinateAxisCellWidth)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName: titleLabel.font}
                                                                        context:nil];
                        CGFloat height = MAX(CGRectGetHeight(bounding), barWidth);
                        CGFloat labelY = self.barY + self.coordinateAxisCellWidth * self.coordinateAxisInsets.top;
                        CGFloat labelX = (self.coordinateAxisInsets.left - returnModel2.level - 1) * self.coordinateAxisCellWidth;
                        titleLabel.frame = CGRectMake(labelX, labelY + barWidth / 2 - height / 2, self.coordinateAxisCellWidth, height);
                        titleLabel.textColor = DTColorGray;
                        [self.scrollView addSubview:titleLabel];

                        DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
                        DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

                        NSMutableArray *models = [NSMutableArray array];
                        [models addObject:model];
                        [models addObject:data];

                        DTDimensionHeapBar *bar = [DTDimensionHeapBar heapBar:DTBarOrientationRight];
                        bar.dimensionModels = models;

                        bar.frame = CGRectMake(CGRectGetMinX(self.contentView.bounds), self.barY, 0, barWidth);

                        for (NSUInteger i = 0; i < model.ptListValue.count; ++i) {
                            DTDimensionModel *item = model.ptListValue[i];
                            CGFloat itemLength = self.coordinateAxisCellWidth * ((item.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMaxData.axisPosition - xMinData.axisPosition);

                            DTDimensionBarModel *barModel = [self getBarModelByName:item.ptName];
                            [bar appendData:item barLength:itemLength barColor:barModel.color needLayout:i == model.ptListValue.count - 1];
                        }

                        [self.scrollMainContentView addSubview:bar];
                        [self.chartBars addObject:bar];

                        if (self.showAnimation) {
                            [bar startAppearAnimation];
                        }
                    }

                    self.barY += barWidth + self.coordinateAxisCellWidth;
                }


            } else {

                returnModel.level = 0;

            }
        }
        returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
        return returnModel;

    }

    returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
    return returnModel;
}

/**
 * 遍历层级小于等于2的数据源所有值，绘制DTBarChartStyleHeap模式下的柱状图
 * @param data 数据源
 * @param isDraw NO：不绘制柱状体和坐标轴标签，纯遍历数据源里的所有值
 * @return 遍历结果
 */
- (DTDimensionReturnModel *)layoutMainLowLevelHeapBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    DTDimensionReturnModel *returnModel = [[DTDimensionReturnModel alloc] init];
    returnModel.level = 1;
    returnModel.sectionWidth = self.barY;


    CGFloat sum = 0;
    for (DTDimensionModel *item in data.ptListValue) {
        sum += item.ptValue;

        if (!isDraw) {
            BOOL exist = NO;
            for (DTDimensionBarModel *obj in self.levelLowestBarModels) {
                if ([obj.title isEqualToString:item.ptName]) {
                    exist = YES;
                    break;
                }
            }

            if (!exist) {
                DTDimensionBarModel *barModel = [[DTDimensionBarModel alloc] init];
                barModel.title = item.ptName;
                barModel.color = [self.colorManager getColor];
                barModel.secondColor = [self.colorManager getLightColor:barModel.color];
                [self.levelLowestBarModels addObject:barModel];
            }
        }
    }

    if (sum > self.mainAxisMaxX) {
        self.mainAxisMaxX = sum;
    }


    if (isDraw) {
        // 柱状体对应坐标轴标签
        DTChartLabel *titleLabel = [DTChartLabel chartLabel];
        titleLabel.adjustsFontSizeToFitWidth = NO;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = data.ptName;

        CGRect bounding = [titleLabel.text boundingRectWithSize:CGSizeMake(0, self.coordinateAxisCellWidth)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: titleLabel.font}
                                                        context:nil];
        CGFloat height = MAX(CGRectGetHeight(bounding), barWidth);
        CGFloat labelY = self.barY + self.coordinateAxisCellWidth * self.coordinateAxisInsets.top;
        CGFloat labelX = ((NSInteger) self.coordinateAxisInsets.left - returnModel.level) * self.coordinateAxisCellWidth;
        titleLabel.frame = CGRectMake(labelX, labelY + barWidth / 2 - height / 2, self.coordinateAxisCellWidth, height);
        titleLabel.textColor = DTColorGray;
        [self.scrollView addSubview:titleLabel];


        DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
        DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

        NSMutableArray *models = [NSMutableArray array];
        [models addObject:data];

        DTDimensionHeapBar *bar = [DTDimensionHeapBar heapBar:DTBarOrientationRight];
        bar.dimensionModels = models;

        bar.frame = CGRectMake(CGRectGetMinX(self.contentView.bounds), self.barY, 0, barWidth);

        for (NSUInteger i = 0; i < data.ptListValue.count; ++i) {
            DTDimensionModel *item = data.ptListValue[i];
            CGFloat itemLength = self.coordinateAxisCellWidth * ((item.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMaxData.axisPosition - xMinData.axisPosition);

            DTDimensionBarModel *barModel = [self getBarModelByName:item.ptName];
            [bar appendData:item barLength:itemLength barColor:barModel.color needLayout:i == data.ptListValue.count - 1];
        }
        [self.scrollMainContentView addSubview:bar];
        [self.chartBars addObject:bar];

        if (self.showAnimation) {
            [bar startAppearAnimation];
        }
    }

    self.barY += barWidth + self.coordinateAxisCellWidth;

    returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
    return returnModel;
}

/**
 * 第一度量
 * 遍历层级大于2的数据源所有值，绘制DTBarChartStyleHeap模式下的柱状图
 * @param data 数据源
 * @param isDraw NO：不绘制柱状体和坐标轴标签，纯遍历数据源里的所有值
 * @return 遍历结果
 */
- (DTDimensionReturnModel *)layoutSecondHighLevelHeapBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {
    CGFloat axisYMax = CGRectGetWidth(self.scrollSecondContentView.bounds);
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    DTDimensionReturnModel *returnModel = [[DTDimensionReturnModel alloc] init];
    returnModel.level = 1;
    returnModel.sectionWidth = self.barY;

    if (data.ptListValue.count > 0) {

        BOOL sectionStart = YES;

        for (DTDimensionModel *model in data.ptListValue) {
            if (model.ptListValue.count > 0) {
                DTDimensionReturnModel *returnModel2 = [self layoutSecondHighLevelHeapBars:model drawSubviews:isDraw];

                if (returnModel2.level > 0) {

                    // 将每一层级的DTDimensionModel存储在DTBar上
                    for (DTBar *bar in self.chartBars) {
                        if ([bar isKindOfClass:[DTDimensionBar class]]) {
                            DTDimensionBar *dimensionBar = (DTDimensionBar *) bar;

                            if (dimensionBar.dimensionModels.lastObject == model) {
                                NSMutableArray *models = [NSMutableArray arrayWithArray:dimensionBar.dimensionModels];
                                [models addObject:data];
                                dimensionBar.dimensionModels = models;
                            }
                        }
                    }

                    CGFloat labelY = self.barY - returnModel2.sectionWidth - 2 * self.coordinateAxisCellWidth;

                    if (sectionStart) {
                        returnModel.level = returnModel2.level + 1;
                        sectionStart = NO;
                    } else {
                        if (returnModel2.level >= 0) {

                            if (isDraw) {
                                CGFloat y = labelY - 1 - self.coordinateAxisCellWidth;
                                CGFloat x = axisYMax;

                                CGFloat toX = (8 - returnModel2.level * 2) * self.coordinateAxisCellWidth;
                                CGFloat width = ABS(toX - x);

                                DTDimensionSectionLine *sectionLine = [DTDimensionSectionLine layer];
                                sectionLine.frame = CGRectMake(x - width, y, width, 2);
                                [self.scrollSecondContentView.layer addSublayer:sectionLine];

                            }
                        }
                    }

                    if (returnModel2.level == 1) {
                        self.barY += self.coordinateAxisCellWidth;
                    }

                } else {    // 加载柱状体

                    CGFloat sum = 0;
                    for (DTDimensionModel *item in model.ptListValue) {
                        sum += item.ptValue;

                        if (!isDraw) {
                            BOOL exist = NO;
                            for (DTDimensionBarModel *obj in self.levelLowestBarModels) {
                                if ([obj.title isEqualToString:item.ptName]) {
                                    exist = YES;
                                    break;
                                }
                            }

                            if (!exist) {
                                DTDimensionBarModel *barModel = [[DTDimensionBarModel alloc] init];
                                barModel.title = item.ptName;
                                barModel.color = [self.colorManager getColor];
                                barModel.secondColor = [self.colorManager getLightColor:barModel.color];
                                [self.levelLowestBarModels addObject:barModel];
                            }
                        }
                    }

                    if (sum > self.secondAxisMaxX) {
                        self.secondAxisMaxX = sum;
                    }


                    if (isDraw) {

                        // 柱状体
                        DTAxisLabelData *xMaxData = self.xSecondAxisLabelDatas.lastObject;
                        DTAxisLabelData *xMinData = self.xSecondAxisLabelDatas.firstObject;

                        NSMutableArray *models = [NSMutableArray array];
                        [models addObject:model];
                        [models addObject:data];

                        DTDimensionHeapBar *bar = [DTDimensionHeapBar heapBar:DTBarOrientationLeft];
                        bar.dimensionModels = models;

                        bar.frame = CGRectMake(axisYMax, self.barY, 0, barWidth);

                        for (NSUInteger i = 0; i < model.ptListValue.count; ++i) {
                            DTDimensionModel *item = model.ptListValue[i];
                            CGFloat itemLength = self.coordinateAxisCellWidth * ((item.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMinData.axisPosition - xMaxData.axisPosition);

                            DTDimensionBarModel *barModel = [self getBarModelByName:item.ptName];
                            [bar appendData:item barLength:itemLength barColor:barModel.color needLayout:i == model.ptListValue.count - 1];
                        }

                        [self.scrollSecondContentView addSubview:bar];
                        [self.secondChartBars addObject:bar];

                        if (self.showAnimation) {
                            [bar startAppearAnimation];
                        }
                    }

                    self.barY += barWidth + self.coordinateAxisCellWidth;
                }


            } else {

                returnModel.level = 0;

            }
        }
        returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
        return returnModel;

    }

    returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
    return returnModel;
}

/**
 * 第二度量
 * 遍历层级小于等于2的数据源所有值，绘制DTBarChartStyleHeap模式下的柱状图
 * @param data 数据源
 * @param isDraw NO：不绘制柱状体和坐标轴标签，纯遍历数据源里的所有值
 * @return 遍历结果
 */
- (DTDimensionReturnModel *)layoutSecondLowLevelHeapBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {
    CGFloat axisYMax = CGRectGetWidth(self.scrollSecondContentView.bounds);
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    DTDimensionReturnModel *returnModel = [[DTDimensionReturnModel alloc] init];
    returnModel.level = 1;
    returnModel.sectionWidth = self.barY;


    CGFloat sum = 0;
    for (DTDimensionModel *item in data.ptListValue) {
        sum += item.ptValue;

        if (!isDraw) {
            BOOL exist = NO;
            for (DTDimensionBarModel *obj in self.levelLowestBarModels) {
                if ([obj.title isEqualToString:item.ptName]) {
                    exist = YES;
                    break;
                }
            }

            if (!exist) {
                DTDimensionBarModel *barModel = [[DTDimensionBarModel alloc] init];
                barModel.title = item.ptName;
                barModel.color = [self.colorManager getColor];
                barModel.secondColor = [self.colorManager getLightColor:barModel.color];
                [self.levelLowestBarModels addObject:barModel];
            }
        }
    }

    if (sum > self.secondAxisMaxX) {
        self.secondAxisMaxX = sum;
    }


    if (isDraw) {

        // 柱状体
        DTAxisLabelData *xMaxData = self.xSecondAxisLabelDatas.lastObject;
        DTAxisLabelData *xMinData = self.xSecondAxisLabelDatas.firstObject;

        NSMutableArray *models = [NSMutableArray array];
        [models addObject:data];

        DTDimensionHeapBar *bar = [DTDimensionHeapBar heapBar:DTBarOrientationLeft];
        bar.dimensionModels = models;

        bar.frame = CGRectMake(axisYMax, self.barY, 0, barWidth);

        for (NSUInteger i = 0; i < data.ptListValue.count; ++i) {
            DTDimensionModel *item = data.ptListValue[i];
            CGFloat itemLength = self.coordinateAxisCellWidth * ((item.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMinData.axisPosition - xMaxData.axisPosition);

            DTDimensionBarModel *barModel = [self getBarModelByName:item.ptName];
            [bar appendData:item barLength:itemLength barColor:barModel.color needLayout:i == data.ptListValue.count - 1];
        }
        [self.scrollSecondContentView addSubview:bar];
        [self.secondChartBars addObject:bar];

        if (self.showAnimation) {
            [bar startAppearAnimation];
        }
    }

    self.barY += barWidth + self.coordinateAxisCellWidth;

    returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
    return returnModel;
}


#pragma mark - DTBarChartStyleStartingLine

/**
 * 遍历数据源所有值，绘制柱状体和坐标轴标签
 * @param data 数据源
 * @param isDraw NO：不绘制柱状体和坐标轴标签，纯遍历数据源里的所有值
 * @return 遍历结果
 */
- (DTDimensionReturnModel *)layoutStartingLineMainBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {

    CGFloat axisX = 0;
    CGFloat axisYMax = CGRectGetWidth(self.contentView.bounds) / 2;
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    DTDimensionReturnModel *returnModel = [[DTDimensionReturnModel alloc] init];
    returnModel.level = 0;
    returnModel.sectionWidth = self.barY;

    if (data.ptListValue.count > 0) {

        BOOL sectionStart = YES;

        for (DTDimensionModel *model in data.ptListValue) {
            if (model.ptListValue.count > 0) {
                DTDimensionReturnModel *returnModel2 = [self layoutStartingLineMainBars:model drawSubviews:isDraw];

                DTLog(@"ptName = %@ sectionWidth = %@ level = %@", model.ptName, @(returnModel2.sectionWidth / 15), @(returnModel2.level));

                // 将每一层级的DTDimensionModel存储在DTBar上
                for (DTBar *bar in self.chartBars) {
                    if ([bar isKindOfClass:[DTDimensionBar class]]) {
                        DTDimensionBar *dimensionBar = (DTDimensionBar *) bar;

                        if (dimensionBar.dimensionModels.lastObject == model) {
                            NSMutableArray *models = [NSMutableArray arrayWithArray:dimensionBar.dimensionModels];
                            [models addObject:data];
                            dimensionBar.dimensionModels = models;
                        }
                    }
                }


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
                            CGFloat x = axisX;

                            CGFloat toX = axisYMax - (8 - returnModel2.level * 2) * self.coordinateAxisCellWidth;
                            CGFloat width = toX - x;

                            DTDimensionSectionLine *sectionLine = [DTDimensionSectionLine layer];
                            sectionLine.frame = CGRectMake(x, y, width, 2);

                            [self.scrollMainContentView.layer addSublayer:sectionLine];
                        }
                    }
                }

                if (returnModel2.level == 0) {
                    self.barY += self.coordinateAxisCellWidth;
                }

            } else {


                if (!isDraw) {
                    BOOL exist = NO;
                    for (DTDimensionBarModel *obj in self.levelLowestBarModels) {
                        if ([obj.title isEqualToString:model.ptName]) {
                            exist = YES;
                            break;
                        }
                    }

                    if (!exist) {
                        DTDimensionBarModel *barModel = [[DTDimensionBarModel alloc] init];
                        barModel.title = model.ptName;
                        barModel.color = [self.colorManager getColor];
                        barModel.secondColor = [self.colorManager getLightColor:barModel.color];
                        [self.levelLowestBarModels addObject:barModel];
                    }
                }


                if (model.ptValue > self.mainAxisMaxX) {
                    self.mainAxisMaxX = model.ptValue;
                }


                if (isDraw) {

                    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
                    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

                    CGFloat width = self.coordinateAxisCellWidth * ((model.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMaxData.axisPosition - xMinData.axisPosition);

                    NSMutableArray *models = [NSMutableArray array];
                    [models addObject:model];
                    [models addObject:data];

                    DTDimensionBar *bar = [DTDimensionBar bar:DTBarOrientationRight style:self.barBorderStyle];
                    bar.dimensionModels = models;

                    bar.frame = CGRectMake(axisX, self.barY, width, barWidth);

                    DTDimensionBarModel *barModel = [self getBarModelByName:model.ptName];
                    bar.barColor = barModel.color;
                    bar.barBorderColor = barModel.secondColor;

                    [self.scrollMainContentView addSubview:bar];
                    [self.chartBars addObject:bar];

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

            BOOL exist = NO;
            for (DTDimensionBarModel *obj in self.levelLowestBarModels) {
                if ([obj.title isEqualToString:data.ptName]) {
                    exist = YES;
                    break;
                }
            }


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

            CGFloat width = self.coordinateAxisCellWidth * ((data.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMaxData.axisPosition - xMinData.axisPosition);

            NSMutableArray *models = [NSMutableArray array];
            [models addObject:data];

            DTDimensionBar *bar = [DTDimensionBar bar:DTBarOrientationRight style:self.barBorderStyle];
            bar.dimensionModels = models;

            bar.frame = CGRectMake(axisX, self.barY, width, barWidth);

            DTDimensionBarModel *barModel = [self getBarModelByName:data.ptName];
            bar.barColor = barModel.color;
            bar.barBorderColor = barModel.secondColor;

            [self.scrollMainContentView addSubview:bar];
            [self.chartBars addObject:bar];

            if (self.showAnimation) {
                [bar startAppearAnimation];
            }
        }

        self.barY += barWidth + self.coordinateAxisCellWidth;
    }

    returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
    return returnModel;
}

- (DTDimensionReturnModel *)layoutStartingLineSecondBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {

    CGFloat axisX = CGRectGetMaxX(self.scrollSecondContentView.bounds);
    CGFloat axisYMax = CGRectGetWidth(self.contentView.bounds) / 2;
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    DTDimensionReturnModel *returnModel = [[DTDimensionReturnModel alloc] init];
    returnModel.level = 0;
    returnModel.sectionWidth = self.barY;

    if (data.ptListValue.count > 0) {

        BOOL sectionStart = YES;

        for (DTDimensionModel *model in data.ptListValue) {
            if (model.ptListValue.count > 0) {
                DTDimensionReturnModel *returnModel2 = [self layoutStartingLineSecondBars:model drawSubviews:isDraw];

                DTLog(@"ptName = %@ sectionWidth = %@ level = %@", model.ptName, @(returnModel2.sectionWidth / 15), @(returnModel2.level));

                // 将每一层级的DTDimensionModel存储在DTBar上
                for (DTDimensionBar *bar in self.secondChartBars) {
                    if (bar.dimensionModels.lastObject == model) {
                        NSMutableArray *models = [NSMutableArray arrayWithArray:bar.dimensionModels];
                        [models addObject:data];
                        bar.dimensionModels = models;
                    }
                }

                CGFloat labelY = self.barY - returnModel2.sectionWidth - 2 * self.coordinateAxisCellWidth;

                if (sectionStart) {
                    returnModel.level = returnModel2.level + 1;
                    sectionStart = NO;
                } else {
                    if (returnModel2.level >= 0) {

                        if (isDraw) {
                            CGFloat y = labelY - 1 - self.coordinateAxisCellWidth;
                            CGFloat x = axisX;

                            CGFloat width = axisYMax - (8 - returnModel2.level * 2) * self.coordinateAxisCellWidth;
                            x -= width;

                            DTDimensionSectionLine *sectionLine = [DTDimensionSectionLine layer];
                            sectionLine.frame = CGRectMake(x, y, width, 2);

                            [self.scrollSecondContentView.layer addSublayer:sectionLine];
                        }
                    }
                }

                if (returnModel2.level == 0) {
                    self.barY += self.coordinateAxisCellWidth;
                }

            } else {


                if (!isDraw) {

                    BOOL exist = NO;
                    for (DTDimensionBarModel *obj in self.levelLowestBarModels) {
                        if ([obj.title isEqualToString:model.ptName]) {
                            exist = YES;
                            break;
                        }
                    }


                    if (!exist) {
                        DTDimensionBarModel *barModel = [[DTDimensionBarModel alloc] init];
                        barModel.title = model.ptName;
                        barModel.color = [self.colorManager getColor];
                        barModel.secondColor = [self.colorManager getLightColor:barModel.color];
                        [self.levelLowestBarModels addObject:barModel];
                    }
                }

                if (model.ptValue > self.secondAxisMaxX) {
                    self.secondAxisMaxX = model.ptValue;
                }

                if (isDraw) {

                    DTAxisLabelData *xMaxData = self.xSecondAxisLabelDatas.lastObject;
                    DTAxisLabelData *xMinData = self.xSecondAxisLabelDatas.firstObject;

                    CGFloat width = self.coordinateAxisCellWidth * ((model.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMinData.axisPosition - xMaxData.axisPosition);

                    NSMutableArray *models = [NSMutableArray array];
                    [models addObject:model];
                    [models addObject:data];

                    DTDimensionBar *bar = [DTDimensionBar bar:DTBarOrientationLeft style:self.barBorderStyle];
                    bar.dimensionModels = models;

                    bar.frame = CGRectMake(axisX - width, self.barY, width, barWidth);

                    DTDimensionBarModel *barModel = [self getBarModelByName:model.ptName];
                    bar.barColor = barModel.color;
                    bar.barBorderColor = barModel.secondColor;

                    [self.scrollSecondContentView addSubview:bar];
                    [self.secondChartBars addObject:bar];

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
            BOOL exist = NO;
            for (DTDimensionBarModel *obj in self.levelLowestBarModels) {
                if ([obj.title isEqualToString:data.ptName]) {
                    exist = YES;
                    break;
                }
            }

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

            CGFloat width = self.coordinateAxisCellWidth * ((data.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMinData.axisPosition - xMaxData.axisPosition);

            NSMutableArray *models = [NSMutableArray array];
            [models addObject:data];

            DTDimensionBar *bar = [DTDimensionBar bar:DTBarOrientationLeft style:self.barBorderStyle];
            bar.dimensionModels = models;
            bar.frame = CGRectMake(axisX - width, self.barY, width, barWidth);

            DTDimensionBarModel *barModel = [self getBarModelByName:data.ptName];
            bar.barColor = barModel.color;
            bar.barBorderColor = barModel.secondColor;

            [self.scrollSecondContentView addSubview:bar];
            [self.secondChartBars addObject:bar];

            if (self.showAnimation) {
                [bar startAppearAnimation];
            }
        }

        self.barY += barWidth + self.coordinateAxisCellWidth;
    }

    returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
    return returnModel;
}


#pragma mark - private method


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

/**
 * 处理scrollView的触摸提示
 * @param point 触摸点
 */
- (void)processScrollViewTouch:(CGPoint)point {
    if (CGRectContainsPoint(self.scrollMainContentView.frame, point)) {
        for (DTBar *bar in self.chartBars) {
            if ([bar isKindOfClass:[DTDimensionBar class]] && point.y >= CGRectGetMinY(bar.frame) && point.y <= CGRectGetMaxY(bar.frame)) {

                DTDimensionBar *dimensionBar = (DTDimensionBar *) bar;

                [self generateMessage:dimensionBar locaion:CGPointMake(point.x, CGRectGetMidY(bar.frame) - self.scrollView.contentOffset.y + self.coordinateAxisInsets.top * self.coordinateAxisCellWidth)];

                break;
            }
        }


    } else if (CGRectContainsPoint(self.scrollSecondContentView.frame, point)) {
        for (DTDimensionBar *bar in self.secondChartBars) {
            if (point.y >= CGRectGetMinY(bar.frame) && point.y <= CGRectGetMaxY(bar.frame)) {
                [self generateMessage:bar locaion:CGPointMake(point.x, CGRectGetMidY(bar.frame) - self.scrollView.contentOffset.y + self.coordinateAxisInsets.top * self.coordinateAxisCellWidth)];
                break;
            }
        }
    }
}

/**
 * 生成触摸提示文字
 * @param bar 触摸点对应的DTBar
 * @param point 触摸点转换成提示框所在的父view点
 */
- (void)generateMessage:(DTDimensionBar *)bar locaion:(CGPoint)point {

    NSMutableString *message = [NSMutableString string];
    if (self.barChartStyle == DTBarChartStyleStartingLine) {
        [bar.dimensionModels enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(DTDimensionModel *model, NSUInteger idx, BOOL *stop) {
            if (model.ptName) {
                [message appendString:model.ptName];

                if (idx > 0) {
                    [message appendString:@"\n"];
                } else {
                    if (floorf(model.ptValue) != model.ptValue) {   // 有小数
                        [message appendString:[NSString stringWithFormat:@"\n%.1f", model.ptValue]];
                    } else {
                        [message appendString:[NSString stringWithFormat:@"\n%@", @(model.ptValue)]];
                    }

                }
            }
        }];
    } else if (self.barChartStyle == DTBarChartStyleHeap) {
        DTDimensionModel *model = bar.dimensionModels.firstObject;
        [model.ptListValue enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(DTDimensionModel *obj, NSUInteger idx, BOOL *stop) {
            if (obj.ptName) {
                [message appendString:obj.ptName];
                if (floorf(obj.ptValue) != obj.ptValue) {   // 有小数
                    [message appendString:[NSString stringWithFormat:@"\n%.1f", obj.ptValue]];
                } else {
                    [message appendString:[NSString stringWithFormat:@"\n%@", @(obj.ptValue)]];
                }

                if (idx > 0) {
                    [message appendString:@"\n"];
                }
            }
        }];
    }

    if (message.length > 0) {
        [self showTouchMessage:message touchPoint:point];
    }
}


- (void)showTouchMessage:(NSString *)message touchPoint:(CGPoint)point {
    [self.touchSelectedLine removeFromSuperlayer];
    [self.layer addSublayer:self.touchSelectedLine];
    self.touchSelectedLine.hidden = NO;

    CGRect frame = CGRectMake(CGRectGetMinX(self.scrollView.frame) + CGRectGetMinX(self.scrollSecondContentView.frame),
            point.y,
            CGRectGetWidth(self.scrollMainContentView.frame) + CGRectGetWidth(self.scrollSecondContentView.frame),
            1);

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.touchSelectedLine.frame = frame;
    [CATransaction commit];

    [self.toastView show:message location:point];
}

- (void)hideTouchMessage {
    [self.toastView hide];
    self.touchSelectedLine.hidden = YES;
}


#pragma mark - public method

- (DTDimensionReturnModel *)calculateMain:(DTDimensionModel *)data {
    [self.levelLowestBarModels removeAllObjects];
    self.barY = 0;
    self.mainAxisMaxX = 0;
    if (self.barChartStyle == DTBarChartStyleStartingLine) {
        return [self layoutStartingLineMainBars:data drawSubviews:NO];
    } else if (self.barChartStyle == DTBarChartStyleHeap) {
        return [self layoutHeapMainBars:data drawSubviews:NO];
    } else {
        return nil;
    }
}

- (DTDimensionReturnModel *)calculateSecond:(DTDimensionModel *)data {
    self.secondAxisMaxX = 0;
    if (self.barChartStyle == DTBarChartStyleStartingLine) {
        return [self layoutStartingLineSecondBars:data drawSubviews:NO];
    } else if (self.barChartStyle == DTBarChartStyleHeap) {
        return [self layoutHeapSecondBars:data drawSubviews:NO];
    } else {
        return nil;
    }
}

- (void)drawChart:(DTDimensionReturnModel *)returnModel {

    self.yOffset = 0;

    if (!returnModel) {
        returnModel = [self calculateMain:self.mainDimensionModel];
    }

    CGRect frame = self.scrollMainContentView.frame;
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
    frame.origin = self.scrollSecondContentView.frame.origin;
    self.scrollSecondContentView.frame = frame;

    self.scrollView.contentSize = frame.size;

    [super drawChart];

    [self drawSecondChart];

    self.scrollView.selectable = self.valueSelectable;
}


#pragma mark - override

- (void)setCoordinateAxisInsets:(ChartEdgeInsets)coordinateAxisInsets {
    [super setCoordinateAxisInsets:coordinateAxisInsets];

    if (self.xAxisCellCount % 2 == 1) {
        ChartEdgeInsets insets = self.coordinateAxisInsets;
        self.coordinateAxisInsets = ChartEdgeInsetsMake(insets.left, insets.top, insets.right + 1, insets.bottom);
        return;
    }

    self.scrollView.frame = CGRectMake(0,
            CGRectGetMinY(self.contentView.frame),
            CGRectGetWidth(self.contentView.frame) + coordinateAxisInsets.left * self.coordinateAxisCellWidth,
            CGRectGetHeight(self.contentView.frame));

    self.scrollSecondContentView.frame = CGRectMake(coordinateAxisInsets.left * self.coordinateAxisCellWidth, 0,
            CGRectGetWidth(self.contentView.frame) / 2, CGRectGetHeight(self.contentView.frame));
    self.scrollMainContentView.frame = CGRectMake(CGRectGetMaxX(self.scrollSecondContentView.frame),
            CGRectGetMinY(self.scrollSecondContentView.frame),
            CGRectGetWidth(self.scrollSecondContentView.frame),
            CGRectGetHeight(self.scrollSecondContentView.frame));

    [self bringSubviewToFront:self.yAxisLine];
    self.yAxisLine.frame = CGRectMake(CGRectGetMidX(self.contentView.frame) - 1, CGRectGetMinY(self.contentView.frame), 2, CGRectGetHeight(self.contentView.frame));
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
    [self.scrollSecondContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];

    NSMutableArray<CALayer *> *layers = self.scrollMainContentView.layer.sublayers.mutableCopy;
    [layers addObjectsFromArray:self.scrollSecondContentView.layer.sublayers];
    [layers enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTDimensionSectionLine class]]) {
            [obj removeFromSuperlayer];
        }
    }];

    [self.chartBars removeAllObjects];
    [self.secondChartBars removeAllObjects];
}


- (BOOL)drawXAxisLabels {
    if (self.xAxisLabelDatas.count < 2) {
        DTLog(@"Error: 第一度量x轴标签数量小于2");
        return NO;
    }

    NSUInteger sectionCellCount = self.xAxisCellCount / 2 / (self.xAxisLabelDatas.count - 1);

    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i + self.xAxisCellCount / 2;

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

        if (i == 0) {
            x += size.width / 2;
            size.width += self.coordinateAxisCellWidth;
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

    if (self.barChartStyle == DTBarChartStyleStartingLine) {
        [self layoutStartingLineMainBars:self.mainDimensionModel drawSubviews:YES];
    } else if (self.barChartStyle == DTBarChartStyleHeap) {
        [self layoutHeapMainBars:self.mainDimensionModel drawSubviews:YES];
    }

}


- (BOOL)drawXSecondAxisLabels {
    if (self.xAxisLabelDatas.count < 2) {
        DTLog(@"Error: 第二度量x轴标签数量小于2");
        return NO;
    }

    NSUInteger sectionCellCount = self.xAxisCellCount / 2 / (self.xSecondAxisLabelDatas.count - 1);

    for (NSUInteger i = 0; i < self.xSecondAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xSecondAxisLabelDatas[i];
        data.axisPosition = self.xAxisCellCount / 2 - sectionCellCount * i;

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

        if (i == 0) {
            x -= size.width / 2;
            size.width += self.coordinateAxisCellWidth;
            x -= self.coordinateAxisCellWidth;
        }

        xLabel.frame = (CGRect) {CGPointMake(x, y), size};

        [self addSubview:xLabel];
    }

    return YES;
}

- (void)drawSecondValues {
    self.barY = self.yOffset;

    if (self.barChartStyle == DTBarChartStyleStartingLine) {
        [self layoutStartingLineSecondBars:self.secondDimensionModel drawSubviews:YES];
    } else if (self.barChartStyle == DTBarChartStyleHeap) {
        [self layoutHeapSecondBars:self.secondDimensionModel drawSubviews:YES];
    }

}

- (void)drawChart {
    [self drawChart:nil];
}

- (void)drawSecondChart {
    if ([self drawXSecondAxisLabels]) {

        [self drawSecondValues];
    }
}


@end
