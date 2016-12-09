//
//  DTChartBaseComponent.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartBaseComponent.h"
#import "DTChartData.h"

CGFloat const DefaultCoordinateAxisCellWidth = 15;

@implementation DTChartBaseComponent


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    _showCoordinateAxis = YES;
    _showCoordinateAxisLine = YES;
    _coordinateAxisCellWidth = DefaultCoordinateAxisCellWidth;
    _coordinateAxisInsets = UIEdgeInsetsMake(0, DefaultCoordinateAxisCellWidth, DefaultCoordinateAxisCellWidth, DefaultCoordinateAxisCellWidth);

    _xAxisOriginValue = 0;
    _yAxisOriginValue = 0;

    _originPoint = CGPointMake(self.coordinateAxisInsets.left, CGRectGetHeight(self.frame) - self.coordinateAxisInsets.bottom);
    _xAxisLength = CGRectGetWidth(self.frame) - self.coordinateAxisInsets.left - self.coordinateAxisInsets.right;
    _yAxisLength = CGRectGetHeight(self.frame) - self.coordinateAxisInsets.top - self.coordinateAxisInsets.bottom;

    _contentView = [[UIView alloc] initWithFrame:CGRectMake(_coordinateAxisInsets.left, _coordinateAxisInsets.top,
            CGRectGetWidth(self.frame) - _coordinateAxisInsets.left - _coordinateAxisInsets.right,
            CGRectGetHeight(self.frame) - _coordinateAxisInsets.top - _coordinateAxisInsets.bottom)];
    [self addSubview:_contentView];
}

#pragma mark - delay init

- (CAShapeLayer *)coordinateAxisLine {
    if (!_coordinateAxisLine) {
        _coordinateAxisLine = [self lineFactory];
    }
    return _coordinateAxisLine;
}

- (void)setCoordinateAxisInsets:(UIEdgeInsets)coordinateAxisInsets {
    _coordinateAxisInsets = coordinateAxisInsets;

    self.originPoint = CGPointMake(self.coordinateAxisInsets.left, CGRectGetHeight(self.frame) - self.coordinateAxisInsets.bottom);
    self.xAxisLength = CGRectGetWidth(self.frame) - self.coordinateAxisInsets.left - self.coordinateAxisInsets.right;
    self.yAxisLength = CGRectGetHeight(self.frame) - self.coordinateAxisInsets.top - self.coordinateAxisInsets.bottom;

    self.contentView.frame = CGRectMake(_coordinateAxisInsets.left, _coordinateAxisInsets.top,
            CGRectGetWidth(self.frame) - _coordinateAxisInsets.left - _coordinateAxisInsets.right,
            CGRectGetHeight(self.frame) - _coordinateAxisInsets.top - _coordinateAxisInsets.bottom);
}

- (void)setCoordinateAxisCellWidth:(CGFloat)coordinateAxisCellWidth {
    _coordinateAxisCellWidth = coordinateAxisCellWidth;
}


- (CAShapeLayer *)lineFactory {
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 0.5;
    lineLayer.strokeColor = [UIColor blackColor].CGColor;
    lineLayer.fillColor = nil;
    return lineLayer;
}

#pragma mark - public method

- (void)drawChart {
}


@end
