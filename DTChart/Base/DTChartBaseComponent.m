//
//  DTChartBaseComponent.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"
#import "DTChartData.h"
#import "DTColorManager.h"

CGFloat const DefaultCoordinateAxisCellWidth = 15;

@interface DTChartBaseComponent ()

@property(nonatomic) CAShapeLayer *coordinateAxisLine;
@property(nonatomic) CAShapeLayer *gridLine;
@property (nonatomic) DTColorManager *colorManager;


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
    _showAnimation = YES;
    _showCoordinateAxis = YES;
    _showCoordinateAxisLine = NO;
    _showCoordinateAxisGrid = NO;
    _valueSelectable = NO;


    _originPoint = CGPointMake(_coordinateAxisInsets.left * _coordinateAxisCellWidth,
            CGRectGetHeight(self.frame) - _coordinateAxisInsets.bottom * _coordinateAxisCellWidth);

    _contentView = [[UIView alloc] initWithFrame:CGRectMake(_coordinateAxisInsets.left * _coordinateAxisCellWidth,
            _coordinateAxisInsets.top * _coordinateAxisCellWidth,
            (_xCount - _coordinateAxisInsets.left - _coordinateAxisInsets.right) * _coordinateAxisCellWidth,
            (_yCount - _coordinateAxisInsets.top - _coordinateAxisInsets.bottom) * _coordinateAxisCellWidth)];
    _contentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    [self addSubview:_contentView];
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];


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

- (CAShapeLayer *)gridLine {
    if (!_gridLine) {
        _gridLine = [CAShapeLayer layer];
        _gridLine.strokeColor = [UIColor lightGrayColor].CGColor;
        _gridLine.lineWidth = 1;
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
    } else{
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

#pragma mark - private method

/**
 * 给没有颜色的数据 生成数据
 */
-(void)generateColors{
    NSMutableArray<UIColor *> *colors = [NSMutableArray arrayWithCapacity:self.multiData.count];
    for(DTChartSingleData *sData in self.multiData){
        if(!sData.color){
            sData.color = [self.colorManager getColor];
            sData.secondColor = [self.colorManager getLightColor:sData.color];
        }
        [colors addObject:sData.color];
    }
    if(colors.count > 0 && self.colorsCompletionBlock){
        self.colorsCompletionBlock(colors);
    }
}



#pragma mark - public method

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

    self.colorManager = [DTColorManager manager];
    [self generateColors];


    [self clearChartContent];

    [self drawAxisLine];

    if ([self drawXAxisLabels] && [self drawYAxisLabels]) {
        [self drawValues];
    }
}

- (void)reloadChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
}

- (void)insertChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
    [self generateColors];
}

- (void)deleteChartItems:(NSIndexSet *)indexes withAnimation:(BOOL)animation {
}

@end
