//
//  DTChartBaseComponent.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"

CGFloat const DefaultCoordinateAxisCellWidth = 15;

@interface DTChartBaseComponent ()

@property(nonatomic) CAShapeLayer *coordinateAxisLine;

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
    _showCoordinateAxisLine = YES;
    _showCoordinateAxisGrid = NO;



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


    CAShapeLayer *girdLine = [CAShapeLayer layer];
    girdLine.strokeColor = [UIColor lightGrayColor].CGColor;
    girdLine.lineWidth = 1;
    girdLine.fillColor = nil;
    girdLine.path = path.CGPath;
    [self.layer insertSublayer:girdLine atIndex:0];

    girdLine.hidden = NO;
}

#pragma mark - delay init

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

    [self drawGrid];
}


- (CAShapeLayer *)lineFactory {
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = [UIColor blueColor].CGColor;
    lineLayer.fillColor = nil;
    return lineLayer;
}

#pragma mark - public method

- (void)drawChart {

}


@end
