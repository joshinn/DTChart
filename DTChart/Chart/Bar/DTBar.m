//
//  DTBar.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTBar.h"

@interface DTBar ()

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
    DTBar *bar = [[self alloc] init];
    bar.barOrientation = orientation;
    bar.barBorderStyle = style;
    return bar;
}


- (instancetype)init {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = NO;

        _barColor = [UIColor orangeColor];
        _barBorderColor = [UIColor blueColor];

        self.backgroundColor = _barBorderColor;

    }
    return self;
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

- (void)relayoutSubviews {
    if (self.barBorderStyle == DTBarBorderStyleNone) {
        return;
    }

    switch (self.barOrientation) {

        case DTBarOrientationUp: {
            if (self.barBorderStyle == DTBarBorderStyleTopBorder) {
                self.barFrontView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), DTBarTopBorderWidth);
            } else if (self.barBorderStyle == DTBarBorderStyleSidesBorder) {
                self.barFrontView.frame = CGRectMake(DTBarSidesBorderWidth, 0, CGRectGetWidth(self.bounds) - DTBarSidesBorderWidth * 2, CGRectGetHeight(self.bounds));
            }
        }
            break;

        case DTBarOrientationRight: {
            if (self.barBorderStyle == DTBarBorderStyleTopBorder) {
                self.barFrontView.frame = CGRectMake(CGRectGetMaxX(self.bounds) - DTBarTopBorderWidth, 0, DTBarTopBorderWidth, CGRectGetHeight(self.bounds));
            } else if (self.barBorderStyle == DTBarBorderStyleSidesBorder) {
                self.barFrontView.frame = CGRectMake(0, DTBarSidesBorderWidth, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - DTBarSidesBorderWidth * 2);
            }
        }
            break;
        case DTBarOrientationLeft: {
            if (self.barBorderStyle == DTBarBorderStyleTopBorder) {
                self.barFrontView.frame = CGRectMake(0, 0, DTBarTopBorderWidth, CGRectGetHeight(self.bounds));
            } else if (self.barBorderStyle == DTBarBorderStyleSidesBorder) {
                self.barFrontView.frame = CGRectMake(0, DTBarSidesBorderWidth, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - DTBarSidesBorderWidth * 2);
            }
        }
            break;
        case DTBarOrientationDown: {
            if (self.barBorderStyle == DTBarBorderStyleTopBorder) {
                self.barFrontView.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - DTBarTopBorderWidth, CGRectGetWidth(self.bounds), DTBarTopBorderWidth);
            } else if (self.barBorderStyle == DTBarBorderStyleSidesBorder) {
                self.barFrontView.frame = CGRectMake(DTBarSidesBorderWidth, 0, CGRectGetWidth(self.bounds) - DTBarSidesBorderWidth * 2, CGRectGetHeight(self.bounds));
            }
        }
            break;
    }
}

#pragma mark - public method

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
        case DTBarOrientationLeft: {
            fromFrame = CGRectMake(CGRectGetMaxX(self.prevBarFrame), CGRectGetMinY(self.prevBarFrame), 0, CGRectGetHeight(self.prevBarFrame));
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
                [subviewFrame addObject:NSStringFromCGRect(obj.frame)];
                obj.frame = CGRectMake(0, 0, 0, CGRectGetHeight(self.bounds));
            }];
        }
            break;
        case DTBarOrientationDown:{
            fromFrame = CGRectMake(CGRectGetMinX(self.prevBarFrame), CGRectGetMinY(self.prevBarFrame), CGRectGetWidth(self.prevBarFrame), 0);
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
                [subviewFrame addObject:NSStringFromCGRect(obj.frame)];
                obj.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0);
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

@end
