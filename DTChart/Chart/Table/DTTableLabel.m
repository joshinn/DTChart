//
//  DTTableLabel.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/6.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTTableLabel.h"

@implementation DTTableLabel

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    id <DTTableLabelDelegate> o = self.delegate;
    if (self.selectable && [o respondsToSelector:@selector(tableLabelTouchBegin:touch:)]) {
        UITouch *touch = [touches anyObject];
        [o tableLabelTouchBegin:self touch:touch];
    }


    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    id <DTTableLabelDelegate> o = self.delegate;
    if (self.selectable && [o respondsToSelector:@selector(tableLabelTouchEnd)]) {
        [o tableLabelTouchEnd];
    }

    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    id <DTTableLabelDelegate> o = self.delegate;
    if (self.selectable && [o respondsToSelector:@selector(tableLabelTouchEnd)]) {
        [o tableLabelTouchEnd];
    }

    [super touchesCancelled:touches withEvent:event];
}


@end
