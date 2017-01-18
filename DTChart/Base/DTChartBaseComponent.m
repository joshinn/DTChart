//
//  DTChartBaseComponent.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"
#import "DTChartBlockModel.h"


CGFloat const DefaultCoordinateAxisCellWidth = 15;

@interface DTChartBaseComponent ()

@property(nonatomic) CAShapeLayer *coordinateAxisLine;
@property(nonatomic) CAShapeLayer *gridLine;

@end

@implementation DTChartBaseComponent


- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {

    return [self initWithOrigin:origin cellWidth:DefaultCoordinateAxisCellWidth xAxis:xCount yAxis:yCount];
}

- (instancetype)initWithOrigin:(CGPoint)origin cellWidth:(CGFloat)cell xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {

    _xCount = xCount;
    _yCount = yCount;

    _coordinateAxisCellWidth = cell;

    _coordinateAxisInsets = ChartEdgeInsetsMake(1, 0, 0, 1);
    _xAxisCellCount = xCount - _coordinateAxisInsets.left - _coordinateAxisInsets.right;
    _yAxisCellCount = yCount - _coordinateAxisInsets.top - _coordinateAxisInsets.bottom;

    CGRect frame = CGRectMake(origin.x, origin.y, xCount * cell, yCount * cell);

    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}


- (void)initial {
    self.userInteractionEnabled = NO;
    _showAnimation = YES;
    _showCoordinateAxisLine = NO;
    _showCoordinateAxisGrid = NO;
    _valueSelectable = NO;


    _originPoint = CGPointMake(_coordinateAxisInsets.left * _coordinateAxisCellWidth,
            CGRectGetHeight(self.frame) - _coordinateAxisInsets.bottom * _coordinateAxisCellWidth);

    _contentView = [[UIView alloc] initWithFrame:CGRectMake(_coordinateAxisInsets.left * _coordinateAxisCellWidth,
            _coordinateAxisInsets.top * _coordinateAxisCellWidth,
            (_xCount - _coordinateAxisInsets.left - _coordinateAxisInsets.right) * _coordinateAxisCellWidth,
            (_yCount - _coordinateAxisInsets.top - _coordinateAxisInsets.bottom) * _coordinateAxisCellWidth)];
    [self addSubview:_contentView];
}

/**
 * 绘制表格线
 */
- (void)drawGrid {
    CGFloat GAP = _coordinateAxisCellWidth;
    NSUInteger ROW = _yAxisCellCount + _coordinateAxisInsets.top + _coordinateAxisInsets.bottom;
    NSUInteger COLUMN = _xAxisCellCount + _coordinateAxisInsets.left + _coordinateAxisInsets.right;

    UIBezierPath *path = [UIBezierPath bezierPath];


    CGFloat x = 0;
    CGFloat y = 0;

    for (NSUInteger i = 0; i < ROW + 1; ++i) {
        [path moveToPoint:CGPointMake(x, y)];
        [path addLineToPoint:CGPointMake(x + COLUMN * GAP, y)];

        y = y + GAP;
    }

    x = 0;
    y = 0;
    for (NSUInteger i = 0; i < COLUMN + 1; ++i) {
        [path moveToPoint:CGPointMake(x, y)];
        [path addLineToPoint:CGPointMake(x, y + ROW * GAP)];

        x = x + GAP;
    }


    self.gridLine.path = path.CGPath;
    if (!self.gridLine.superlayer) {
        [self.layer insertSublayer:self.gridLine atIndex:0];
    }
    self.gridLine.hidden = !self.showCoordinateAxisGrid;
}

#pragma mark - delay init

- (void)setValueSelectable:(BOOL)valueSelectable {
    _valueSelectable = valueSelectable;

    self.userInteractionEnabled = valueSelectable;
}


- (CAShapeLayer *)gridLine {
    if (!_gridLine) {
        _gridLine = [CAShapeLayer layer];
        _gridLine.strokeColor = DTRGBColor(0x686868, 1).CGColor;
        _gridLine.lineWidth = 0.5;
        _gridLine.fillColor = nil;
    }
    return _gridLine;
}


- (CAShapeLayer *)coordinateAxisLine {
    if (!_coordinateAxisLine) {
        _coordinateAxisLine = [self lineFactory];
    }
    return _coordinateAxisLine;
}

- (void)setCoordinateAxisInsets:(ChartEdgeInsets)coordinateAxisInsets {
    _coordinateAxisInsets = coordinateAxisInsets;

    _originPoint = CGPointMake(_coordinateAxisInsets.left, CGRectGetHeight(self.frame) - _coordinateAxisInsets.bottom);
    _xAxisCellCount = _xCount - _coordinateAxisInsets.left - _coordinateAxisInsets.right;
    _yAxisCellCount = _yCount - _coordinateAxisInsets.top - _coordinateAxisInsets.bottom;

    _contentView.frame = CGRectMake(_coordinateAxisInsets.left * _coordinateAxisCellWidth,
            _coordinateAxisInsets.top * _coordinateAxisCellWidth,
            CGRectGetWidth(self.frame) - (_coordinateAxisInsets.left + _coordinateAxisInsets.right) * _coordinateAxisCellWidth,
            CGRectGetHeight(self.frame) - (_coordinateAxisInsets.top + _coordinateAxisInsets.bottom) * _coordinateAxisCellWidth);
}

- (void)setShowCoordinateAxisGrid:(BOOL)showCoordinateAxisGrid {
    _showCoordinateAxisGrid = showCoordinateAxisGrid;

    if (showCoordinateAxisGrid) {
        [self drawGrid];
    } else {
        self.gridLine.hidden = !showCoordinateAxisGrid;
    }
}


- (CAShapeLayer *)lineFactory {
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = [UIColor blueColor].CGColor;
    lineLayer.fillColor = nil;
    return lineLayer;
}

- (void)setMultiData:(NSArray<DTChartSingleData *> *)multiData {
    _multiData = [multiData copy];

    _singleData = nil;
}

- (void)setSingleData:(DTChartSingleData *)singleData {
    _singleData = singleData;

    _multiData = nil;
}

#pragma mark - private method


#pragma mark - ###########主轴相关#############

- (void)generateMultiDataColors:(BOOL)needInitial {
    if (needInitial) {
        NSMutableArray<UIColor *> *existColors = [NSMutableArray arrayWithCapacity:self.multiData.count];
        for (DTChartSingleData *sData in self.multiData) {
            if (sData.color) {
                [existColors addObject:sData.color];
            }
        }
        self.colorManager = [DTColorManager randomManagerExistColors:existColors];
    }

    NSMutableArray<DTChartBlockModel *> *infos = [NSMutableArray arrayWithCapacity:self.multiData.count];

    for (DTChartSingleData *sData in self.multiData) {
        if (!sData.color) {
            sData.color = [self.colorManager getColor];
        }
        if (!sData.secondColor) {
            sData.secondColor = [self.colorManager getLightColor:sData.color];
        }

        DTChartBlockModel *blockModel = [[DTChartBlockModel alloc] init];
        blockModel.seriesId = sData.singleId;
        blockModel.color = sData.color;
        [infos addObject:blockModel];

    }
    if (infos.count > 0 && self.colorsCompletionBlock) {
        self.colorsCompletionBlock(infos);
    }
}


- (BOOL)drawXAxisLabels {
    if (self.xAxisLabelDatas.count <= 0) {
        DTLog(@"Error: x轴标签数量是0");
        return NO;
    }
    return YES;
}

- (BOOL)drawYAxisLabels {
    if (self.yAxisLabelDatas.count == 0) {
        DTLog(@"Error: y轴标签数量是0");
        return NO;
    }
    return YES;
}

- (void)drawAxisLine {

    // x axis line
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path moveToPoint:self.originPoint];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), self.originPoint.y)];

    // y axis line
    [path moveToPoint:self.originPoint];
    [path addLineToPoint:CGPointMake(self.originPoint.x, 0)];

    self.coordinateAxisLine.path = path.CGPath;
    self.coordinateAxisLine.hidden = !self.isShowCoordinateAxisLine;
    [self.layer addSublayer:self.coordinateAxisLine];
}

- (void)drawValues {
}

- (void)clearChartContent {
}

- (void)drawChart {
    if (!self.multiData && self.singleData) {
        self.multiData = @[self.singleData];
    }

    [self generateMultiDataColors:YES];


    [self clearChartContent];

    [self drawAxisLine];

    if ([self drawXAxisLabels] && [self drawYAxisLabels]) {
        [self drawValues];
    }
}

- (void)reloadChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
}

- (void)insertChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
    [self generateMultiDataColors:NO];
}

- (void)deleteChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
    NSMutableArray *datas = self.multiData.mutableCopy;
    [datas removeObjectsAtIndexes:indexes];
    self.multiData = datas;
}

#pragma mark - ###########副轴相关#############

- (void)setSecondSingleData:(DTChartSingleData *)secondSingleData {
    _secondSingleData = secondSingleData;

    _secondMultiData = nil;
}

- (void)setSecondMultiData:(NSArray<DTChartSingleData *> *)secondMultiData {
    _secondMultiData = [secondMultiData copy];

    _secondSingleData = nil;
}

- (void)clearSecondChartContent {
}

- (void)generateSecondMultiDataColors:(BOOL)needInitial {

    if (needInitial) {
        NSMutableArray<UIColor *> *existColors = [NSMutableArray arrayWithCapacity:self.multiData.count];
        for (DTChartSingleData *sData in self.multiData) {
            if (sData.color) {
                [existColors addObject:sData.color];
            }
        }
        self.colorManager = [DTColorManager randomManagerExistColors:existColors];
    }

    NSMutableArray<DTChartBlockModel *> *infos = [NSMutableArray arrayWithCapacity:self.multiData.count];

    for (DTChartSingleData *sData in self.secondMultiData) {
        if (!sData.color) {
            sData.color = [self.colorManager getColor];
        }
        if (!sData.secondColor) {
            sData.secondColor = [self.colorManager getLightColor:sData.color];
        }

        DTChartBlockModel *blockModel = [[DTChartBlockModel alloc] init];
        blockModel.seriesId = sData.singleId;
        blockModel.color = sData.color;
        [infos addObject:blockModel];
    }

    if (infos.count > 0 && self.secondAxisColorsCompletionBlock) {
        self.secondAxisColorsCompletionBlock(infos);
    }
}

- (BOOL)drawYSecondAxisLabels {
    if (self.ySecondAxisLabelDatas.count == 0) {
        DTLog(@"Error: y轴副轴标签数量是0");
        return NO;
    }

    return YES;
}

/**
 * 绘制副轴
 */
- (void)drawSecondValues {
}

- (void)drawSecondChart {
    [self clearSecondChartContent];

    if ([self drawYSecondAxisLabels]) {

        if (!self.secondMultiData && self.secondSingleData) {
            self.secondMultiData = @[self.secondSingleData];
        }

        [self generateSecondMultiDataColors:NO];

        [self drawSecondValues];
    }
}

- (void)reloadChartSecondAxisItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
}

- (void)insertChartSecondAxisItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
    [self generateSecondMultiDataColors:NO];
}

- (void)deleteChartSecondAxisItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
    NSMutableArray *datas = self.secondMultiData.mutableCopy;
    [datas removeObjectsAtIndexes:indexes];
    self.secondMultiData = datas;
}


@end
