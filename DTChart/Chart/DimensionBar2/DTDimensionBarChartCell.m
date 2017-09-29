//
//  DTDimensionBarChartCell.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBarChartCell.h"
#import "DTDimensionSectionLine.h"
#import "DTTableLabel.h"
#import "DTDimension2HeapBar.h"
#import "DTDimension2Bar.h"
#import "DTBarChart.h"

@interface DTDimensionBarChartCell ()

@property(nonatomic) DTDimension2HeapBar *mainBar;
@property(nonatomic) DTDimension2HeapBar *secondBar;

@property(nonatomic) NSMutableArray<DTChartLabel *> *labels;

@property(nonatomic) DTDimensionSectionLine *sectionLine;
/**
 * 记录触摸的subBBar对应的数据
 */
@property(nonatomic) DTDimension2Item *touchedItemData;
/**
 * 触摸时，在第一度量subBar上高亮的view
 */
@property(nonatomic) UIView *touchMainHighlightedView;
/**
 * 触摸时，在第二度量subBar上高亮的view
 */
@property(nonatomic) UIView *touchSecondHighlightedView;

@property(nonatomic) DTDimension2Model *mainData;

@end

@implementation DTDimensionBarChartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        _mainBar = [DTDimension2HeapBar bar:DTBarOrientationRight style:DTBarBorderStyleNone];
        _mainBar.barColor = MainBarColor;
        _mainBar.barBorderColor = MainBarBorderColor;
        [self.contentView addSubview:_mainBar];

        _secondBar = [DTDimension2HeapBar bar:DTBarOrientationRight style:DTBarBorderStyleNone];
        _secondBar.barColor = SecondBarColor;
        _secondBar.barBorderColor = SecondBarBorderColor;
        [self.contentView addSubview:_secondBar];

        _sectionLine = [DTDimensionSectionLine layer];
        [self.contentView.layer addSublayer:_sectionLine];

        _touchMainHighlightedView = [UIView new];
        _touchMainHighlightedView.hidden = YES;
        _touchMainHighlightedView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [self.contentView addSubview:_touchMainHighlightedView];

        _touchSecondHighlightedView = [UIView new];
        _touchSecondHighlightedView.hidden = YES;
        _touchSecondHighlightedView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [self.contentView addSubview:_touchSecondHighlightedView];

    }
    return self;
}

- (NSMutableArray<DTChartLabel *> *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (DTChartLabel *)labelFactory {
    DTChartLabel *label = [DTChartLabel chartLabel];
    label.font = [UIFont systemFontOfSize:TitleLabelFontSize];
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = NO;
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentRight;

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [label addGestureRecognizer:swipeLeft];

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [label addGestureRecognizer:swipeRight];

    return label;
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)sender {

    id <DTDimensionBarChartCellDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(chartCellCanLeftSwipe:)]) {
        if (![delegate chartCellCanLeftSwipe:self]) {
            return;
        }
    } else {
        return;
    }

    NSLog(@"swipe left");
    UILabel *label = (UILabel *) sender.view;

    [UIView animateKeyframesWithDuration:0.55 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{

        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations:^{
            label.transform = CGAffineTransformMakeTranslation(-20, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.55 animations:^{
            label.transform = CGAffineTransformMakeTranslation(15, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.55 relativeDuration:0.8 animations:^{
            label.transform = CGAffineTransformMakeTranslation(-10, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.95 animations:^{
            label.transform = CGAffineTransformMakeTranslation(5, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.95 relativeDuration:1 animations:^{
            label.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }                         completion:nil];

    NSString *name = label.text;
    NSInteger dimensionIndex = -1;
    for (NSUInteger idx = 0; idx < self.mainData.roots.count; ++idx) {
        DTDimension2Item *item = self.mainData.roots[idx];
        if ([name isEqualToString:item.name]) {
            dimensionIndex = idx;
            break;
        }
    }

    id <DTDimensionBarChartCellDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(chartCellLeftSwipe:data:dimensionIndex:)]) {
        [o chartCellLeftSwipe:self data:self.mainData dimensionIndex:dimensionIndex];
    }
}

- (void)swipeRight:(UISwipeGestureRecognizer *)sender {
    id <DTDimensionBarChartCellDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(chartCellCanRightSwipe:)]) {
        if (![delegate chartCellCanRightSwipe:self]) {
            return;
        }
    } else {
        return;
    }

    NSLog(@"swipe right");
    UILabel *label = (UILabel *) sender.view;
    [UIView animateKeyframesWithDuration:0.55 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{

        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations:^{
            label.transform = CGAffineTransformMakeTranslation(20, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.55 animations:^{
            label.transform = CGAffineTransformMakeTranslation(-15, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.55 relativeDuration:0.8 animations:^{
            label.transform = CGAffineTransformMakeTranslation(10, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.95 animations:^{
            label.transform = CGAffineTransformMakeTranslation(-5, 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.95 relativeDuration:1 animations:^{
            label.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }                         completion:nil];

    NSString *name = label.text;
    NSInteger dimensionIndex = -1;
    for (NSUInteger idx = 0; idx < self.mainData.roots.count; ++idx) {
        DTDimension2Item *item = self.mainData.roots[idx];
        if ([name isEqualToString:item.name]) {
            dimensionIndex = idx;
            break;
        }
    }
    id <DTDimensionBarChartCellDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(chartCellRightSwipe:data:dimensionIndex:)]) {
        [o chartCellRightSwipe:self data:self.mainData dimensionIndex:dimensionIndex];
    }
}

#pragma mark - public method

- (void)setCellData:(DTDimension2Model *)mainData second:(DTDimension2Model *)secondData prev:(DTDimension2Model *)prevData next:(DTDimension2Model *)nextData {
    _mainData = mainData;

    BOOL isSingleDimension = NO;    ///< 是单维度，单维度下，默认每个维度名称都不一致，无需隐藏
    if (self.chartStyle == DTBarChartStyleStartingLine) {
        if (mainData.roots.count == 1) {
            isSingleDimension = YES;
        }
    } else if (self.chartStyle == DTBarChartStyleHeap) {
        if (mainData.roots.count == 0) {
            isSingleDimension = YES;
        }
    }

    if (self.labels.count != mainData.roots.count) {
        [self.labels enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        [self.labels removeAllObjects];

        CGFloat x = 0;
        for (NSUInteger i = 0; i < mainData.roots.count; ++i) {
            DTChartLabel *label = [self labelFactory];
            CGFloat width = self.titleWidths[i].floatValue;
            label.frame = CGRectMake(x, 0, width, 15);
            x += width + self.titleGap;

            [self.labels addObject:label];
            [self.contentView addSubview:label];
        }
    } else {
        CGFloat x = 0;
        for (NSUInteger i = 0; i < mainData.roots.count; ++i) {
            DTChartLabel *label = self.labels[i];
            CGFloat width = self.titleWidths[i].floatValue;
            label.frame = CGRectMake(x, 0, width, 15);
            x += width + self.titleGap;
        }
    }

    BOOL align = NO;
    NSMutableString *mutablePrevName = [NSMutableString string];
    NSMutableString *mutableName = [NSMutableString string];
    NSMutableString *mutableNextName = [NSMutableString string];

    for (NSUInteger i = 0; i < mainData.roots.count; ++i) {
        NSString *prevName = prevData.roots[i].name;
        NSString *name = mainData.roots[i].name;
        NSString *nextName = nextData.roots[i].name;

        if (prevName) {
            [mutablePrevName appendString:prevName];
        }
        if (name) {
            [mutableName appendString:name];
        }
        if (nextName) {
            [mutableNextName appendString:nextName];
        }

        if ([mutablePrevName isEqualToString:mutableName] && !isSingleDimension) {
            self.labels[i].text = nil;
        } else {
            self.labels[i].text = name;
        }

        self.sectionLine.hidden = nextName == nil;
        if (!align && ![mutableName isEqualToString:mutableNextName]) {
            align = YES;

            self.sectionLine.hidden = (i == mainData.roots.count - 1);

            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.sectionLine.frame = CGRectMake(CGRectGetMinX(self.labels[i].frame), 22, self.cellSize.width, 2);
            [CATransaction commit];
        }

        if (isSingleDimension) {
            self.sectionLine.hidden = YES;
        }
    }

    [self.mainBar resetBar];
    for (DTDimension2Item *item in mainData.items) {
        CGFloat barWidth = 0;
        if (item.value >= 0) {
            barWidth = item.value / self.mainPositiveLimitValue * (self.mainPositiveLimitX - self.mainZeroX);
        } else {
            barWidth = -item.value / self.mainNegativeLimitValue * (self.mainZeroX - self.mainNegativeLimitX);
        }
        self.mainBar.frame = CGRectMake(self.mainZeroX, 0, 0, 15);
        UIColor *color = [self.delegate chartCellRequestItemColor:item isMainAxis:YES];
        if (!color) {
            color = [UIColor colorWithRed:(arc4random_uniform(255) / 255.f) green:(arc4random_uniform(255) / 255.f) blue:(arc4random_uniform(255) / 255.f) alpha:1];
        }
        [self.mainBar appendData:item barLength:barWidth barColor:color needLayout:item == mainData.items.lastObject];
    }

    // 处理第一度量自动高亮
    {
        DTDimension2Bar *subBar = [self.mainBar subBarFromTitle:self.highlightTitle];
        if (subBar) {
            CGRect frame = subBar.frame;
            frame.origin.x += CGRectGetMinX(self.mainBar.frame);
            if (frame.size.width < 1) {
                frame.origin.x -= (1 - frame.size.width) / 2;
                frame.size.width = 1;
            }

            self.touchMainHighlightedView.frame = frame;
            self.touchMainHighlightedView.hidden = NO;
        } else {
            self.touchMainHighlightedView.hidden = YES;
        }
    }


    if (secondData) {
        [self.secondBar resetBar];

        self.secondBar.hidden = NO;
        for (DTDimension2Item *item in secondData.items) {
            CGFloat barWidth = 0;
            if (item.value >= 0) {
                barWidth = item.value / self.secondPositiveLimitValue * (self.secondPositiveLimitX - self.secondZeroX);
            } else {
                barWidth = -item.value / self.secondNegativeLimitValue * (self.secondZeroX - self.secondNegativeLimitX);
            }
            self.secondBar.frame = CGRectMake(self.secondZeroX, 0, 0, 15);
            UIColor *color = [self.delegate chartCellRequestItemColor:item isMainAxis:NO];
            if (!color) {
                color = [UIColor colorWithRed:(arc4random_uniform(255) / 255.f) green:(arc4random_uniform(255) / 255.f) blue:(arc4random_uniform(255) / 255.f) alpha:1];
            }
            [self.secondBar appendData:item barLength:barWidth barColor:color needLayout:item == secondData.items.lastObject];
        }
    } else {
        self.secondBar.hidden = YES;
    }

    // 处理第二度量自动高亮
    if (!self.secondBar.hidden) {
        DTDimension2Bar *subBar = [self.secondBar subBarFromTitle:self.highlightTitle];
        if (subBar) {
            CGRect frame = subBar.frame;
            frame.origin.x += CGRectGetMinX(self.secondBar.frame);
            if (frame.size.width < 1) {
                frame.origin.x -= (1 - frame.size.width) / 2;
                frame.size.width = 1;
            }

            self.touchSecondHighlightedView.frame = frame;
            self.touchSecondHighlightedView.hidden = NO;
        } else {
            self.touchSecondHighlightedView.hidden = YES;
        }
    }

}

#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    if (!self.selectable) {
        return;
    }

    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];

    if ((location.x < self.mainNegativeLimitX && self.mainNegativeLimitValue < 0) || (self.mainNegativeLimitValue == 0 && location.x < self.mainZeroX)) {
        __block NSInteger index = -1;
        [self.labels enumerateObjectsUsingBlock:^(DTChartLabel *label, NSUInteger idx, BOOL *stop) {
            if (CGRectGetMinX(label.frame) <= location.x && location.x <= CGRectGetMaxX(label.frame)) {
                index = idx;
                *stop = YES;
            }
        }];

        if (index >= 0) {
            id <DTDimensionBarChartCellDelegate> o = self.delegate;
            if ([o respondsToSelector:@selector(chartCellHintTouchBegin:labelIndex:touch:)]) {
                [o chartCellHintTouchBegin:self labelIndex:(NSUInteger) index touch:touch];
            }
        }
    } else {

        NSInteger inSection = 0;  ///< 1：主表区域     2：副表区域      0：没有区域
        if (location.x >= self.mainNegativeLimitX && location.x <= self.mainPositiveLimitX) {
            inSection = 1;
        } else if (location.x >= self.secondNegativeLimitX && location.x <= self.secondPositiveLimitX) {
            inSection = 2;
        }

        DTLog(@"inSection = %@", @(inSection));

        DTDimension2Item *item = nil;
        if (inSection == 1) {
            CGPoint touchPoint = [touch locationInView:self.mainBar];
            touchPoint = CGPointMake(touchPoint.x, CGRectGetMidY(self.mainBar.frame));
            DTDimension2Bar *subBar = [self.mainBar touchSubBar:touchPoint];
            item = subBar.data;

            CGRect frame = subBar.frame;
            frame.origin.x += CGRectGetMinX(self.mainBar.frame);
            if (frame.size.width < 1) {
                frame.origin.x -= (1 - frame.size.width) / 2;
                frame.size.width = 1;
            }
            self.touchMainHighlightedView.frame = frame;
            self.touchMainHighlightedView.hidden = NO;
            self.touchSecondHighlightedView.hidden = YES;

        } else if (inSection == 2) {
            CGPoint touchPoint = [touch locationInView:self.secondBar];
            touchPoint = CGPointMake(touchPoint.x, CGRectGetMidY(self.secondBar.frame));
            DTDimension2Bar *subBar = [self.secondBar touchSubBar:touchPoint];
            item = subBar.data;

            CGRect frame = subBar.frame;
            frame.origin.x += CGRectGetMinX(self.secondBar.frame);
            if (frame.size.width < 1) {
                frame.origin.x -= (1 - frame.size.width) / 2;
                frame.size.width = 1;
            }
            self.touchSecondHighlightedView.frame = frame;
            self.touchSecondHighlightedView.hidden = NO;
            self.touchMainHighlightedView.hidden = YES;
        } else {
            self.touchMainHighlightedView.hidden = YES;
            self.touchSecondHighlightedView.hidden = YES;
        }

        self.touchedItemData = item;

        id <DTDimensionBarChartCellDelegate> o = self.delegate;
        if (inSection > 0 && [o respondsToSelector:@selector(chartCellHintTouchBegin:isMainAxisBar:data:touch:)]) {
            [o chartCellHintTouchBegin:self isMainAxisBar:(inSection == 1) data:item touch:touch];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    if (!self.selectable) {
        return;
    }

    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];

    if ((location.x < self.mainNegativeLimitX && self.mainNegativeLimitValue < 0) || (self.mainNegativeLimitValue == 0 && location.x < self.mainZeroX)) {
        __block NSInteger index = -1;
        [self.labels enumerateObjectsUsingBlock:^(DTChartLabel *label, NSUInteger idx, BOOL *stop) {
            if (CGRectGetMinX(label.frame) <= location.x && location.x <= CGRectGetMaxX(label.frame)) {
                index = idx;
                *stop = YES;
            }
        }];

        if (index >= 0) {
            id <DTDimensionBarChartCellDelegate> o = self.delegate;
            if ([o respondsToSelector:@selector(chartCellHintTouchBegin:labelIndex:touch:)]) {
                [o chartCellHintTouchBegin:self labelIndex:(NSUInteger) index touch:touch];
            }
        }
    } else {

        NSInteger inSection = 0;  ///< 1：主表区域     2：副表区域      0：没有区域
        if (location.x >= self.mainNegativeLimitX && location.x <= self.mainPositiveLimitX) {
            inSection = 1;
        } else if (location.x >= self.secondNegativeLimitX && location.x <= self.secondPositiveLimitX) {
            inSection = 2;
        }

        DTDimension2Item *item = nil;
        if (inSection == 1) {
            CGPoint touchPoint = [touch locationInView:self.mainBar];
            touchPoint = CGPointMake(touchPoint.x, CGRectGetMidY(self.mainBar.frame));
            DTDimension2Bar *subBar = [self.mainBar touchSubBar:touchPoint];
            item = subBar.data;

            CGRect frame = subBar.frame;
            frame.origin.x += CGRectGetMinX(self.mainBar.frame);
            if (frame.size.width < 1) {
                frame.origin.x -= (1 - frame.size.width) / 2;
                frame.size.width = 1;
            }
            self.touchMainHighlightedView.frame = frame;
            self.touchMainHighlightedView.hidden = NO;
            self.touchSecondHighlightedView.hidden = YES;

        } else if (inSection == 2) {
            CGPoint touchPoint = [touch locationInView:self.secondBar];
            touchPoint = CGPointMake(touchPoint.x, CGRectGetMidY(self.secondBar.frame));
            DTDimension2Bar *subBar = [self.secondBar touchSubBar:touchPoint];
            item = subBar.data;

            CGRect frame = subBar.frame;
            frame.origin.x += CGRectGetMinX(self.secondBar.frame);
            if (frame.size.width < 1) {
                frame.origin.x -= (1 - frame.size.width) / 2;
                frame.size.width = 1;
            }
            self.touchSecondHighlightedView.frame = frame;
            self.touchSecondHighlightedView.hidden = NO;
            self.touchMainHighlightedView.hidden = YES;
        } else {
            self.touchMainHighlightedView.hidden = YES;
            self.touchSecondHighlightedView.hidden = YES;
        }

        self.touchedItemData = item;

        id <DTDimensionBarChartCellDelegate> o = self.delegate;
        if (inSection > 0 && [o respondsToSelector:@selector(chartCellHintTouchBegin:isMainAxisBar:data:touch:)]) {
            [o chartCellHintTouchBegin:self isMainAxisBar:(inSection == 1) data:item touch:touch];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    if (!self.selectable) {
        return;
    }

    self.touchedItemData = nil;
    self.touchMainHighlightedView.hidden = YES;
    self.touchSecondHighlightedView.hidden = YES;

    id <DTDimensionBarChartCellDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(chartCellHintTouchEnd)]) {
        [o chartCellHintTouchEnd];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    if (!self.selectable) {
        return;
    }

    self.touchedItemData = nil;
    self.touchMainHighlightedView.hidden = YES;
    self.touchSecondHighlightedView.hidden = YES;


    id <DTDimensionBarChartCellDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(chartCellHintTouchEnd)]) {
        [o chartCellHintTouchEnd];
    }
}

@end
