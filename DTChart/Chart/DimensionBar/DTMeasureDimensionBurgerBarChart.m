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

@interface DTMeasureDimensionBurgerBarChart ()


@property(nonatomic) UIView *scrollMainContentView;
@property(nonatomic) UIView *scrollSecondContentView;

@property(nonatomic) NSMutableArray<DTDimensionBurgerLineModel *> *mainChartLines;
@property(nonatomic) NSMutableArray<DTDimensionBurgerLineModel *> *secondChartLines;


/**
 * 计算DTBar的x坐标
 */
@property(nonatomic) CGFloat barY;

@property(nonatomic) UIView *yAxisLine;

@end

@implementation DTMeasureDimensionBurgerBarChart

@synthesize barBorderStyle = _barBorderStyle;
@synthesize valueSelectable = _valueSelectable;

- (void)initial {
    [super initial];

    self.userInteractionEnabled = YES;

    _barBorderStyle = DTBarBorderStyleNone;
    self.barChartStyle = DTBarChartStyleStartingLine;
    _barY = 0;
    _yOffset = 0;
    _barGap = 2;

    ChartEdgeInsets insets = self.coordinateAxisInsets;

    _scrollMainContentView = [[UIView alloc] init];
    [self.contentView addSubview:_scrollMainContentView];

    _scrollSecondContentView = [[UIView alloc] init];
    [self.contentView addSubview:_scrollSecondContentView];

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

- (void)drawBars:(DTDimensionModel *)data frame:(CGRect)frame {
    if ([self layoutMainHeapBars:data fromFrame:frame]) {
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

        [self drawBars:data.ptListValue.firstObject frame:fromFrame];
    }
}

- (BOOL)layoutMainHeapBars:(DTDimensionModel *)data fromFrame:(CGRect)fromFrame {
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    BOOL draw = NO;

    // heap bar
    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;


    if (data.ptListValue.count > 0) {
        CGFloat sum = data.childrenSumValue;
        DTDimensionHeapBar *heapBar = [DTDimensionHeapBar heapBar:DTBarOrientationRight];
        heapBar.subBarBorderStyle = DTBarBorderStyleSidesBorder;
        heapBar.frame = CGRectMake(CGRectGetMinY(self.scrollMainContentView.bounds), self.barY, 0, barWidth);

        for (DTDimensionModel *model in data.ptListValue) {
            CGFloat length = self.coordinateAxisCellWidth * ((model.childrenSumValue / sum - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMaxData.axisPosition - xMinData.axisPosition);

            UIColor *color = [self.colorManager getColor];
            UIColor *borderColor = [self.colorManager getLightColor:color];
            [heapBar appendData:model barLength:length barColor:color barBorderColor:borderColor needLayout:model == data.ptListValue.lastObject];

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

            [lineModel show:self.scrollMainContentView.layer];
            [self.mainChartLines addObject:lineModel];
        }


        self.barY += barWidth + self.barGap * self.coordinateAxisCellWidth;
        [self.scrollMainContentView addSubview:heapBar];

        [self.chartBars addObject:heapBar];

        if (self.showAnimation) {
            [heapBar startAppearAnimation];
        }

        draw = YES;
    }


    return draw;
}

- (void)drawSecondBars:(DTDimensionModel *)data frame:(CGRect)frame {
    if ([self layoutSecondHeapBars:data fromFrame:frame]) {
        CGRect fromFrame = CGRectZero;
        DTDimensionHeapBar *lastHeapBar = self.secondChartBars.lastObject;
        if (lastHeapBar) {
            DTDimensionBar *subBar = [lastHeapBar touchSubBar:CGPointZero];
            CGRect subBarFrame = subBar.frame;
            subBarFrame.origin.x += CGRectGetMinX(lastHeapBar.frame);
            subBarFrame.origin.y += CGRectGetMinY(lastHeapBar.frame);

            fromFrame = subBarFrame;
        }

        [self drawSecondBars:data.ptListValue.firstObject frame:fromFrame];
    }
}

- (BOOL)layoutSecondHeapBars:(DTDimensionModel *)data fromFrame:(CGRect)fromFrame {
    CGFloat barWidth = self.barWidth * self.coordinateAxisCellWidth;

    BOOL draw = NO;

    // heap bar
    DTAxisLabelData *xMaxData = self.xSecondAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xSecondAxisLabelDatas.firstObject;


    if (data.ptListValue.count > 0) {
        CGFloat sum = data.childrenSumValue;
        DTDimensionHeapBar *heapBar = [DTDimensionHeapBar heapBar:DTBarOrientationLeft];
        heapBar.subBarBorderStyle = DTBarBorderStyleSidesBorder;
        heapBar.frame = CGRectMake(CGRectGetMaxX(self.scrollSecondContentView.bounds), self.barY, 0, barWidth);

        for (DTDimensionModel *model in data.ptListValue) {
            CGFloat length = self.coordinateAxisCellWidth * ((model.childrenSumValue / sum - xMinData.value) / (xMaxData.value - xMinData.value)) * (xMinData.axisPosition - xMaxData.axisPosition);

            UIColor *color = [self.colorManager getColor];
            UIColor *borderColor = [self.colorManager getLightColor:color];
            [heapBar appendData:model barLength:length barColor:color barBorderColor:borderColor needLayout:model == data.ptListValue.lastObject];

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

            [lineModel show:self.scrollSecondContentView.layer];
            [self.secondChartLines addObject:lineModel];
        }


        self.barY += barWidth + self.barGap * self.coordinateAxisCellWidth;
        [self.scrollSecondContentView addSubview:heapBar];

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
        [self.toastView show:message location:point];
    }
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


    NSUInteger touchIndex = 0;  // 标记触摸的主副表
    if (CGRectContainsPoint(self.scrollMainContentView.frame, touchPoint)) {
        touchIndex = 1;
    } else if (CGRectContainsPoint(self.scrollSecondContentView.frame, touchPoint)) {
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
    BOOL containsPoint = NO;
    NSUInteger removeIndex = bars.count;
    CGRect touchedSubBarFrame = CGRectZero;

    for (NSUInteger i = 0; i < bars.count; ++i) {
        DTBar *bar = bars[i];
        if (![bar isKindOfClass:[DTDimensionHeapBar class]]) {
            return;
        }

        DTDimensionHeapBar *heapBar = (DTDimensionHeapBar *) bar;

        if (touchPoint.y >= CGRectGetMinY(heapBar.frame) && touchPoint.y <= CGRectGetMaxY(bar.frame)) {
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

        if (touchIndex == 1) {
            [self drawBars:touchedModel frame:touchedSubBarFrame];
        } else {
            [self drawSecondBars:touchedModel frame:touchedSubBarFrame];
        }


        [self generateMessage:barAllData locaion:touchPoint];
    }
}


- (void)generateMessage:(NSArray<DTDimensionModel *> *)allData locaion:(CGPoint)point {
    // 提示文字
    NSMutableString *message = [NSMutableString string];
    allData = allData.reverseObjectEnumerator.allObjects;
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

    self.scrollSecondContentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame) / 2, CGRectGetHeight(self.contentView.frame));
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

    [self.scrollMainContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self.scrollSecondContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
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

    [self drawBars:self.mainDimensionModel frame:CGRectZero];
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

    [self drawSecondBars:self.secondDimensionModel frame:CGRectZero];
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
