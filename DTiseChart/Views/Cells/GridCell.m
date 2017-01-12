//
//  GridCell.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/11.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "GridCell.h"

@interface GridCell ()


@end

@implementation GridCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self drawGrid];
        [self layoutButtons];
    }
    return self;
}

- (CAShapeLayer *)gridLineFactory:(NSUInteger)color {
    CAShapeLayer *line = [CAShapeLayer layer];
    line.strokeColor = DTRGBColor(color, 1).CGColor;
    line.lineWidth = 0.5;
    line.fillColor = nil;

    return line;
}


/**
 * 绘制表格线
 */
- (void)drawGrid {
    CAShapeLayer *gridLine = [self gridLineFactory:0x404040];
    CAShapeLayer *grid2Line = [self gridLineFactory:0x848484];

    CGFloat GAP = 15;
    NSUInteger ROW = (NSUInteger) (CGRectGetHeight(self.contentView.bounds) / 15);

    NSUInteger COLUMN = (NSUInteger) (CGRectGetWidth(self.contentView.bounds) / 15);;

    UIBezierPath *path = [UIBezierPath bezierPath];

    CGFloat x = 0;
    CGFloat y = GAP;

    for (NSUInteger i = 0; i < ROW - 1; ++i) {
        [path moveToPoint:CGPointMake(x, y)];
        [path addLineToPoint:CGPointMake(x + COLUMN * GAP, y)];

        y = y + GAP;
    }

    x = GAP;
    y = 0;
    for (NSUInteger i = 0; i < COLUMN - 1; ++i) {
        [path moveToPoint:CGPointMake(x, y)];
        [path addLineToPoint:CGPointMake(x, y + ROW * GAP)];

        x = x + GAP;
    }

    gridLine.path = path.CGPath;
    [self.contentView.layer insertSublayer:gridLine atIndex:0];

    [path removeAllPoints];

    x = GAP;
    y = GAP;

    for (NSUInteger i = 0; i < ROW - 1; ++i) {
        [path moveToPoint:CGPointMake(x, y)];
        [path addLineToPoint:CGPointMake(x + (COLUMN - 2) * GAP, y)];

        y = y + GAP;
    }

    x = GAP;
    y = GAP;
    for (NSUInteger i = 0; i < COLUMN - 1; ++i) {
        [path moveToPoint:CGPointMake(x, y)];
        [path addLineToPoint:CGPointMake(x, y + (ROW - 2) * GAP)];

        x = x + GAP;
    }

    grid2Line.path = path.CGPath;
    [self.contentView.layer insertSublayer:grid2Line above:gridLine];
}

/**
 * 添加按钮
 */
- (void)layoutButtons {
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 30 * 4, 15, 28, 28)];
    addBtn.tag = 101;
    [addBtn setImage:[UIImage imageNamed:@"addBtn"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addBtn];

    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 30 * 2, 15, 28, 28)];
    delBtn.tag = 102;
    [delBtn setImage:[UIImage imageNamed:@"delBtn"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:delBtn];
}


- (void)handleButtonEvent:(UIButton *)sender {
    if (sender.tag == 101) {
        [self.delegate gridCellAdd:self];
    } else if (sender.tag == 102) {
        [self.delegate gridCellDel:self];
    }
}

@end
