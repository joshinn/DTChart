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

    self.colorManager = [DTColorManager randomManager];
}

- (NSMutableArray<DTDimensionBarModel *> *)levelLowestBarModels {
    if (!_levelLowestBarModels) {
        _levelLowestBarModels = [NSMutableArray array];
    }
    return _levelLowestBarModels;
}

#pragma mark - private method


- (DTDimensionReturnModel *)layoutBars:(DTDimensionModel *)data drawSubviews:(BOOL)isDraw {

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
                DTDimensionReturnModel *returnModel2 = [self layoutBars:model drawSubviews:isDraw];

                DTLog(@"ptName = %@ sectionWidth = %@ level = %@", model.ptName, @(returnModel2.sectionWidth / 15), @(returnModel2.level));

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

                            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, 2, height)];
                            line.backgroundColor = DTRGBColor(0x7b7b7b, 1);

                            [self.contentView addSubview:line];
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

                    DTBar *bar = [DTBar bar:DTBarOrientationUp style:self.barBorderStyle];
                    bar.frame = CGRectMake(self.barX, axisY - height, barWidth, height);

                    DTDimensionBarModel *barModel = [self getBarModelByName:model.ptName];
                    bar.barColor = barModel.color;
                    bar.barBorderColor = barModel.secondColor;

                    [self.contentView addSubview:bar];

                    if(self.showAnimation){
                        [bar startAppearAnimation];
                    }
                }

                self.barX += barWidth + self.coordinateAxisCellWidth;
            }
        }
        returnModel.sectionWidth = self.barX - returnModel.sectionWidth - self.coordinateAxisCellWidth * 2;
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
            CGFloat height = data.ptValue / 50 * axisYMax;

            DTBar *bar = [DTBar bar:DTBarOrientationUp style:self.barBorderStyle];
            bar.frame = CGRectMake(self.barX, axisY - height, barWidth, height);

            DTDimensionBarModel *barModel = [self getBarModelByName:data.ptName];
            bar.barColor = barModel.color;
            bar.barBorderColor = barModel.secondColor;

            [self.contentView addSubview:bar];

            if(self.showAnimation){
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
    self.barX = 0;
    return [self layoutBars:data drawSubviews:NO];
}


#pragma mark - override

- (void)clearChartContent {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
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

    [self layoutBars:self.dimensionModel drawSubviews:YES];
}

- (void)drawChart {

    if (self.levelLowestBarModels.count == 0) {
        [self calculate:self.dimensionModel];
    }

    [super drawChart];

}


#pragma mark - DTBarDelegate

- (void)_DTBarSelected:(DTBar *)bar {
    DTLog(@"%@", NSStringFromChartItemValue(bar.barData.itemValue));
}


@end
