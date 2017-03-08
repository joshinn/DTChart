//
//  DTDimensionVerticalBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/24.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionVerticalBarChart.h"
#import "DTChartLabel.h"
#import "DTDimensionReturnModel.h"
#import "DTDimensionModel.h"
#import "DTDimensionBarModel.h"
#import "DTColor.h"
#import "DTChartToastView.h"
#import "DTDimensionBar.h"
#import "DTDimensionSectionLine.h"
#import "DTDimensionHeapBar.h"

@interface DTDimensionVerticalBarChart ()

/**
 * 计算DTBar的x坐标
 */
@property(nonatomic) CGFloat barX;

@end

@implementation DTDimensionVerticalBarChart

@synthesize barBorderStyle = _barBorderStyle;

- (void)initial {
    [super initial];

    _barBorderStyle = DTBarBorderStyleSidesBorder;
    _barX = 0;
    self.barChartStyle = DTBarChartStyleStartingLine;

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
 * 绘制DTBarChartStyleHeap模式下的柱状图
 * @param data 数据源
 * @param isDraw 是否绘制view。NO时，相当于计算整个图表的y轴最大值、frame等信息
 * @return x轴层级信息
 */
- (DTDimensionReturnModel *)layoutHeapBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {

    CGFloat axisY = CGRectGetMaxY(self.contentView.bounds);
    CGFloat axisYMax = CGRectGetHeight(self.contentView.bounds);
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    DTDimensionReturnModel *returnModel = [[DTDimensionReturnModel alloc] init];
    returnModel.level = 1;
    returnModel.sectionWidth = self.barX;

    if (data.ptListValue.count > 0) {

        BOOL sectionStart = YES;

        for (DTDimensionModel *model in data.ptListValue) {
            if (model.ptListValue.count > 0) {
                DTDimensionReturnModel *returnModel2 = [self layoutHeapBars:model drawSubviews:isDraw];

                if (returnModel2.level > 0) {
//                DTLog(@"ptName = %@ sectionWidth = %@ level = %@", model.ptName, @(returnModel2.sectionWidth / 15), @(returnModel2.level));

                    // 将每一层级的DTDimensionModel存储在DTBar上
                    for (DTBar *bar in self.chartBars) {
                        if ([bar isKindOfClass:[DTDimensionHeapBar class]]) {
                            DTDimensionHeapBar *dimensionBar = (DTDimensionHeapBar *) bar;

                            if (dimensionBar.dimensionModels.lastObject == model) {
                                NSMutableArray *models = [NSMutableArray arrayWithArray:dimensionBar.dimensionModels];
                                [models addObject:data];
                                dimensionBar.dimensionModels = models;
                            }
                        }
                    }


                    CGFloat labelX = self.barX - returnModel2.sectionWidth - self.coordinateAxisCellWidth * (2 - (NSInteger) self.coordinateAxisInsets.left);

                    if (isDraw) {
                        CGFloat labelY = axisY + (returnModel2.level + self.coordinateAxisInsets.top) * self.coordinateAxisCellWidth;
                        CGFloat width;
                        if (returnModel2.level > 1) {
                            width = returnModel2.sectionWidth;
                        } else {
                            width = returnModel2.sectionWidth + self.coordinateAxisCellWidth;
                        }

                        DTChartLabel *titleLabel = [DTChartLabel chartLabel];
                        titleLabel.font = [UIFont systemFontOfSize:12];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        titleLabel.frame = CGRectMake(labelX, labelY, width, self.coordinateAxisCellWidth);
                        titleLabel.text = model.ptName;
                        if (returnModel2.level == 0) {
                            titleLabel.textColor = DTColorGray;
                        }

                        [self addSubview:titleLabel];
                    }

                    if (sectionStart) {
                        returnModel.level = returnModel2.level + 1;
                        sectionStart = NO;
                    } else {
                        if (returnModel2.level >= 0) {

                            if (isDraw) {
                                CGFloat x = labelX - 1 - self.coordinateAxisCellWidth * (1 + self.coordinateAxisInsets.left);
                                CGFloat y = axisY - (axisYMax - (8 - returnModel2.level * 2) * self.coordinateAxisCellWidth);

                                CGFloat height;

                                if (returnModel2.level == 0) {
                                    height = axisY - y;
                                } else {
                                    height = axisY + (returnModel2.level + 1) * self.coordinateAxisCellWidth - y;
                                }

                                DTDimensionSectionLine *sectionLine = [DTDimensionSectionLine layer];
                                sectionLine.frame = CGRectMake(x, y, 2, height);
                                [self.contentView.layer addSublayer:sectionLine];
                            }
                        }
                    }

                    if (returnModel2.level == 1) {
                        self.barX += self.coordinateAxisCellWidth;
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

                    if (sum > self.maxY) {
                        self.maxY = sum;
                    }


                    if (isDraw) {

                        // 柱状体对应坐标轴标签
                        DTChartLabel *titleLabel = [DTChartLabel chartLabel];
                        titleLabel.font = [UIFont systemFontOfSize:12];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        titleLabel.text = model.ptName;
                        CGRect bounding = [titleLabel.text boundingRectWithSize:CGSizeMake(0, self.coordinateAxisCellWidth)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName: titleLabel.font}
                                                                        context:nil];
                        CGFloat width = MAX(CGRectGetWidth(bounding), barWidth);
                        CGFloat labelX = self.barX + self.coordinateAxisCellWidth * self.coordinateAxisInsets.left;
                        titleLabel.frame = CGRectMake(labelX + barWidth / 2 - width / 2, axisY, width, self.coordinateAxisCellWidth);
                        titleLabel.textColor = DTColorGray;
                        [self addSubview:titleLabel];


                        // heap bar
                        DTAxisLabelData *yMaxData = self.yAxisLabelDatas.lastObject;
                        DTAxisLabelData *yMinData = self.yAxisLabelDatas.firstObject;

                        NSMutableArray *models = [NSMutableArray array];
                        [models addObject:model];
                        [models addObject:data];

                        DTDimensionHeapBar *bar = [DTDimensionHeapBar bar:DTBarOrientationUp style:DTBarBorderStyleNone];
                        bar.dimensionModels = models;

                        bar.frame = CGRectMake(self.barX, CGRectGetMaxY(self.contentView.bounds), barWidth, 0);

                        for (NSUInteger i = 0; i < model.ptListValue.count; ++i) {
                            DTDimensionModel *item = model.ptListValue[i];
                            CGFloat height = self.coordinateAxisCellWidth * ((item.ptValue - yMinData.value) / (yMaxData.value - yMinData.value)) * (yMaxData.axisPosition - yMinData.axisPosition);

                            DTDimensionBarModel *barModel = [self getBarModelByName:item.ptName];
                            [bar appendData:item barLength:height barColor:barModel.color needLayout:i == model.ptListValue.count - 1];
                        }


                        DTDimensionBarModel *barModel = [self getBarModelByName:model.ptName];
                        bar.barColor = barModel.color;
                        bar.barBorderColor = barModel.secondColor;

                        [self.contentView addSubview:bar];
                        [self.chartBars addObject:bar];

                        if (self.showAnimation) {
                            [bar startAppearAnimation];
                        }
                    }

                    self.barX += barWidth + self.coordinateAxisCellWidth;

                }

            } else {

                returnModel.level = 0;
//                returnModel.level = -1;
            }
        }
        returnModel.sectionWidth = self.barX - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
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
            CGFloat height = data.ptValue / 50 * axisYMax;
            NSMutableArray *models = [NSMutableArray array];
            [models addObject:data];

            DTDimensionHeapBar *bar = [DTDimensionHeapBar bar:DTBarOrientationUp style:DTBarBorderStyleNone];
            bar.dimensionModels = models;

            bar.frame = CGRectMake(self.barX, axisY - height, barWidth, height);

            DTDimensionBarModel *barModel = [self getBarModelByName:data.ptName];
            bar.barColor = barModel.color;
            bar.barBorderColor = barModel.secondColor;

            [self.contentView addSubview:bar];
            [self.chartBars addObject:bar];

            if (self.showAnimation) {
                [bar startAppearAnimation];
            }
        }

        self.barX += barWidth + self.coordinateAxisCellWidth;
//        DTLog(@"barY = %@", @(self.barY));
    }

    returnModel.sectionWidth = self.barX - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
    return returnModel;
}

/**
 * 绘制DTBarChartStyleStartingLine模式下的柱状图
 * @param data 数据源
 * @param isDraw 是否绘制view。NO时，相当于计算整个图表的y轴最大值、frame等信息
 * @return x轴层级信息
 */
- (DTDimensionReturnModel *)layoutStartingLineBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {

    CGFloat axisY = CGRectGetMaxY(self.contentView.bounds);
    CGFloat axisYMax = CGRectGetHeight(self.contentView.bounds);
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    DTDimensionReturnModel *returnModel = [[DTDimensionReturnModel alloc] init];
    returnModel.level = 0;
    returnModel.sectionWidth = self.barX;

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


                CGFloat labelX = self.barX - returnModel2.sectionWidth - self.coordinateAxisCellWidth * (2 - (NSInteger) self.coordinateAxisInsets.left);

                if (isDraw) {
                    CGFloat labelY = axisY + (returnModel2.level + self.coordinateAxisInsets.top) * self.coordinateAxisCellWidth;
                    CGFloat width;
                    if (returnModel2.level > 0) {
                        width = returnModel2.sectionWidth;
                    } else {
                        width = returnModel2.sectionWidth + self.coordinateAxisCellWidth;
                    }

                    DTChartLabel *titleLabel = [DTChartLabel chartLabel];
                    titleLabel.font = [UIFont systemFontOfSize:12];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    titleLabel.frame = CGRectMake(labelX, labelY, width, self.coordinateAxisCellWidth);
                    titleLabel.text = model.ptName;
                    if (returnModel2.level == 0) {
                        titleLabel.textColor = DTColorGray;
                    }

                    [self addSubview:titleLabel];
                }

                if (sectionStart) {
                    returnModel.level = returnModel2.level + 1;
                    sectionStart = NO;
                } else {
                    if (returnModel2.level >= 0) {

                        if (isDraw) {
                            CGFloat x = labelX - 1 - self.coordinateAxisCellWidth * (1 + self.coordinateAxisInsets.left);
                            CGFloat y = axisY - (axisYMax - (8 - returnModel2.level * 2) * self.coordinateAxisCellWidth);

                            CGFloat height;

                            if (returnModel2.level == 0) {
                                height = axisY - y;
                            } else {
                                height = axisY + (returnModel2.level + 1) * self.coordinateAxisCellWidth - y;
                            }

                            DTDimensionSectionLine *sectionLine = [DTDimensionSectionLine layer];
                            sectionLine.frame = CGRectMake(x, y, 2, height);
                            [self.contentView.layer addSublayer:sectionLine];
                        }
                    }
                }

                if (returnModel2.level == 0) {
                    self.barX += self.coordinateAxisCellWidth;
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


                if (model.ptValue > self.maxY) {
                    self.maxY = model.ptValue;
                }


                if (isDraw) {
                    DTAxisLabelData *yMaxData = self.yAxisLabelDatas.lastObject;
                    DTAxisLabelData *yMinData = self.yAxisLabelDatas.firstObject;

                    CGFloat height = self.coordinateAxisCellWidth * ((model.ptValue - yMinData.value) / (yMaxData.value - yMinData.value)) * (yMaxData.axisPosition - yMinData.axisPosition);

                    NSMutableArray *models = [NSMutableArray array];
                    [models addObject:model];
                    [models addObject:data];

                    DTDimensionBar *bar = [DTDimensionBar bar:DTBarOrientationUp style:self.barBorderStyle];
                    bar.dimensionModels = models;
                    bar.frame = CGRectMake(self.barX, axisY - height, barWidth, height);

                    DTDimensionBarModel *barModel = [self getBarModelByName:model.ptName];
                    bar.barColor = barModel.color;
                    bar.barBorderColor = barModel.secondColor;

                    [self.contentView addSubview:bar];
                    [self.chartBars addObject:bar];

                    if (self.showAnimation) {
                        [bar startAppearAnimation];
                    }
                }

                self.barX += barWidth + self.coordinateAxisCellWidth;
            }
        }
        returnModel.sectionWidth = self.barX - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
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
            CGFloat height = data.ptValue / 50 * axisYMax;
            NSMutableArray *models = [NSMutableArray array];
            [models addObject:data];

            DTDimensionBar *bar = [DTDimensionBar bar:DTBarOrientationUp style:self.barBorderStyle];
            bar.dimensionModels = models;

            bar.frame = CGRectMake(self.barX, axisY - height, barWidth, height);

            DTDimensionBarModel *barModel = [self getBarModelByName:data.ptName];
            bar.barColor = barModel.color;
            bar.barBorderColor = barModel.secondColor;

            [self.contentView addSubview:bar];
            [self.chartBars addObject:bar];

            if (self.showAnimation) {
                [bar startAppearAnimation];
            }
        }


        self.barX += barWidth + self.coordinateAxisCellWidth;
//        DTLog(@"barY = %@", @(self.barY));
    }

    returnModel.sectionWidth = self.barX - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
    return returnModel;
}


- (DTDimensionBarModel *)getBarModelByName:(NSString *)name {
    DTDimensionBarModel *model = nil;
    for (DTDimensionBarModel *obj in self.levelLowestBarModels) {
        if ([obj.title isEqualToString:name]) {
            model = obj;
            break;
        }
    }

    return model;
}


- (void)showTouchMessage:(NSString *)message touchPoint:(CGPoint)point {
    [self.touchSelectedLine removeFromSuperlayer];
    [self.contentView.layer addSublayer:self.touchSelectedLine];
    self.touchSelectedLine.hidden = NO;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.touchSelectedLine.frame = CGRectMake(point.x, 0, 1, CGRectGetHeight(self.contentView.bounds));
    [CATransaction commit];

    [self.toastView show:message location:point];
}

- (void)hideTouchMessage {
    [self.toastView hide];
    self.touchSelectedLine.hidden = YES;
}

#pragma mark - touch event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.valueSelectable) {
        [super touchesBegan:touches withEvent:event];
    } else {

        [self touchKeyPoint:touches];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.valueSelectable) {
        [super touchesMoved:touches withEvent:event];
    } else {

        [self touchKeyPoint:touches];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.valueSelectable) {
        [super touchesEnded:touches withEvent:event];
    } else {
        [self hideTouchMessage];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.valueSelectable) {
        [super touchesCancelled:touches withEvent:event];
    } else {
        [self hideTouchMessage];
    }
}

- (void)touchKeyPoint:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];

    BOOL containsPoint = NO;
    for (NSUInteger i = 0; i < self.chartBars.count; ++i) {
        DTBar *bar = self.chartBars[i];
        if (![bar isKindOfClass:[DTDimensionBar class]]) {
            return;

        }

        DTDimensionBar *dimensionBar = (DTDimensionBar *) bar;

        if (touchPoint.x >= CGRectGetMinX(bar.frame) && touchPoint.x <= CGRectGetMaxX(bar.frame)) {
            containsPoint = YES;

            NSMutableString *message = [NSMutableString string];
            if (self.barChartStyle == DTBarChartStyleStartingLine) {
                [dimensionBar.dimensionModels enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(DTDimensionModel *model, NSUInteger idx, BOOL *stop) {
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
                DTDimensionModel *model = dimensionBar.dimensionModels.firstObject;
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
                [self showTouchMessage:message touchPoint:CGPointMake(CGRectGetMidX(bar.frame), touchPoint.y)];
            }

            break;
        }
    }

    if (!containsPoint) {
        [self hideTouchMessage];
    }
}


#pragma mark - public method

- (DTDimensionReturnModel *)calculate:(DTDimensionModel *)data {
    [self.levelLowestBarModels removeAllObjects];
    self.barX = 0;

    if (self.barChartStyle == DTBarChartStyleStartingLine) {
        return [self layoutStartingLineBars:data drawSubviews:NO];
    } else if (self.barChartStyle == DTBarChartStyleHeap) {
        return [self layoutHeapBars:data drawSubviews:NO];
    } else {
        return nil;
    }
}


#pragma mark - override

- (void)clearChartContent {
    [super clearChartContent];

    NSArray<CALayer *> *layers = self.contentView.layer.sublayers.copy;
    [layers enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTDimensionSectionLine class]]) {
            [obj removeFromSuperlayer];
        }
    }];

    [self.chartBars removeAllObjects];
}

- (BOOL)drawXAxisLabels {
    return YES;
}

- (BOOL)drawYAxisLabels {
    if (self.yAxisLabelDatas.count < 2) {
        DTLog(@"Error: y轴标签数量小于2");
        return NO;
    }

    NSUInteger sectionCellCount = self.yAxisCellCount / (self.yAxisLabelDatas.count - 1);

    for (NSUInteger i = 0; i < self.yAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.yAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i;

        if (data.hidden) {
            continue;
        }

        DTChartLabel *yLabel = [DTChartLabel chartLabel];
        if (self.yAxisLabelColor) {
            yLabel.textColor = self.yAxisLabelColor;
        }

        yLabel.textAlignment = NSTextAlignmentRight;
        yLabel.text = data.title;

        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: yLabel.font}];

        CGFloat x = CGRectGetMinX(self.contentView.frame) - size.width;
        CGFloat y = (self.coordinateAxisInsets.top + self.yAxisCellCount - data.axisPosition) * self.coordinateAxisCellWidth - size.height / 2;

        yLabel.frame = (CGRect) {CGPointMake(x, y), size};

        [self addSubview:yLabel];
    }

    return YES;
}

- (void)drawValues {
    self.barX = self.xOffset;

    if (self.barChartStyle == DTBarChartStyleStartingLine) {
        [self layoutStartingLineBars:self.dimensionModel drawSubviews:YES];
    } else if (self.barChartStyle == DTBarChartStyleHeap) {
        [self layoutHeapBars:self.dimensionModel drawSubviews:YES];
    }
}

- (void)drawChart {

    if (self.levelLowestBarModels.count == 0) {
        [self calculate:self.dimensionModel];
    }

    [super drawChart];

}


@end
