//
//  DTChartScrollView.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/6.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartScrollView.h"

@implementation DTChartScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.selectable && self.scrollViewTouchBegin) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        self.scrollViewTouchBegin(point);
    }

    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.selectable && self.scrollViewTouchEnd) {
        self.scrollViewTouchEnd();
    }

    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.selectable && self.scrollViewTouchEnd) {
        self.scrollViewTouchEnd();
    }

    [super touchesCancelled:touches withEvent:event];
}
@end
