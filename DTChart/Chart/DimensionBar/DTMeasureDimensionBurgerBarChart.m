//
//  DTMeasureDimensionBurgerBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/9.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTMeasureDimensionBurgerBarChart.h"
#import "DTDimensionModel.h"
#import "DTDimensionBar.h"
#import "DTDimensionBurgerLineModel.h"
#import "DTChartToastView.h"
#import "DTChartLabel.h"
#import "DTDimensionHeapBar.h"
#import "DTColor.h"

@interface DTMeasureDimensionBurgerBarChart ()


@property(nonatomic) UIView *mainContentView;
@property(nonatomic) UIView *secondContentView;

@property(nonatomic) NSMutableArray<DTDimensionBurgerLineModel *> *mainChartLines;
@property(nonatomic) NSMutableArray<DTDimensionBurgerLineModel *> *secondChartLines;


/**
 * 计算DTBar的x坐标
 */
@property(nonatomic) CGFloat barY;

@property(nonatomic) UIView *yAxisLine;

/**
 * 主表触摸时，在subBar上高亮的view
 */
@property(nonatomic) UIView *touchMainHighlightedView;
/**
 * 副表触摸时，在subBar上高亮的view
 */
@property(nonatomic) UIView *touchSecondHighlightedView;


@end

@implementation DTMeasureDimensionBurgerBarChart

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

    _barBorderStyle = DTBarBorderStyleNone;
    self.barChartStyle = DTBarChartStyleStartingLine;
    _barY = 0;
    _yOffset = 0;
    _barGap = 2;

    ChartEdgeInsets insets = self.coordinateAxisInsets;

    _mainContentView = [[UIView alloc] init];
    [self.contentView addSubview:_mainContentView];

    _secondContentView = [[UIView alloc] init];
    [self.contentView addSubview:_secondContentView];

    _yAxisLine = [UIView new];
    _yAxisLine.backgroundColor = DTRGBColor(0x7b7b7b, 1);
    [self addSubview:_yAxisLine];

    self.coordinateAxisInsets = ChartEdgeInsetsMake(0, 0, 0, 1);

    if (self.xAxisCellCount % 2 == 1) {
        self.coordinateAxisInsets = ChartEdgeInsetsMake(insets.left, insets.top, insets.right + 1, insets.bottom);
    } else {
        self.coordinateAxisInsets = insets;
    }


    self.colorManager = [DTColorManager randomManager];

    _touchMainHighlightedView = [UIView new];
    _touchMainHighlightedView.hidden = YES;
    _touchMainHighlightedView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];

    _touchSecondHighlightedView = [UIView new];
    _touchSecondHighlightedView.hidden = YES;
    _touchSecondHighlightedView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];

    [self.toastView removeFromSuperview];
    [self addSubview:self.toastView];
}

- (NSMutableArray<DTDimensionBurgerLineModel *> *)mainChartLines {
    if (!_mainChartLines) {
        _mainChartLines = [NSMutableArray array];
    }
    return _mainChartLines;
}

- (NSMutableArray<DTDimensionBurgerLineModel *> *)secondChartLines {
    if (!_secondChartLines) {
        _secondChartLines = [NSMutableArray array];
    }
    return _secondChartLines;
}

- (NSMutableArray<DTDimensionHeapBar *> *)secondChartBars {
    if (!_secondChartBars) {
        _secondChartBars = [NSMutableArray array];
    }
    return _secondChartBars;
}

- (void)setValueSelectable:(BOOL)valueSelectable {
    _valueSelectable = valueSelectable;
}


#pragma mark - private method

- (void)drawBars:(DTDimensionModel *)data frame:(CGRect)frame index:(NSUInteger)index {
    if ([self layoutMainHeapBars:data fromFrame:frame index:index]) {
        CGRect fromFrame = CGRectZero;
        DTBar *lastBar = self.chartBars.lastObject;
        if (lastBar && [lastBar isKindOfClass:[DTDimensionHeapBar class]]) {
            DTDimensionHeapBar *lastHeapBar = (DTDimensionHeapBar *) lastBar;
            DTDimensionBar *subBar = [lastHeapBar touchSubBar:CGPointMake(CGRectGetMaxX(lastHeapBar.bounds), 0)];
            CGRect subBarFrame = subBar.frame;
            subBarFrame.origin.x += CGRectGetMinX(lastHeapBar.frame);
            subBarFrame.origin.y += CGRectGetMinY(lastHeapBar.frame);

            fromFrame = subBarFrame;
        }

        ++index;
        [self drawBars:data.ptListValue.firstObject frame:fromFrame index:index];
    }
}

- (BOOL)layoutMainHeapBars:(DTDimensionModel *)data fromFrame:(CGRect)fromFrame index:(NSUInteger)index {
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    BOOL draw = NO;

    // heap bar
    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

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

    if (data.ptListValue.count > 0) {
        CGFloat sum = data.childrenSumValue;
        DTDimensionHeapBar *heapBar = [DTDimensionHeapBar heapBar:DTBarOrientationRight];

        heapBar.frame = CGRectMake(CGRectGetMinY(self.mainContentView.bounds), self.barY, 0, barWidth);

        for (DTDimensionModel *model in data.ptListValue) {
            CGFloat length = self.coordinateAxisCellWidth * ((model.childrenSumValue / sum - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMaxData.axisPosition - xMinData.axisPosition);

            UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1];
            r += deltaR;
            g += deltaG;
            b += deltaB;
            [heapBar appendData:model barLength:length barColor:color barBorderColor:nil needLayout:model == data.ptListValue.lastObject];

        }

        if (CGRectGetWidth(fromFrame) != 0 || CGRectGetHeight(fromFrame) != 0) {
            DTDimensionBurgerLineModel *lineModel = [[DTDimensionBurgerLineModel alloc] init];

            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(CGRectGetMaxX(fromFrame), CGRectGetMaxY(fromFrame))];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(heapBar.frame), CGRectGetMinY(heapBar.frame))];
            lineModel.upperPath = path;

            path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(CGRectGetMinX(fromFrame), CGRectGetMaxY(fromFrame))];
            [path addLineToPoint:CGPointMake(CGRectGetMinX(heapBar.frame), CGRectGetMinY(heapBar.frame))];
            lineModel.lowerPath = path;

            [lineModel show:self.mainContentView.layer];
            [self.mainChartLines addObject:lineModel];
        }


        self.barY += barWidth + self.barGap * self.coordinateAxisCellWidth;
        [self.mainContentView addSubview:heapBar];

        [self.chartBars addObject:heapBar];

        if (self.showAnimation) {
            [heapBar startAppearAnimation];
        }

        draw = YES;
    }


    return draw;
}

- (void)drawSecondBars:(DTDimensionModel *)data frame:(CGRect)frame index:(NSUInteger)index {
    if ([self layoutSecondHeapBars:data fromFrame:frame index:index]) {
        CGRect fromFrame = CGRectZero;
        DTDimensionHeapBar *lastHeapBar = self.secondChartBars.lastObject;
        if (lastHeapBar) {
            DTDimensionBar *subBar = [lastHeapBar touchSubBar:CGPointZero];
            CGRect subBarFrame = subBar.frame;
            subBarFrame.origin.x += CGRectGetMinX(lastHeapBar.frame);
            subBarFrame.origin.y += CGRectGetMinY(lastHeapBar.frame);

            fromFrame = subBarFrame;
        }

        index++;
        [self drawSecondBars:data.ptListValue.firstObject frame:fromFrame index:index];
    }
}

- (BOOL)layoutSecondHeapBars:(DTDimensionModel *)data fromFrame:(CGRect)fromFrame index:(NSUInteger)index {
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    BOOL draw = NO;

    // heap bar
    DTAxisLabelData *xMaxData = self.xSecondAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xSecondAxisLabelDatas.firstObject;

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

    if (data.ptListValue.count > 0) {
        CGFloat sum = data.childrenSumValue;
        DTDimensionHeapBar *heapBar = [DTDimensionHeapBar heapBar:DTBarOrientationLeft];

        heapBar.frame = CGRectMake(CGRectGetMaxX(self.secondContentView.bounds), self.barY, 0, barWidth);

        for (DTDimensionModel *model in data.ptListValue) {
            CGFloat length = self.coordinateAxisCellWidth * ((model.childrenSumValue / sum - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMinData.axisPosition - xMaxData.axisPosition);

            UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1];
            r += deltaR;
            g += deltaG;
            b += deltaB;
            [heapBar appendData:model barLength:length barColor:color barBorderColor:nil needLayout:model == data.ptListValue.lastObject];

        }

        if (CGRectGetWidth(fromFrame) != 0 || CGRectGetHeight(fromFrame) != 0) {
            DTDimensionBurgerLineModel *lineModel = [[DTDimensionBurgerLineModel alloc] init];

            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(CGRectGetMinX(fromFrame), CGRectGetMaxY(fromFrame))];
            [path addLineToPoint:CGPointMake(CGRectGetMinX(heapBar.frame), CGRectGetMinY(heapBar.frame))];
            lineModel.upperPath = path;

            path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(CGRectGetMaxX(fromFrame), CGRectGetMaxY(fromFrame))];
            [path addLineToPoint:CGPointMake(CGRectGetMaxX(heapBar.frame), CGRectGetMinY(heapBar.frame))];
            lineModel.lowerPath = path;

            [lineModel show:self.secondContentView.layer];
            [self.secondChartLines addObject:lineModel];
        }


        self.barY += barWidth + self.barGap * self.coordinateAxisCellWidth;
        [self.secondContentView addSubview:heapBar];

        [self.secondChartBars addObject:heapBar];

        if (self.showAnimation) {
            [heapBar startAppearAnimation];
        }

        draw = YES;
    }


    return draw;
}

- (void)showTouchMessage:(NSString *)message touchPoint:(CGPoint)point {
    if (self.isValueSelectable) {
        point.x += self.coordinateAxisInsets.left * self.coordinateAxisCellWidth;
        point.y += self.coordinateAxisInsets.top * self.coordinateAxisCellWidth;
        [self.toastView show:message location:point];
    }
}

- (void)hideTouchMessage {
    [self.toastView hide];
    self.touchSelectedLine.hidden = YES;
}

#pragma mark - touch event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    [self touchKeyPoint:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];

    // 标记触摸的主副表
    if (CGRectContainsPoint(self.mainContentView.frame, touchPoint)) {
        self.touchMainHighlightedView.hidden = YES;
    } else if (CGRectContainsPoint(self.secondContentView.frame, touchPoint)) {
        self.touchSecondHighlightedView.hidden = YES;
    }

    [self hideTouchMessage];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];

    // 标记触摸的主副表
    if (CGRectContainsPoint(self.mainContentView.frame, touchPoint)) {
        self.touchMainHighlightedView.hidden = YES;
    } else if (CGRectContainsPoint(self.secondContentView.frame, touchPoint)) {
        self.touchSecondHighlightedView.hidden = YES;
    }

    [self hideTouchMessage];
}

- (void)touchKeyPoint:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];


    NSUInteger touchIndex = 0;  // 标记触摸的主副表
    if (CGRectContainsPoint(self.mainContentView.frame, touchPoint)) {
        touchIndex = 1;
    } else if (CGRectContainsPoint(self.secondContentView.frame, touchPoint)) {
        touchIndex = 2;
    }

    if (touchIndex == 0) {
        return;
    }

    NSMutableArray *bars = nil;
    NSMutableArray<DTDimensionBurgerLineModel *> *lines = nil;
    if (touchIndex == 1) {
        bars = self.chartBars;
        lines = self.mainChartLines;
    } else {
        bars = self.secondChartBars;
        lines = self.secondChartLines;
    }

    DTDimensionModel *touchedModel = nil;
    NSArray<DTDimensionModel *> *barAllData = nil;
    NSArray<UIColor *> *barAllColor = nil;

    BOOL containsPoint = NO;
    NSUInteger removeIndex = bars.count;
    CGRect touchedSubBarFrame = CGRectZero;
    NSUInteger dimensionIndex = 0;

    for (NSUInteger i = 0; i < bars.count; ++i) {
        DTBar *bar = bars[i];
        if (![bar isKindOfClass:[DTDimensionHeapBar class]]) {
            return;
        }

        DTDimensionHeapBar *heapBar = (DTDimensionHeapBar *) bar;

        if (touchPoint.y >= CGRectGetMinY(heapBar.frame) && touchPoint.y <= CGRectGetMaxY(bar.frame)) {
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

            if (touchIndex == 1) {
                self.touchMainHighlightedView.frame = frame;
                if (self.touchMainHighlightedView.superview) {
                    [self.touchMainHighlightedView.superview bringSubviewToFront:self.touchMainHighlightedView];
                } else {
                    [self.mainContentView addSubview:self.touchMainHighlightedView];
                }
                self.touchMainHighlightedView.hidden = NO;
            } else if (touchIndex == 2) {
                self.touchSecondHighlightedView.frame = frame;
                if (self.touchSecondHighlightedView.superview) {
                    [self.touchSecondHighlightedView.superview bringSubviewToFront:self.touchSecondHighlightedView];
                } else {
                    [self.secondContentView addSubview:self.touchSecondHighlightedView];
                }
                self.touchSecondHighlightedView.hidden = NO;
            }


            removeIndex = i;
        }

        if (i > removeIndex) {
            [heapBar removeFromSuperview];
            [lines[i - 1] hide];

        } else {
            self.barY = CGRectGetMaxY(heapBar.frame) + self.barGap * self.coordinateAxisCellWidth;
        }
    }


    if (!containsPoint) {
        [self hideTouchMessage];
    } else {

        [bars removeObjectsInRange:NSMakeRange(removeIndex + 1, bars.count - 1 - removeIndex)];
        [lines removeObjectsInRange:NSMakeRange(removeIndex, lines.count - removeIndex)];

        // 绘制后面的维度柱状体
        if (touchIndex == 1) {
            [self drawBars:touchedModel frame:touchedSubBarFrame index:dimensionIndex + 1];
        } else {
            [self drawSecondBars:touchedModel frame:touchedSubBarFrame index:dimensionIndex + 1];
        }

        NSMutableString *message = nil;
        barAllData = barAllData.reverseObjectEnumerator.allObjects;
        barAllColor = barAllColor.reverseObjectEnumerator.allObjects;

        if (touchIndex == 1) {
            if (self.touchMainSubBarBlock) {
                message = self.touchMainSubBarBlock(barAllData, barAllColor, touchedModel, dimensionIndex).mutableCopy;
            }
        } else if (touchIndex == 2) {
            if (self.touchSecondSubBarBlock) {
                message = self.touchSecondSubBarBlock(barAllData, barAllColor, touchedModel, dimensionIndex).mutableCopy;
            }
        }

        if (!message) {
            [self generateMessage:barAllData locaion:touchPoint];
        } else if (message.length > 0) {
            [self showTouchMessage:message touchPoint:touchPoint];
        }
    }
}


- (void)generateMessage:(NSArray<DTDimensionModel *> *)allData locaion:(CGPoint)point {
    // 提示文字
    NSMutableString *message = [NSMutableString string];

    for (DTDimensionModel *obj in allData) {
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

        if (obj != allData.lastObject) {
            [message appendString:@"\n"];
        }
    }

    if (message.length > 0) {
        [self showTouchMessage:message touchPoint:point];
    }
}


#pragma mark - override

- (void)setCoordinateAxisInsets:(ChartEdgeInsets)coordinateAxisInsets {
    [super setCoordinateAxisInsets:coordinateAxisInsets];

    if (self.xAxisCellCount % 2 == 1) {
        ChartEdgeInsets insets = self.coordinateAxisInsets;
        self.coordinateAxisInsets = ChartEdgeInsetsMake(insets.left, insets.top, insets.right + 1, insets.bottom);
        return;
    }

    self.secondContentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame) / 2, CGRectGetHeight(self.contentView.frame));
    self.mainContentView.frame = CGRectMake(CGRectGetMaxX(self.secondContentView.frame),
            CGRectGetMinY(self.secondContentView.frame),
            CGRectGetWidth(self.secondContentView.frame),
            CGRectGetHeight(self.secondContentView.frame));

    [self bringSubviewToFront:self.yAxisLine];
    self.yAxisLine.frame = CGRectMake(CGRectGetMidX(self.contentView.frame) - 1, CGRectGetMinY(self.contentView.frame), 2, CGRectGetHeight(self.contentView.frame));
}

- (void)clearChartContent {

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            [obj removeFromSuperview];
        }
    }];

    [self.mainContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self.secondContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
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
        CGFloat y = CGRectGetMaxY(self.contentView.frame);
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
    self.barY = self.yOffset * self.coordinateAxisCellWidth;

    [self drawBars:self.mainDimensionModel frame:CGRectZero index:0];
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
        CGFloat y = CGRectGetMaxY(self.contentView.frame);
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
    self.barY = self.yOffset * self.coordinateAxisCellWidth;

    [self drawSecondBars:self.secondDimensionModel frame:CGRectZero index:0];
}

- (void)drawChart {
    [super drawChart];

    [self drawSecondChart];
}

- (void)drawSecondChart {
    if ([self drawXSecondAxisLabels]) {

        [self drawSecondValues];
    }
}


@end
