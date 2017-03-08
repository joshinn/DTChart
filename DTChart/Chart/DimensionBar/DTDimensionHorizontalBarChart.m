//
//  DTDimensionHorizontalBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/28.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionHorizontalBarChart.h"
#import "DTDimensionModel.h"
#import "DTDimensionReturnModel.h"
#import "DTDimensionBarModel.h"
#import "DTChartLabel.h"
#import "DTColor.h"
#import "DTDimensionSectionLine.h"
#import "DTDimensionBar.h"
#import "DTChartToastView.h"
#import "DTChartScrollView.h"
#import "DTDimensionHeapBar.h"

@interface DTDimensionHorizontalBarChart ()

@property(nonatomic) DTChartScrollView *scrollView;

@property(nonatomic) UIView *scrollContentView;

/**
 * 计算DTBar的x坐标
 */
@property(nonatomic) CGFloat barY;
/**
 * y轴第一个柱状体偏移量，默认0，让所有柱状体居中时使用
 */
@property(nonatomic) CGFloat yOffset;

@end

@implementation DTDimensionHorizontalBarChart

@synthesize barBorderStyle = _barBorderStyle;

- (void)initial {
    [super initial];

    self.userInteractionEnabled = YES;

    _barBorderStyle = DTBarBorderStyleSidesBorder;
    _barY = 0;
    _yOffset = self.coordinateAxisCellWidth;


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
            self.coordinateAxisInsets.top * self.coordinateAxisCellWidth,
            CGRectGetWidth(self.bounds),
            CGRectGetHeight(self.bounds) - (self.coordinateAxisInsets.bottom + self.coordinateAxisInsets.top) * self.coordinateAxisCellWidth);

    _scrollView.clipsToBounds = YES;

    _scrollContentView = [UIView new];
    [_scrollView addSubview:_scrollContentView];

    [self addSubview:_scrollView];

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

#pragma mark - private method

/**
 * 遍历数据源所有值，绘制DTBarChartStyleHeap模式下的柱状图，会区别不同层级
 * @param data 数据源
 * @param isDraw NO：不绘制柱状体和坐标轴标签，纯遍历数据源里的所有值
 * @return 遍历结果
 */
- (DTDimensionReturnModel *)layoutHeapBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {
    if (data.ptListValue.count > 0 && data.ptListValue.firstObject.ptListValue.count > 0) {
        return [self layoutHighLevelHeapBars:data drawSubviews:isDraw];
    } else {
        return [self layoutLowLevelHeapBars:data drawSubviews:isDraw];
    }
}

/**
 * 遍历层级大于2的数据源所有值，绘制DTBarChartStyleHeap模式下的柱状图
 * @param data 数据源
 * @param isDraw NO：不绘制柱状体和坐标轴标签，纯遍历数据源里的所有值
 * @return 遍历结果
 */
- (DTDimensionReturnModel *)layoutHighLevelHeapBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {
    CGFloat axisYMax = CGRectGetWidth(self.contentView.bounds);
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    DTDimensionReturnModel *returnModel = [[DTDimensionReturnModel alloc] init];
    returnModel.level = 1;
    returnModel.sectionWidth = self.barY;

    if (data.ptListValue.count > 0) {

        BOOL sectionStart = YES;

        for (DTDimensionModel *model in data.ptListValue) {
            if (model.ptListValue.count > 0) {
                DTDimensionReturnModel *returnModel2 = [self layoutHighLevelHeapBars:model drawSubviews:isDraw];

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
                                CGFloat x = -returnModel2.level * self.coordinateAxisCellWidth;

                                CGFloat toX = axisYMax - (8 - returnModel2.level * 2) * self.coordinateAxisCellWidth;
                                CGFloat width = toX - x;


                                DTDimensionSectionLine *sectionLine = [DTDimensionSectionLine layer];
                                sectionLine.frame = CGRectMake(x, y, width, 2);
                                [self.scrollContentView.layer addSublayer:sectionLine];

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

                    if (sum > self.maxX) {
                        self.maxX = sum;
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

                        [self.scrollContentView addSubview:bar];
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
- (DTDimensionReturnModel *)layoutLowLevelHeapBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {
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

    if (sum > self.maxX) {
        self.maxX = sum;
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
        [self.scrollContentView addSubview:bar];
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
 * 遍历数据源所有值，绘制DTBarChartStyleStartingLine模式下的柱状图
 * @param data 数据源
 * @param isDraw NO：不绘制柱状体和坐标轴标签，纯遍历数据源里的所有值
 * @return 遍历结果
 */
- (DTDimensionReturnModel *)layoutStartingLineBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {

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
                DTDimensionReturnModel *returnModel2 = [self layoutStartingLineBars:model drawSubviews:isDraw];

//                DTLog(@"ptName = %@ sectionWidth = %@ level = %@", model.ptName, @(returnModel2.sectionWidth / 15), @(returnModel2.level));

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

                    if (returnModel2.level == 0) {
                        titleLabel.textAlignment = NSTextAlignmentLeft;
                        titleLabel.textColor = DTColorGray;
                        titleLabel.frame = CGRectMake(axisX + self.coordinateAxisInsets.left * self.coordinateAxisCellWidth,
                                _barY - returnModel2.sectionWidth - self.coordinateAxisCellWidth * 3,
                                CGRectGetWidth(self.contentView.bounds), self.coordinateAxisCellWidth);
                    } else {
                        titleLabel.frame = CGRectMake(labelX, labelY, self.coordinateAxisCellWidth, height);
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


                            DTDimensionSectionLine *sectionLine = [DTDimensionSectionLine layer];
                            sectionLine.frame = CGRectMake(x, y, width, 2);
                            [self.scrollContentView.layer addSublayer:sectionLine];

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

                    [self.scrollContentView addSubview:bar];
                    [self.chartBars addObject:bar];

                    if (self.showAnimation) {
                        [bar startAppearAnimation];
                    }
                }

                self.barY += barWidth + self.coordinateAxisCellWidth;
            }
        }
        returnModel.sectionWidth = self.barY - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
//        DTLog(@"level = %@,  cell count = %@", @(returnModel.level), @(returnModel.sectionWidth / 15));
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

            CGFloat width = self.coordinateAxisCellWidth * ((data.ptValue - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMaxData.axisPosition - xMinData.axisPosition);

            NSMutableArray *models = [NSMutableArray array];
            [models addObject:data];

            DTDimensionBar *bar = [DTDimensionBar bar:DTBarOrientationRight style:self.barBorderStyle];
            bar.dimensionModels = models;

            bar.frame = CGRectMake(axisX, self.barY, width, barWidth);

            DTDimensionBarModel *barModel = [self getBarModelByName:data.ptName];
            bar.barColor = barModel.color;
            bar.barBorderColor = barModel.secondColor;

            [self.scrollContentView addSubview:bar];
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
    if (CGRectContainsPoint(self.scrollContentView.frame, point)) {
        for (DTBar *bar in self.chartBars) {
            if ([bar isKindOfClass:[DTDimensionBar class]] && point.y >= CGRectGetMinY(bar.frame) && point.y <= CGRectGetMaxY(bar.frame)) {

                DTDimensionBar *dimensionBar = (DTDimensionBar *) bar;

                [self generateMessage:dimensionBar locaion:CGPointMake(point.x, CGRectGetMidY(bar.frame) - self.scrollView.contentOffset.y + self.coordinateAxisInsets.top * self.coordinateAxisCellWidth)];

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

    CGRect frame = CGRectMake(CGRectGetMinX(self.scrollView.frame) + CGRectGetMinX(self.scrollContentView.frame),
            point.y,
            CGRectGetWidth(self.scrollContentView.frame),
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

- (DTDimensionReturnModel *)calculate:(DTDimensionModel *)data {
    [self.levelLowestBarModels removeAllObjects];
    self.barY = 0;

    if (self.barChartStyle == DTBarChartStyleStartingLine) {
        return [self layoutStartingLineBars:data drawSubviews:NO];
    } else if (self.barChartStyle == DTBarChartStyleHeap) {
        return [self layoutHeapBars:data drawSubviews:NO];
    } else {
        return nil;
    }
}

- (void)drawChart:(DTDimensionReturnModel *)returnModel {
    self.yOffset = self.coordinateAxisCellWidth;

    if (!returnModel) {
        returnModel = [self calculate:self.dimensionModel];
    }

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

    self.scrollContentView.frame = frame;

    self.scrollView.contentSize = frame.size;

    [super drawChart];

    self.scrollView.selectable = self.valueSelectable;
}


#pragma mark - override

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
    [self.scrollContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTBar class]]) {
            [obj removeFromSuperview];
        }
    }];

    NSArray<CALayer *> *layers = self.scrollContentView.layer.sublayers.copy;
    [layers enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTDimensionSectionLine class]]) {
            [obj removeFromSuperlayer];
        }
    }];

    [self.chartBars removeAllObjects];
}

- (void)setCoordinateAxisInsets:(ChartEdgeInsets)coordinateAxisInsets {
    [super setCoordinateAxisInsets:coordinateAxisInsets];

    self.scrollView.frame = CGRectMake(0,
            CGRectGetMinY(self.contentView.frame),
            CGRectGetWidth(self.contentView.frame) + self.coordinateAxisInsets.left * self.coordinateAxisCellWidth,
            CGRectGetHeight(self.contentView.frame));
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

    if (self.barChartStyle == DTBarChartStyleStartingLine) {
        [self layoutStartingLineBars:self.dimensionModel drawSubviews:YES];
    } else if (self.barChartStyle == DTBarChartStyleHeap) {
        [self layoutHeapBars:self.dimensionModel drawSubviews:YES];
    }
}

- (void)drawChart {
    [self drawChart:nil];
}


@end
