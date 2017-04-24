//
//  DTDimensionBurgerBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/9.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBurgerBarChart.h"
#import "DTChartLabel.h"
#import "DTDimensionModel.h"
#import "DTDimensionHeapBar.h"
#import "DTChartToastView.h"
#import "DTDimensionBurgerLineModel.h"

@interface DTDimensionBurgerBarChart ()

/**
 * 计算DTBar的x坐标
 */
@property(nonatomic) CGFloat barX;

@property(nonatomic) NSMutableArray<DTDimensionBurgerLineModel *> *chartLines;

@end

@implementation DTDimensionBurgerBarChart

@synthesize barBorderStyle = _barBorderStyle;

- (void)initial {
    [super initial];

    self.coordinateAxisInsets = ChartEdgeInsetsMake(1, 0, 0, 0);

    _barGap = 2;

    _barBorderStyle = DTBarBorderStyleNone;
    _barX = 0;
    _xOffset = 6;

    self.barChartStyle = DTBarChartStyleStartingLine;

    self.colorManager = [DTColorManager randomManager];
}

- (NSMutableArray<DTDimensionBurgerLineModel *> *)chartLines {
    if (!_chartLines) {
        _chartLines = [NSMutableArray array];
    }
    return _chartLines;
}


#pragma mark - private method

- (void)showTouchMessage:(NSString *)message touchPoint:(CGPoint)point {
    [self.toastView show:message location:point];
}

- (void)hideTouchMessage {
    [self.toastView hide];
    self.touchSelectedLine.hidden = YES;
}

- (void)drawBars:(DTDimensionModel *)data frame:(CGRect)frame {
    if ([self layoutHeapBars:data fromFrame:frame drawSubviews:YES]) {
        CGRect fromFrame = CGRectZero;
        DTBar *lastBar = self.chartBars.lastObject;
        if (lastBar && [lastBar isKindOfClass:[DTDimensionHeapBar class]]) {
            DTDimensionHeapBar *lastHeapBar = (DTDimensionHeapBar *) lastBar;
            DTDimensionBar *subBar = [lastHeapBar touchSubBar:CGPointZero];
            CGRect subBarFrame = subBar.frame;
            subBarFrame.origin.x += CGRectGetMinX(lastHeapBar.frame);
            subBarFrame.origin.y += CGRectGetMinY(lastHeapBar.frame);

            fromFrame = subBarFrame;
        }

        [self drawBars:data.ptListValue.firstObject frame:fromFrame];
    }
}

- (BOOL)layoutHeapBars:(DTDimensionModel *)data fromFrame:(CGRect)fromFrame drawSubviews:(BOOL)isDraw {
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    BOOL draw = NO;

    // heap bar
    DTAxisLabelData *yMaxData = self.yAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.yAxisLabelDatas.firstObject;


    if (data.ptListValue.count > 0) {
        CGFloat sum = data.childrenSumValue;
        DTDimensionHeapBar *heapBar = [DTDimensionHeapBar heapBar:DTBarOrientationUp];
        heapBar.subBarBorderStyle = DTBarBorderStyleSidesBorder;
        heapBar.frame = CGRectMake(self.barX, CGRectGetMaxY(self.contentView.bounds), barWidth, 0);

        for (DTDimensionModel *model in data.ptListValue) {
            CGFloat height = 0;
            if (sum > 0) {
                height = self.coordinateAxisCellWidth * ((model.childrenSumValue / sum - yMinData.value) / (yMaxData.value - yMinData.value)) * (yMaxData.axisPosition - yMinData.axisPosition);
            }

            UIColor *color = [self.colorManager getColor];
            UIColor *borderColor = [self.colorManager getLightColor:color];
            [heapBar appendData:model barLength:height barColor:color barBorderColor:borderColor needLayout:model == data.ptListValue.lastObject];


        }

        if (CGRectGetWidth(fromFrame) != 0 || CGRectGetHeight(fromFrame) != 0) {
            DTDimensionBurgerLineModel *lineModel = [[DTDimensionBurgerLineModel alloc] init];

            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(CGRectGetMaxX(fromFrame), CGRectGetMinY(fromFrame))];
            [path addLineToPoint:CGPointMake(CGRectGetMinX(heapBar.frame), CGRectGetMinY(heapBar.frame))];
            lineModel.upperPath = path;

            path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(CGRectGetMaxX(fromFrame), CGRectGetMaxY(fromFrame))];
            [path addLineToPoint:CGPointMake(CGRectGetMinX(heapBar.frame), CGRectGetMaxY(heapBar.frame))];
            lineModel.lowerPath = path;

            [lineModel show:self.contentView.layer];
            [self.chartLines addObject:lineModel];
        }


        self.barX += barWidth + self.barGap * self.coordinateAxisCellWidth;
        [self.contentView addSubview:heapBar];

        [self.chartBars addObject:heapBar];

        if (self.showAnimation) {
            [heapBar startAppearAnimation];
        }

        draw = YES;
    }


    return draw;
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

    DTDimensionModel *touchedModel = nil;
    NSArray<DTDimensionModel *> *barAllData = nil;
    BOOL containsPoint = NO;
    NSUInteger removeIndex = self.chartBars.count;
    CGRect touchedSubBarFrame = CGRectZero;

    for (NSUInteger i = 0; i < self.chartBars.count; ++i) {
        DTBar *bar = self.chartBars[i];
        if (![bar isKindOfClass:[DTDimensionHeapBar class]]) {
            return;
        }

        DTDimensionHeapBar *heapBar = (DTDimensionHeapBar *) bar;

        if (touchPoint.x >= CGRectGetMinX(heapBar.frame) && touchPoint.x <= CGRectGetMaxX(bar.frame)) {
            containsPoint = YES;

            barAllData = heapBar.itemDatas;

            CGPoint point = [touch locationInView:heapBar];
            DTDimensionBar *subBar = [heapBar touchSubBar:point];

            touchedModel = subBar.dimensionModels.firstObject;
            CGRect frame = subBar.frame;
            frame.origin.x += CGRectGetMinX(heapBar.frame);
            frame.origin.y += CGRectGetMinY(heapBar.frame);
            touchedSubBarFrame = frame;

            removeIndex = i;
        }

        if (i > removeIndex) {
            [heapBar removeFromSuperview];
            [self.chartLines[i - 1] hide];

        } else {
            self.barX = CGRectGetMaxX(heapBar.frame) + self.barGap * self.coordinateAxisCellWidth;
        }
    }


    if (!containsPoint) {
        [self hideTouchMessage];
    } else {

        [self.chartBars removeObjectsInRange:NSMakeRange(removeIndex + 1, self.chartBars.count - 1 - removeIndex)];
        [self.chartLines removeObjectsInRange:NSMakeRange(removeIndex, self.chartLines.count - removeIndex)];

        [self drawBars:touchedModel frame:touchedSubBarFrame];

        {   // 提示文字
            NSMutableString *message = [NSMutableString string];
            barAllData = barAllData.reverseObjectEnumerator.allObjects;
            for (DTDimensionModel *obj in barAllData) {
                [message appendString:obj.ptName];
                if (floorf(obj.childrenSumValue) != obj.childrenSumValue) {   // 有小数
                    NSString *string = [NSString stringWithFormat:@"\n%.1f", obj.childrenSumValue];
                    if ([string hasSuffix:@".0"]) {
                        [message appendString:[string substringToIndex:string.length - 2]];
                    } else {
                        [message appendString:string];
                    }
                } else {
                    [message appendString:[NSString stringWithFormat:@"\n%@", @(obj.childrenSumValue)]];
                }

                if (obj != barAllData.lastObject) {
                    [message appendString:@"\n"];
                }
            }

            if (message.length > 0) {
                [self showTouchMessage:message touchPoint:touchPoint];
            }
        }

    }
}


#pragma mark - override

- (void)clearChartContent {
    [super clearChartContent];

    [self.chartBars removeAllObjects];

    [self.chartLines enumerateObjectsUsingBlock:^(DTDimensionBurgerLineModel *obj, NSUInteger idx, BOOL *stop) {
        [obj hide];
    }];
    [self.chartLines removeAllObjects];
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
    self.barX = self.xOffset * self.coordinateAxisCellWidth;

    [self drawBars:self.dimensionModel frame:CGRectZero];
}

- (void)drawChart {

    [super drawChart];

}


@end
