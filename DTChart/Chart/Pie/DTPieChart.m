//
//  DTPieChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/26.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTPieChart.h"
#import "DTPiePart.h"
#import "DTChartBlockModel.h"
#import "DTChartToastView.h"

@interface DTPieChart ()


@property(nonatomic) CAShapeLayer *containerLayer;
/**
 * 存储pie图每个组成部分的百分比
 */
@property(nonatomic, readwrite) NSMutableArray<NSNumber *> *percentages;

@property(nonatomic) CGFloat radius;
/**
 * 上一个选择的pie图组成部分的序号
 */
@property(nonatomic) NSInteger prevSelectedIndex;

@end

@implementation DTPieChart

@synthesize originPoint = _originPoint;
@synthesize colorManager = _colorManager;

- (void)initial {
    [super initial];

    self.coordinateAxisInsets = ChartEdgeInsetsMake(0, 0, 0, 0);
    _originPoint = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds));


    _selectBorderWidth = 1;
    _prevSelectedIndex = -1;
    self.pieRadius = MIN(self.xAxisCellCount, self.yAxisCellCount) / 2;
}


- (CAShapeLayer *)containerLayer {
    if (!_containerLayer) {
        _containerLayer = [CAShapeLayer layer];
        [self.contentView.layer addSublayer:_containerLayer];
    }
    return _containerLayer;
}

- (NSMutableArray<NSNumber *> *)percentages {
    if (!_percentages) {
        _percentages = [NSMutableArray<NSNumber *> array];
    }
    return _percentages;
}

- (void)setPieRadius:(CGFloat)pieRadius {
    _pieRadius = pieRadius;

    _radius = pieRadius * self.coordinateAxisCellWidth;
}

- (DTColorManager *)colorManager {
    if (!_colorManager) {
        _colorManager = [DTColorManager randomManager];
    }
    return _colorManager;
}

- (void)setHighlightTitle:(NSString *)highlightTitle {
    _highlightTitle = highlightTitle;

    [self deselectedAllLayers];

    if (highlightTitle) {
        DTChartSingleData *sData = self.multiData.firstObject;
        for (NSUInteger idx = 0; idx < sData.itemValues.count; ++idx) {
            DTChartItemData *itemData = sData.itemValues[idx];
            if ([itemData.title isEqualToString:highlightTitle]) {
                [self drawSelectedLayer:idx selected:YES];
                break;
            }
        }
    }
}

#pragma mark - private method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.touchMode == DTPieChartTouchModeOneAfterOne) {
        [self processTouchOneAfterOne:touches isMoving:NO];
    } else {
        [self processTouchOneComplete:touches];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.touchMode == DTPieChartTouchModeOneAfterOne) {
        [self processTouchOneAfterOne:touches isMoving:YES];
    } else {
        [self processTouchOneComplete:touches];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (self.touchMode == DTPieChartTouchModeOneComplete) {
        self.prevSelectedIndex = -1;
        [self deselectedAllLayers];
        [self.toastView hide];
    }
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (self.touchMode == DTPieChartTouchModeOneComplete) {
        self.prevSelectedIndex = -1;
        [self deselectedAllLayers];
        [self.toastView hide];
    }
}

- (void)processTouchOneAfterOne:(NSSet *)touches isMoving:(BOOL)moving {
    if (!self.valueSelectable) {
        return;
    }

    UITouch *touch = [touches anyObject];

    CGPoint touchPointInChart = [touch locationInView:self.contentView];
    if (CGPointGetDistance(touchPointInChart, self.originPoint) > self.radius) {
        return;
    }

    CGFloat angle = (CGFloat) atan2(touchPointInChart.y - self.originPoint.y, touchPointInChart.x - self.originPoint.x);
    CGFloat percent = 0;
    if (angle < -M_PI_2) {
        percent = (CGFloat) ((2 * M_PI + angle + M_PI_2) / M_PI / 2);
    } else {
        percent = (CGFloat) ((angle + M_PI_2) / M_PI / 2);
    }

    __block CGFloat sum = 0;
    __block NSInteger index = -1;
    [self.percentages enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
        if (percent > sum && percent <= number.floatValue + sum) {
            index = idx;
            *stop = YES;
        }
        sum += number.floatValue;
    }];

    if (index == -1) {
        return;
    }

    if (moving) {
        if (self.prevSelectedIndex >= 0 && self.prevSelectedIndex != index) {
            self.prevSelectedIndex = index;
            if (self.pieChartTouchBlock) {

                [self drawSelectedLayer:(NSUInteger) index selected:YES];
                self.pieChartTouchBlock((NSUInteger) index);
            }
        }
    } else {
        if (self.prevSelectedIndex != index) {
            self.prevSelectedIndex = index;
            if (self.pieChartTouchBlock) {

                [self drawSelectedLayer:(NSUInteger) index selected:YES];
                self.pieChartTouchBlock((NSUInteger) index);
            }
        } else {
            if (self.pieChartTouchCancelBlock) {
                self.prevSelectedIndex = -1;
                [self drawSelectedLayer:(NSUInteger) index selected:NO];
                self.pieChartTouchCancelBlock((NSUInteger) index);
            }
        }
    }
}

- (void)processTouchOneComplete:(NSSet *)touches {
    if (!self.valueSelectable) {
        return;
    }

    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.toastView.superview];

    CGPoint touchPointInChart = [touch locationInView:self.contentView];
    if (CGPointGetDistance(touchPointInChart, self.originPoint) > self.radius) {
        return;
    }

    CGFloat angle = (CGFloat) atan2(touchPointInChart.y - self.originPoint.y, touchPointInChart.x - self.originPoint.x);
    CGFloat percent = 0;
    if (angle < -M_PI_2) {
        percent = (CGFloat) ((2 * M_PI + angle + M_PI_2) / M_PI / 2);
    } else {
        percent = (CGFloat) ((angle + M_PI_2) / M_PI / 2);
    }

    __block CGFloat sum = 0;
    __block NSInteger index = -1;
    [self.percentages enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
        if (percent > sum && percent <= number.floatValue + sum) {
            index = idx;
            *stop = YES;
        }
        sum += number.floatValue;
    }];

    if (index == -1) {
        return;
    }

    if (self.prevSelectedIndex != index) {
        self.prevSelectedIndex = index;
        if (self.pieChartTouchOneCompleteBlock) {

            [self drawSelectedLayer:(NSUInteger) index selected:YES];
            DTChartSingleData *sData = self.multiData.firstObject;
            DTChartItemData *itemData = sData.itemValues[(NSUInteger) index];
            sum = 0;
            for (DTChartItemData *item in sData.itemValues) {
                sum += item.itemValue.y;
            }

            NSString *message = self.pieChartTouchOneCompleteBlock((NSUInteger) index, itemData.title, itemData.itemValue.y, sum);

            if (message) {
                [self showTouchMessage:message touchPoint:touchPoint];
            }
        }
    }
}

- (void)deselectedAllLayers {
    [self.containerLayer.sublayers enumerateObjectsUsingBlock:^(CALayer *layer, NSUInteger idx, BOOL *stop) {
        if ([layer isKindOfClass:[DTPiePart class]]) {
            DTPiePart *part = (DTPiePart *) layer;
            if (part.isSelected) {
                part.selected = NO;
            }
        }
    }];
}

- (void)drawSelectedLayer:(NSUInteger)index selected:(BOOL)select {

    [self.containerLayer.sublayers enumerateObjectsUsingBlock:^(CALayer *layer, NSUInteger idx, BOOL *stop) {
        if ([layer isKindOfClass:[DTPiePart class]]) {
            DTPiePart *part = (DTPiePart *) layer;

            if (part.index == index) {
                part.selected = select;

            } else {
                part.selected = NO;
            }

        }
    }];
}

- (DTPiePart *)generatePiePartWithPartColor:(UIColor *)partColor
                                borderColor:(UIColor *)borderColor
                                     radius:(CGFloat)radius
                                     center:(CGPoint)center
                            startPercentage:(CGFloat)startPercentage
                              endPercentage:(CGFloat)endPercentage {

    DTPiePart *partLayer = [DTPiePart piePartCenter:center radius:radius startPercentage:startPercentage endPercentage:endPercentage];
    partLayer.partColor = partColor;
    partLayer.selectColor = borderColor;
    partLayer.selectBorderWidth = self.selectBorderWidth * self.coordinateAxisCellWidth;
    DTLog(@"startPercentage = %@ endPercentage = %@ partColor = %@", @(startPercentage), @(endPercentage), partColor);
    return partLayer;
}

- (void)startAppearAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;

    [self.containerLayer.mask addAnimation:animation forKey:@"circleAnimation"];
}

- (void)startDisappearAnimation {

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @1;
    animation.toValue = @0;
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = NO;

    [self.containerLayer.mask addAnimation:animation forKey:@"eraseCircleAnimation"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clearChartContent];
    });
}

/**
 * 绘制指定单组数据的pie chart
 * @note DTChartSingleData里的每个itemValue.y作为pie chart的组成部分
 */
- (void)drawSingleDataChart {

    DTChartSingleData *sData = self.multiData.firstObject;
    if (sData.itemValues.count == 0) {
        return;
    }

    NSMutableArray<UIColor *> *existColors = [NSMutableArray array];

    CGFloat sum = 0;    // 所有数据总和
    NSMutableArray<DTChartBlockModel *> *infos = [NSMutableArray arrayWithCapacity:self.multiData.count];
    for (DTChartItemData *itemData in sData.itemValues) {
        sum += itemData.itemValue.y;

        // 颜色
        if (!itemData.color) {
            itemData.color = [self.colorManager getColor];
        } else {
            [existColors addObject:itemData.color];
        }
        if (!itemData.secondColor) {
            itemData.secondColor = [self.colorManager getLightColor:itemData.color];
        }

        DTChartBlockModel *blockModel = [[DTChartBlockModel alloc] init];
        blockModel.seriesId = itemData.title;
        blockModel.color = itemData.color;
        [infos addObject:blockModel];
    }

    if (existColors.count > 0) {
        self.colorManager = [DTColorManager randomManagerExistColors:existColors];
    }

    if (self.itemsColorsCompletion) {
        self.itemsColorsCompletion(infos);
    }


    CGFloat accumulate = 0; // 累积百分比

    for (NSUInteger i = 0; i < sData.itemValues.count; ++i) {
        DTChartItemData *itemData = sData.itemValues[i];
        CGFloat valuePercentage = itemData.itemValue.y / sum;

        [self.percentages addObject:@(valuePercentage)];
        //        DTLog(@"percent = %.3f", valuePercentage);

        DTPiePart *part = [self generatePiePartWithPartColor:itemData.color
                                                 borderColor:itemData.secondColor
                                                      radius:self.radius
                                                      center:self.originPoint
                                             startPercentage:accumulate
                                               endPercentage:accumulate + valuePercentage];

        part.index = i;
        [self.containerLayer addSublayer:part];

        accumulate += valuePercentage;
    }

}

- (void)showTouchMessage:(NSString *)message touchPoint:(CGPoint)point {

    [self.toastView show:message location:point];
}

- (void)hideTouchMessage {
    [self.toastView hide];
}

#pragma mark - public method

- (void)updateFrame:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    CGFloat cellWidth = self.coordinateAxisCellWidth;
    self.frame = (CGRect) {origin, CGSizeMake(xCount * cellWidth, yCount * cellWidth)};
    ChartEdgeInsets insets = self.coordinateAxisInsets;
    self.contentView.frame = CGRectMake(insets.left * cellWidth,
            insets.top * cellWidth,
            CGRectGetWidth(self.bounds) - (insets.left + insets.right) * cellWidth,
            CGRectGetHeight(self.bounds) - (insets.top + insets.bottom) * cellWidth);

    _originPoint = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds));
}


#pragma mark - override

/**
 * 清除坐标系里的轴标签和值线条
 */
- (void)clearChartContent {

    NSArray<CALayer *> *layers = [self.containerLayer.sublayers copy];
    [layers enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTPiePart class]]) {
            DTPiePart *part = (DTPiePart *) obj;
            [part removeFromSuperlayer];
        }
    }];

}

- (void)generateMultiDataColors:(BOOL)needInitial {
}

- (void)generateSecondMultiDataColors:(BOOL)needInitial {
}

- (BOOL)drawXAxisLabels {
    return YES;
}

- (BOOL)drawYAxisLabels {
    return YES;
}

- (void)drawValues {

    if (self.multiData.count == 0) {
        return;
    }

    [self.percentages removeAllObjects];


    self.containerLayer.frame = self.contentView.bounds;

    [self drawSingleDataChart];

    if (self.isShowAnimation) {
        CGFloat lineWidth = self.radius + 2 * self.selectBorderWidth * self.coordinateAxisCellWidth;
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.path = [DTPiePart arcPathCenter:self.originPoint radius:lineWidth].CGPath;
        mask.lineWidth = lineWidth;
        mask.fillColor = [UIColor clearColor].CGColor;
        mask.strokeColor = [UIColor whiteColor].CGColor;
        self.containerLayer.mask = mask;

        [self startAppearAnimation];
    }
}

- (void)drawChart {
    [super drawChart];
}

- (void)dismissChart:(BOOL)animation {
    self.multiData = nil;
    self.secondMultiData = nil;

    if (animation) {
        [self startDisappearAnimation];
    } else {
        [self clearChartContent];
    }

}

@end
