//
//  DTBar.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTBar.h"
#import "DTChartData.h"

@interface DTBar ()

@property(nonatomic) CGRect barFrame;
@property(nonatomic) CGRect barFrontViewFrame;

@property(nonatomic) UIView *barFrontView;

@end

@implementation DTBar

static CGFloat const DTBarTopBorderWidth = 5;
static CGFloat const DTBarSidesBorderWidth = 2;

+ (instancetype)bar {
    return [DTBar bar:DTBarOrientationUp style:DTBarBorderStyleTopBorder];
}

+ (instancetype)bar:(DTBarOrientation)orientation style:(DTBarBorderStyle)style {
    DTBar *bar = [[DTBar alloc] init];
    bar.barOrientation = orientation;
    bar.barBorderStyle = style;
    return bar;
}


- (instancetype)init {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;

        _barColor = [UIColor orangeColor];
        _barBorderColor = [UIColor blueColor];

        self.backgroundColor = _barBorderColor;

        if (_barBorderStyle != DTBarBorderStyleNone) {

            _barFrontView = [[UIView alloc] initWithFrame:CGRectZero];
            _barFrontView.backgroundColor = _barColor;

            [self addSubview:_barFrontView];
        }

    }
    return self;
}

- (void)setBarOrientation:(DTBarOrientation)barOrientation {
    _barOrientation = barOrientation;
}

- (void)setBarBorderStyle:(DTBarBorderStyle)barStyle {
    _barBorderStyle = barStyle;

    if (_barBorderStyle != DTBarBorderStyleNone) {

        _barFrontView = [[UIView alloc] initWithFrame:CGRectZero];
        _barFrontView.backgroundColor = _barColor;

        [self addSubview:_barFrontView];
    } else {
        [_barFrontView removeFromSuperview];
        _barFrontView = nil;
    }
}

- (void)setBarColor:(UIColor *)barColor {
    _barColor = barColor;

    if (_barBorderStyle == DTBarBorderStyleNone) {
        self.backgroundColor = barColor;
    } else {
        self.barFrontView.backgroundColor = barColor;
    }
}

- (void)setBarBorderColor:(UIColor *)barBorderColor {
    _barBorderColor = barBorderColor;

    if (_barBorderStyle == DTBarBorderStyleNone) {
        self.barFrontView.backgroundColor = barBorderColor;
    } else {
        self.backgroundColor = barBorderColor;
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    [self resizeBarSubviewFrame];
}

#pragma mark - private method

- (void)resizeBarSubviewFrame {

    switch (self.barOrientation) {

        case DTBarOrientationUp: {
            if (self.barBorderStyle == DTBarBorderStyleNone) {
//                self.barFrontView.frame = self.bounds;

            } else if (self.barBorderStyle == DTBarBorderStyleTopBorder) {
                self.barFrontView.frame = CGRectMake(0, DTBarTopBorderWidth, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - DTBarTopBorderWidth);
            } else if (self.barBorderStyle == DTBarBorderStyleSidesBorder) {
                self.barFrontView.frame = CGRectMake(DTBarSidesBorderWidth, 0, CGRectGetWidth(self.frame) - DTBarSidesBorderWidth * 2, CGRectGetHeight(self.frame));
            }
        }
            break;

//        case DTBarOrientationDown: {
//            if (self.barBorderStyle == DTBarBorderStyleTopBorder) {
//                self.barFrontView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - DTBarTopBorderWidth);
//            } else if (self.barBorderStyle == DTBarBorderStyleSidesBorder) {
//                self.barFrontView.frame = CGRectMake(DTBarSidesBorderWidth, 0, CGRectGetWidth(self.frame) - DTBarSidesBorderWidth * 2, CGRectGetHeight(self.frame));
//            }
//        }
//            break;
//        case DTBarOrientationLeft: {
//            if (self.barBorderStyle == DTBarBorderStyleTopBorder) {
//                self.barFrontView.frame = CGRectMake(DTBarTopBorderWidth, 0, CGRectGetWidth(self.frame) - DTBarTopBorderWidth, CGRectGetHeight(self.frame));
//            } else if (self.barBorderStyle == DTBarBorderStyleSidesBorder) {
//                self.barFrontView.frame = CGRectMake(0, DTBarSidesBorderWidth, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - DTBarSidesBorderWidth * 2);
//            }
//        }
//            break;

        case DTBarOrientationRight: {
            if (self.barBorderStyle == DTBarBorderStyleNone) {
//                self.barFrontView.frame = self.bounds;

            } else if (self.barBorderStyle == DTBarBorderStyleTopBorder) {
                self.barFrontView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) - DTBarTopBorderWidth, CGRectGetHeight(self.frame));
            } else if (self.barBorderStyle == DTBarBorderStyleSidesBorder) {
                self.barFrontView.frame = CGRectMake(0, DTBarSidesBorderWidth, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - DTBarSidesBorderWidth * 2);
            }
        }
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    if (self.userInteractionEnabled) {
        [self barSelected];
    }
}

/**
 * 选择了当前柱状体
 */
- (void)barSelected {

    [self startSelectedAnimation];

    id <DTBarDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(_DTBarSelected:)]) {
        [o _DTBarSelected:self];
    }
}

#pragma mark - public method

- (void)startAppearAnimation {
    self.barFrame = self.frame;
    self.barFrontViewFrame = self.barFrontView.frame;

    CGRect fromFrame = self.barFrame;
//    CGRect frontViewFromFrameFront = self.barFrontViewFrame;

    switch (self.barOrientation) {

        case DTBarOrientationUp: {
            fromFrame = CGRectMake(CGRectGetMinX(self.barFrame), CGRectGetMaxY(self.barFrame), CGRectGetWidth(self.barFrame), 0);
        }
            break;
//        case DTBarOrientationDown: {
//            fromFrame = CGRectMake(CGRectGetMinX(self.barFrame), 0, CGRectGetWidth(self.barFrame), 0);
//        }
//
//            break;
//        case DTBarOrientationLeft: {
//            fromFrame = CGRectMake(CGRectGetMaxX(self.barFrame), CGRectGetMinY(self.barFrame), 0, CGRectGetHeight(self.barFrame));
//        }
//            break;
        case DTBarOrientationRight: {
            fromFrame = CGRectMake(CGRectGetMinX(self.barFrame), CGRectGetMinY(self.barFrame), 0, CGRectGetHeight(self.barFrame));
        }
            break;
    }
    self.frame = fromFrame;
    self.hidden = NO;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = self.barFrame;
    }                completion:^(BOOL finished) {

    }];
}

- (void)startSelectedAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];

    animation.fromValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = @1.1;
    animation.duration = 0.2;
    animation.repeatCount = 0;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;

    [self.layer addAnimation:animation forKey:@"Float"];
}

@end
