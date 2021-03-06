//
//  DTChartToastView.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/2.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartToastView.h"

@interface DTChartToastView ()

@property(nonatomic) UILabel *titleLabel;

@end

@implementation DTChartToastView

- (instancetype)init {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    if (self = [super initWithEffect:effect]) {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.alpha = 0;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)show:(NSString *)message location:(CGPoint)point {
    CGFloat maxWidth = CGRectGetWidth(self.superview.bounds) / 2;
    maxWidth = MIN(maxWidth, 300);
    CGRect rect = [message boundingRectWithSize:CGSizeMake(maxWidth, 0)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName: _titleLabel.font}
                                        context:nil];
    
    [self.superview bringSubviewToFront:self];
    
    CGFloat width = CGRectGetWidth(rect) + 30;
    CGFloat height = CGRectGetHeight(rect) + 30;
    CGFloat x = point.x - 30 - width;
    CGFloat y = point.y - height - 30;
    if (x + width > CGRectGetMaxX(self.superview.bounds)) {
        x -= width + 60;
    }
    if (x < CGRectGetMinX(self.superview.bounds)) {
        x += width + 60;
    }
    
    if (y < 0) {
        y += height + 30;
    }
    if (y + height > CGRectGetMaxY(self.superview.bounds)) {
        y -= height + 30;
    }
    
    self.frame = CGRectMake(x, y, width, height);
    
    self.titleLabel.frame = CGRectMake(15, 15, width - 30, height - 30);
    
    self.titleLabel.text = message;
    
    self.hidden = NO;
    if (self.alpha < 1) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.alpha = 1;
        }                completion:^(BOOL finished) {
        }];
    }
}

- (void)hide {
    if (self.alpha == 0 || self.hidden) {
        return;
    }
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.alpha = 0;
    }                completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}


@end
