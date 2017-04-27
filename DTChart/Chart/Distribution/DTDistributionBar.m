//
//  DTDistributionBar.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/3.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDistributionBar.h"
#import "DTChartData.h"

NSUInteger const DTDistributionBarSectionGapRatio = 30;
NSUInteger const DTDistributionBarItemGap = 1;


@interface DTDistributionBarItemView : UIView

@property(nonatomic) DTChartItemData *itemData;

- (void)selectAnimation;

- (void)deselectAnimation;
@end

@implementation DTDistributionBarItemView

- (void)setItemData:(DTChartItemData *)itemData {
    _itemData = itemData;

    self.backgroundColor = itemData.color;
}

- (void)selectAnimation {
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1.1, 1);
                     }
                     completion:nil];
}

- (void)deselectAnimation {
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1, 1);
                     }
                     completion:nil];
}

@end


@interface DTDistributionBar ()

@property(nonatomic) NSArray<DTDistributionBarItemView *> *items;

@property(nonatomic) NSInteger prevSelectedIndex;

@end

@implementation DTDistributionBar

static NSUInteger const DefaultSubItemCount = 24;

+ (instancetype)distributionBar {
    DTDistributionBar *bar = [[DTDistributionBar alloc] init];
    return bar;
}

- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = NO;

        NSMutableArray<UIView *> *views = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < DefaultSubItemCount; ++i) {
            DTDistributionBarItemView *v = [DTDistributionBarItemView new];
            v.userInteractionEnabled = YES;

            [views addObject:v];
            [self addSubview:v];

        }
        _items = views.copy;

        _prevSelectedIndex = -1;
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

    for (NSUInteger i = 0; i < self.subviews.count; ++i) {
        DTDistributionBarItemView *v = self.subviews[i];

        if (CGRectContainsPoint(v.frame, touchPoint)) {
            [v selectAnimation];
            [self itemViewBeginTouch:v];

            self.prevSelectedIndex = i;
            break;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

    BOOL containsPoint = NO;
    for (NSUInteger i = 0; i < self.subviews.count; ++i) {
        DTDistributionBarItemView *v = self.subviews[i];
        if (CGRectContainsPoint(v.frame, touchPoint)) {
            containsPoint = YES;

            if (i == self.prevSelectedIndex) {
                break;
            } else {
                if (self.prevSelectedIndex >= 0 && self.prevSelectedIndex < self.subviews.count) {
                    DTDistributionBarItemView *prevView = self.subviews[(NSUInteger) self.prevSelectedIndex];
                    [prevView deselectAnimation];
                }

                [v selectAnimation];
                [self itemViewBeginTouch:v];

                self.prevSelectedIndex = i;

                break;
            }
        }
    }

    if (!containsPoint) {
        if (self.prevSelectedIndex >= 0 && self.prevSelectedIndex < self.subviews.count) {
            DTDistributionBarItemView *prevView = self.subviews[(NSUInteger) self.prevSelectedIndex];
            [prevView deselectAnimation];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

    BOOL containsPoint = NO;
    for (DTDistributionBarItemView *v in self.subviews) {
        if (CGRectContainsPoint(v.frame, touchPoint)) {
            containsPoint = YES;

            [v deselectAnimation];
            [self itemViewEndTouch];
            break;
        }
    }

    if (self.prevSelectedIndex >= 0 && self.prevSelectedIndex < self.subviews.count) {
        DTDistributionBarItemView *prevView = self.subviews[(NSUInteger) self.prevSelectedIndex];
        [prevView deselectAnimation];

        if (!containsPoint) {
            [self itemViewEndTouch];
        }
    }
    self.prevSelectedIndex = -1;

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

    BOOL containsPoint = NO;
    for (DTDistributionBarItemView *v in self.subviews) {
        if (CGRectContainsPoint(v.frame, touchPoint)) {
            containsPoint = YES;

            [v deselectAnimation];
            [self itemViewEndTouch];
            break;
        }
    }

    if (self.prevSelectedIndex >= 0 && self.prevSelectedIndex < self.subviews.count) {
        DTDistributionBarItemView *prevView = self.subviews[(NSUInteger) self.prevSelectedIndex];
        [prevView deselectAnimation];

        if (!containsPoint) {
            [self itemViewEndTouch];
        }
    }
    self.prevSelectedIndex = -1;

}

/**
 * 布局每个小方块
 */
- (void)drawSubItems {

    CGFloat gap = DTDistributionBarItemGap;
    CGFloat sectionGap = CGRectGetHeight(self.frame) / DTDistributionBarSectionGapRatio;
    CGFloat itemHeight = (CGRectGetHeight(self.frame) - gap * self.items.count - sectionGap * 3) / self.items.count;
    CGFloat itemY = 0;


    for (NSUInteger i = 0; i < self.items.count; ++i) {

        DTDistributionBarItemView *view = self.items[i];

        for (DTChartItemData *obj in self.singleData.itemValues) {
            if (obj.itemValue.y == (self.startHour + i) % 24) {
                view.itemData = obj;
                break;
            }
        }

        view.frame = CGRectMake(0, itemY, CGRectGetWidth(self.frame) * 0.9f, itemHeight);

        itemY += itemHeight + gap;
        if ((i + 1) % 6 == 0) {
            itemY += sectionGap;
        }
    }
}

- (void)itemViewBeginTouch:(DTDistributionBarItemView *)itemView {
    CGPoint point = itemView.center;
    point = CGPointMake(point.x + CGRectGetMinX(self.frame), point.y + CGRectGetMinY(self.frame));

    id <DTDistributionBarDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(distributionBarItemBeginTouch:data:location:)]) {
        [o distributionBarItemBeginTouch:self.singleData data:itemView.itemData location:point];
    }
}


- (void)itemViewEndTouch {
    id <DTDistributionBarDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(distributionBarItemEndTouch)]) {
        [o distributionBarItemEndTouch];
    }
}


@end
