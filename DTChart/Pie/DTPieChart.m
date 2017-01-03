//
//  DTPieChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/26.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTPieChart.h"
#import "DTChartData.h"
#import "DTPiePart.h"

@interface DTPieChart ()


@property(nonatomic) CAShapeLayer *containerLayer;
/**
 * 存储pie图每个组成部分的百分比
 */
@property(nonatomic) NSMutableArray<NSNumber *> *percentages;

@property(nonatomic) CGFloat radius;
/**
 * 上一个选择的pie图组成部分的序号
 */
@property(nonatomic) NSInteger prevSelectedIndex;

@end

@implementation DTPieChart

@synthesize originPoint = _originPoint;

- (void)initial {
    [super initial];

    _prevSelectedIndex = -1;
    _drawSingleDataIndex = -1;
    _pieMargin = 2;
}

- (void)setOriginPoint:(CGPoint)originPoint {
    _originPoint = originPoint;
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

#pragma mark - private method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchKeyPoint:touches isMoving:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchKeyPoint:touches isMoving:YES];
}


- (void)touchKeyPoint:(NSSet *)touches isMoving:(BOOL)moving {
    if(!self.valueSelectable){
        return;
    }

    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];

    if (CGPointGetDistance(touchPoint, self.originPoint) > self.radius) {
        return;
    }

    CGFloat angle = (CGFloat) atan2(touchPoint.y - self.originPoint.y, touchPoint.x - self.originPoint.x);
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

    if (moving) {
        if (self.prevSelectedIndex >= 0 && self.prevSelectedIndex != index) {
            self.prevSelectedIndex = index;
            if (self.pieChartTouchBlock) {
                DTLog(@"pie chart selected index = %@", @(index));
                self.pieChartTouchBlock((NSUInteger) index);
            }
        }
    } else {
        if (self.prevSelectedIndex != index) {

            self.prevSelectedIndex = index;
            if (self.pieChartTouchBlock) {
                DTLog(@"pie chart selected index = %@", @(index));
                self.pieChartTouchBlock((NSUInteger) index);
            }
        }
    }


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
    partLayer.selectBorderWidth = 1 * self.coordinateAxisCellWidth;

    return partLayer;
}

- (void)startAppearAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1;
    animation.fromValue = @0;
    animation.toValue = @1;
//    animation.delegate  = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [self.containerLayer.mask addAnimation:animation forKey:@"circleAnimation"];
}

/**
 * 绘制整体pie chart
 * @note 每个DTChartSingleData里的所有itemValue.y总和作为pie chart的组成部分
 */
- (void)drawMultiDataChart {
    CGFloat sum = 0;    // 所有数据总和
    NSMutableArray<NSNumber *> *singleTotalArray = [NSMutableArray arrayWithCapacity:self.multiData.count];

    for (DTChartSingleData *sData in self.multiData) {

        CGFloat singleTotal = 0;    // 单组数据总和
        for (DTChartItemData *obj in sData.itemValues) {
            singleTotal += obj.itemValue.y;
            sum += obj.itemValue.y;

        }
        [singleTotalArray addObject:@(singleTotal)];
    }


    CGFloat accumulate = 0; // 累积百分比

    for (NSUInteger i = 0; i < self.multiData.count; ++i) {
        DTChartSingleData *singleData = self.multiData[i];

        CGFloat singleTotal = singleTotalArray[i].floatValue;

        CGFloat valuePercentage = singleTotal / sum;

        [self.percentages addObject:@(valuePercentage)];
        DTLog(@"percent = %.3f", valuePercentage);

        DTPiePart *part = [self generatePiePartWithPartColor:singleData.color
                                                 borderColor:singleData.secondColor
                                                      radius:self.radius
                                                      center:self.originPoint
                                             startPercentage:accumulate
                                               endPercentage:accumulate + valuePercentage];

        [self.containerLayer addSublayer:part];

        accumulate += valuePercentage;
    }

}

/**
 * 绘制指定单组数据的pie chart
 * @param index 数组multiData的序号
 * @note DTChartSingleData里的每个itemValue.y作为pie chart的组成部分
 */
- (void)drawSingleDataChart:(NSUInteger)index {
    if (self.multiData.count <= index) {
        DTLog(@"Error: DTPieChart index越界");
        return;
    }


    DTChartSingleData *sData = self.multiData[index];
    if (sData.itemValues.count == 0) {
        return;
    }

    self.colorManager = [DTColorManager randomManager];

    CGFloat sum = 0;    // 所有数据总和
    for (DTChartItemData *itemData in sData.itemValues) {
        sum += itemData.itemValue.y;

        // 颜色
        if(!itemData.color){
            itemData.color = [self.colorManager getColor];

        }
        if (!itemData.secondColor) {
            itemData.secondColor = [self.colorManager getLightColor:itemData.color];
        }
    }

    CGFloat accumulate = 0; // 累积百分比

    for (DTChartItemData *itemData in sData.itemValues) {

        CGFloat valuePercentage = itemData.itemValue.y / sum;

        [self.percentages addObject:@(valuePercentage)];
        DTLog(@"percent = %.3f", valuePercentage);

        DTPiePart *part = [self generatePiePartWithPartColor:itemData.color
                                                 borderColor:itemData.secondColor
                                                      radius:self.radius
                                                      center:self.originPoint
                                             startPercentage:accumulate
                                               endPercentage:accumulate + valuePercentage];

        [self.containerLayer addSublayer:part];

        accumulate += valuePercentage;
    }

}


#pragma mark - override

/**
 * 清除坐标系里的轴标签和值线条
 */
- (void)clearChartContent {

    NSArray<CALayer *> *layers = [self.contentView.layer.sublayers copy];
    [layers enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTPiePart class]]) {
            DTPiePart *part = (DTPiePart *) obj;
            [part removeFromSuperlayer];
        }
    }];

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

    self.radius = MIN(CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame)) / 2 - self.pieMargin * self.coordinateAxisCellWidth;
    self.originPoint = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds));

    self.containerLayer.frame = self.contentView.bounds;

    if (self.drawSingleDataIndex == -1) {
        [self drawMultiDataChart];
    } else {
        [self drawSingleDataChart:(NSUInteger) self.drawSingleDataIndex];
    }


    if (self.isShowAnimation) {
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.path = [DTPiePart arcPathCenter:self.originPoint radius:self.radius].CGPath;
        mask.lineWidth = self.radius;
        mask.fillColor = [UIColor clearColor].CGColor;
        mask.strokeColor = [UIColor whiteColor].CGColor;

        self.containerLayer.mask = mask;

        [self startAppearAnimation];
    }
}


@end
