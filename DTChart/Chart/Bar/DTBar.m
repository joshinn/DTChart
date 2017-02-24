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


@property(nonatomic) CGRect barFrontViewFrame;
@property(nonatomic) CGRect prevBarFrame;
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
        _barSelectable = NO;

        _barColor = [UIColor orangeColor];
        _barBorderColor = [UIColor blueColor];

        self.backgroundColor = _barBorderColor;

    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    if (self.isBarSelectable) {
        [self barDidSelected];
    }
}


- (void)setBarBorderStyle:(DTBarBorderStyle)barBorderStyle {
    _barBorderStyle = barBorderStyle;

    if (self.barBorderStyle != DTBarBorderStyleNone) {

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

    if (self.barBorderStyle == DTBarBorderStyleNone) {
        self.backgroundColor = barColor;
    } else {
        self.barFrontView.backgroundColor = barColor;
    }
}

- (void)setBarBorderColor:(UIColor *)barBorderColor {
    _barBorderColor = barBorderColor;

    if (self.barBorderStyle == DTBarBorderStyleNone) {
        self.barFrontView.backgroundColor = barBorderColor;
    } else {
        self.backgroundColor = barBorderColor;
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    [self relayoutSubviews];
}

#pragma mark - public method

- (void)relayoutSubviews {
    if (self.barBorderStyle == DTBarBorderStyleNone) {
        return;
    }

    switch (self.barOrientation) {

        case DTBarOrientationUp: {
            if (self.barBorderStyle == DTBarBorderStyleTopBorder) {
                self.barFrontView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), DTBarTopBorderWidth);
            } else if (self.barBorderStyle == DTBarBorderStyleSidesBorder) {
                self.barFrontView.frame = CGRectMake(DTBarSidesBorderWidth, 0, CGRectGetWidth(self.frame) - DTBarSidesBorderWidth * 2, CGRectGetHeight(self.frame));
            }
        }
            break;

        case DTBarOrientationRight: {
            if (self.barBorderStyle == DTBarBorderStyleTopBorder) {
                self.barFrontView.frame = CGRectMake(CGRectGetWidth(self.frame) - DTBarTopBorderWidth, 0, DTBarTopBorderWidth, CGRectGetHeight(self.frame));
            } else if (self.barBorderStyle == DTBarBorderStyleSidesBorder) {
                self.barFrontView.frame = CGRectMake(0, DTBarSidesBorderWidth, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - DTBarSidesBorderWidth * 2);
            }
        }
            break;
    }
}


- (void)barDidSelected {

    [self startSelectedAnimation];

    id <DTBarDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(_DTBarSelected:)]) {
        [o _DTBarSelected:self];
    }
}

- (void)startAppearAnimation {
    self.prevBarFrame = self.frame;

    CGRect fromFrame = self.prevBarFrame;

    NSMutableArray<NSString *> *subviewFrame = [NSMutableArray arrayWithCapacity:self.subviews.count];


    switch (self.barOrientation) {

        case DTBarOrientationUp: {
            fromFrame = CGRectMake(CGRectGetMinX(self.prevBarFrame), CGRectGetMaxY(self.prevBarFrame), CGRectGetWidth(self.prevBarFrame), 0);
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
                [subviewFrame addObject:NSStringFromCGRect(obj.frame)];
                obj.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0);
            }];
        }
            break;

        case DTBarOrientationRight: {
            fromFrame = CGRectMake(CGRectGetMinX(self.prevBarFrame), CGRectGetMinY(self.prevBarFrame), 0, CGRectGetHeight(self.prevBarFrame));
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
                [subviewFrame addObject:NSStringFromCGRect(obj.frame)];
                obj.frame = CGRectMake(0, 0, 0, CGRectGetHeight(self.bounds));
            }];
        }
            break;
    }
    self.frame = fromFrame;
    self.hidden = NO;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = self.prevBarFrame;
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
            obj.frame = CGRectFromString(subviewFrame[idx]);
        }];
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
