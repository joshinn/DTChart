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

@interface DTDistributionBar ()

@property(nonatomic) NSArray<UIView *> *items;

@end

@implementation DTDistributionBar

static NSUInteger const DefaultSubItemCount = 24;

+ (instancetype)distributionBar {
    DTDistributionBar *bar = [[DTDistributionBar alloc] init];
    return bar;
}

- (instancetype)init {
    if (self = [super init]) {

        NSMutableArray<UIView *> *views = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < DefaultSubItemCount; ++i) {
            UIView *v = [UIView new];
            v.backgroundColor = DTDistributionLowLevelColor;
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

        UIView *view = self.items[i];

        [self.singleData.itemValues enumerateObjectsUsingBlock:^(DTChartItemData *obj, NSUInteger idx, BOOL *stop) {
            if (obj.itemValue.y == self.startHour + i) {
                view.backgroundColor = obj.color;
                *stop = YES;
            }
        }];

        view.frame = CGRectMake(0, itemY, CGRectGetWidth(self.frame) * 0.9f, itemHeight);

        itemY += itemHeight + gap;
        if ((i + 1) % 6 == 0) {
            itemY += sectionGap;
        }
    }
}


@end
