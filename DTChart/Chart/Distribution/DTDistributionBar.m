//
//  DTDistributionBar.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/3.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDistributionBar.h"
#import "DTChartData.h"
#import "DTColor.h"

NSUInteger const DTDistributionBarSectionGapRatio = 30;
NSUInteger const DTDistributionBarItemGap = 1;


@interface DTDistributionBarItemView : UIView

@property(nonatomic, getter=isSelectable) BOOL selectable;
@property(nonatomic) DTChartItemData *itemData;

@property(nonatomic, copy) void (^itemViewBeginTouch)(DTDistributionBarItemView *itemView);
@property(nonatomic, copy) void (^itemViewEndTouch)(DTDistributionBarItemView *itemView);

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isSelectable) {
        [self selectAnimation];

        if (self.itemViewBeginTouch) {
            self.itemViewBeginTouch(self);
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isSelectable) {
        [self deselectAnimation];

        if (self.itemViewEndTouch) {
            self.itemViewEndTouch(self);
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isSelectable) {
        [self deselectAnimation];

        if (self.itemViewEndTouch) {
            self.itemViewEndTouch(self);
        }
    }
}

@end


@interface DTDistributionBar ()

@property(nonatomic) NSArray<DTDistributionBarItemView *> *items;

@end

@implementation DTDistributionBar

static NSUInteger const DefaultSubItemCount = 24;

+ (instancetype)distributionBar {
    DTDistributionBar *bar = [[DTDistributionBar alloc] init];
    return bar;
}

- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;

        NSMutableArray<UIView *> *views = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < DefaultSubItemCount; ++i) {
            DTDistributionBarItemView *v = [DTDistributionBarItemView new];
            v.userInteractionEnabled = YES;
            v.backgroundColor = DTDistributionLowLevelColor;

            WEAK_SELF;
            [v setItemViewBeginTouch:^(DTDistributionBarItemView *itemView) {
                [weakSelf itemViewBeginTouch:itemView];
            }];
            [v setItemViewEndTouch:^(DTDistributionBarItemView *itemView) {
                [weakSelf itemViewEndTouch:itemView];
            }];
            [views addObject:v];
            [self addSubview:v];

        }
        _items = views.copy;
    }
    return self;
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
        view.selectable = self.selectable;

//        [self.singleData.itemValues enumerateObjectsUsingBlock:^(DTChartItemData *obj, NSUInteger idx, BOOL *stop) {
//            if (obj.itemValue.y == self.startHour + i) {
//                view.itemData = obj;
//                *stop = YES;
//            }
//        }];

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


- (void)itemViewEndTouch:(DTDistributionBarItemView *)itemView {
    CGPoint point = itemView.center;
    point = CGPointMake(point.x + CGRectGetMinX(self.frame), point.y + CGRectGetMinY(self.frame));

    id <DTDistributionBarDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(distributionBarItemEndTouch:data:location:)]) {
        [o distributionBarItemEndTouch:self.singleData data:itemView.itemData location:point];
    }
}


@end
