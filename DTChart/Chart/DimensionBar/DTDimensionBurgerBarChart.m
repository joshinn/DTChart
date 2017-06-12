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
#import "DTColor.h"

@interface DTDimensionBurgerBarChart ()

/**
 * 计算DTBar的x坐标
 */
@property(nonatomic) CGFloat barX;

@property(nonatomic) NSMutableArray<DTDimensionBurgerLineModel *> *chartLines;

/**
 * 触摸时，在subBar上高亮的view
 */
@property(nonatomic) UIView *touchHighlightedView;

@end

@implementation DTDimensionBurgerBarChart

@synthesize barBorderStyle = _barBorderStyle;
@synthesize valueSelectable = _valueSelectable;

#define Dimension1Color DTColorDarkBlue
#define Dimension2Color DTColorBlue
#define Dimension3Color DTColorPurple
#define Dimension4Color DTColorGray

#define DimensionColors @[Dimension1Color, Dimension2Color, Dimension3Color, Dimension4Color]

- (void)initial {
    [super initial];

    self.userInteractionEnabled = YES;
    self.coordinateAxisInsets = ChartEdgeInsetsMake(1, 0, 0, 0);

    _barGap = 2;

    _barBorderStyle = DTBarBorderStyleNone;
    _barX = 0;
    _xOffset = 6;

    self.barChartStyle = DTBarChartStyleStartingLine;

    self.colorManager = [DTColorManager randomManager];

    _touchHighlightedView = [UIView new];
    _touchHighlightedView.hidden = YES;
    _touchHighlightedView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.contentView addSubview:_touchHighlightedView];
}

- (NSMutableArray<DTDimensionBurgerLineModel *> *)chartLines {
    if (!_chartLines) {
        _chartLines = [NSMutableArray array];
    }
    return _chartLines;
}

- (void)setValueSelectable:(BOOL)valueSelectable {
    _valueSelectable = valueSelectable;
}

#pragma mark - private method

- (void)showTouchMessage:(NSString *)message touchPoint:(CGPoint)point {
    if (self.isValueSelectable) {
        [self.toastView show:message location:point];
    }
}

- (void)hideTouchMessage {
    [self.toastView hide];
    self.touchSelectedLine.hidden = YES;
}

- (void)drawBars:(DTDimensionModel *)data frame:(CGRect)frame index:(NSUInteger)index {
    if ([self layoutHeapBars:data fromFrame:frame index:index]) {
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

        ++index;
        [self drawBars:data.ptListValue.firstObject frame:fromFrame index:index];
    }
}

- (BOOL)layoutHeapBars:(DTDimensionModel *)data fromFrame:(CGRect)fromFrame index:(NSUInteger)index {
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    BOOL draw = NO;

    // heap bar
    DTAxisLabelData *yMaxData = self.yAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.yAxisLabelDatas.firstObject;


    if (data.ptListValue.count > 0) {
        CGFloat sum = data.childrenSumValue;
        DTDimensionHeapBar *heapBar = [DTDimensionHeapBar heapBar:DTBarOrientationUp];
//        heapBar.subBarBorderStyle = DTBarBorderStyleSidesBorder;
        heapBar.frame = CGRectMake(self.barX, CGRectGetMaxY(self.contentView.bounds), barWidth, 0);

        UIColor *dimensionColor = nil;
        if (index >= DimensionColors.count) {
            dimensionColor = DimensionColors.lastObject;
        } else {
            dimensionColor = DimensionColors[index];
        }
        CGFloat r, g, b, a, deltaR, deltaG, deltaB;
        [dimensionColor getRed:&r green:&g blue:&b alpha:&a];
        deltaR = (1 - r) / data.ptListValue.count;
        deltaG = (1 - g) / data.ptListValue.count;
        deltaB = (1 - b) / data.ptListValue.count;


        for (DTDimensionModel *model in data.ptListValue) {
            CGFloat height = 0;
            if (sum > 0) {
                height = self.coordinateAxisCellWidth * ((model.childrenSumValue / sum - yMinData.value) / (yMaxData.value - yMinData.value)) * (yMaxData.axisPosition - yMinData.axisPosition);
            }

            UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1];
            r += deltaR;
            g += deltaG;
            b += deltaB;
            [heapBar appendData:model barLength:height barColor:color barBorderColor:nil needLayout:model == data.ptListValue.lastObject];

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
    [super touchesBegan:touches withEvent:event];

    [self touchKeyPoint:touches drawNextBars:NO];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    [self touchKeyPoint:touches drawNextBars:NO];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    [self touchKeyPoint:touches drawNextBars:YES];

    self.touchHighlightedView.hidden = YES;
    [self hideTouchMessage];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    self.touchHighlightedView.hidden = YES;
    [self hideTouchMessage];
}

/**
 * 处理触摸事件
 * @param touches 触摸事件对象
 * @param draw 是否绘制后面维度的柱状体
 */
- (void)touchKeyPoint:(NSSet *)touches drawNextBars:(BOOL)draw {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];

    DTDimensionModel *touchedModel = nil;
    NSArray<DTDimensionModel *> *barAllData = nil;
    NSArray<UIColor *> *barAllColor = nil;

    BOOL containsPoint = NO;
    NSUInteger removeIndex = self.chartBars.count;
    CGRect touchedSubBarFrame = CGRectZero;
    NSUInteger dimensionIndex = 0;  ///< 维度序号

    for (NSUInteger i = 0; i < self.chartBars.count; ++i) {
        DTBar *bar = self.chartBars[i];
        if (![bar isKindOfClass:[DTDimensionHeapBar class]]) {
            return;
        }

        DTDimensionHeapBar *heapBar = (DTDimensionHeapBar *) bar;

        if (touchPoint.x >= CGRectGetMinX(heapBar.frame) && touchPoint.x <= CGRectGetMaxX(bar.frame)) {
            containsPoint = YES;
            dimensionIndex = i;

            barAllData = heapBar.itemDatas;
            barAllColor = heapBar.barAllColors;

            CGPoint point = [touch locationInView:heapBar];
            DTDimensionBar *subBar = [heapBar touchSubBar:point];

            touchedModel = subBar.dimensionModels.firstObject;
            CGRect frame = subBar.frame;
            frame.origin.x += CGRectGetMinX(heapBar.frame);
            frame.origin.y += CGRectGetMinY(heapBar.frame);
            touchedSubBarFrame = frame;

            self.touchHighlightedView.frame = frame;
            [self.touchHighlightedView.superview bringSubviewToFront:self.touchHighlightedView];
            self.touchHighlightedView.hidden = NO;

            removeIndex = i;
        }

        if (i > removeIndex) {

            if (draw) {
                [heapBar removeFromSuperview];
                [self.chartLines[i - 1] hide];
            }

        } else {
            self.barX = CGRectGetMaxX(heapBar.frame) + self.barGap * self.coordinateAxisCellWidth;
        }
    }


    if (!containsPoint) {
        [self hideTouchMessage];
    } else {

        if (draw) { // 绘制后面的维度柱状体
            [self.chartBars removeObjectsInRange:NSMakeRange(removeIndex + 1, self.chartBars.count - 1 - removeIndex)];
            [self.chartLines removeObjectsInRange:NSMakeRange(removeIndex, self.chartLines.count - removeIndex)];

            [self drawBars:touchedModel frame:touchedSubBarFrame index:dimensionIndex + 1];
        }

        {   // 提示文字
            NSMutableString *message = nil;
            barAllData = barAllData.reverseObjectEnumerator.allObjects;
            barAllColor = barAllColor.reverseObjectEnumerator.allObjects;

            if (self.touchSubBarBlock) {
                message = self.touchSubBarBlock(barAllData, barAllColor, touchedModel, dimensionIndex).mutableCopy;
            }

            if (!message) {
                message = [NSMutableString string];

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

    [self drawBars:self.dimensionModel frame:CGRectZero index:0];
}

- (void)drawChart {

    [super drawChart];

}


@end
