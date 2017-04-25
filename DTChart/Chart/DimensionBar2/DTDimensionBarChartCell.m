//
//  DTDimensionBarChartCell.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBarChartCell.h"
#import "DTDimension2Model.h"
#import "DTDimensionSectionLine.h"
#import "DTTableLabel.h"
#import "DTDimension2HeapBar.h"

@interface DTDimensionBarChartCell ()

@property(nonatomic) DTDimension2HeapBar *mainBar;
@property(nonatomic) DTDimension2HeapBar *secondBar;

@property(nonatomic) NSMutableArray<DTChartLabel *> *labels;

@property(nonatomic) DTDimension2Model *mainData;
@property(nonatomic) DTDimension2Model *secondData;

@property(nonatomic) DTDimensionSectionLine *sectionLine;

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
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor whiteColor];
    return label;
}


#pragma mark - public method

- (void)setCellData:(DTDimension2Model *)mainData second:(DTDimension2Model *)secondData prev:(DTDimension2Model *)prevData next:(DTDimension2Model *)nextData {
    _mainData = mainData;
    _secondData = secondData;


    if (self.labels.count != mainData.roots.count) {
        [self.labels enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        [self.labels removeAllObjects];

        for (NSUInteger i = 0; i < mainData.roots.count; ++i) {
            DTChartLabel *label = [self labelFactory];
            label.frame = CGRectMake(i * (self.titleWidth + self.titleGap), 0, self.titleWidth, 15);
            [self.labels addObject:label];
            [self.contentView addSubview:label];
        }
    }

    BOOL align = NO;
    for (NSUInteger i = 0; i < mainData.roots.count; ++i) {
        NSString *prevName = prevData.roots[i].name;
        NSString *name = mainData.roots[i].name;
        NSString *nextName = nextData.roots[i].name;
        if ([prevName isEqualToString:name]) {
            self.labels[i].text = nil;
        } else {
            self.labels[i].text = name;
        }

        self.sectionLine.hidden = nextName == nil;
        if (!align && ![name isEqualToString:nextName]) {
            align = YES;

            self.sectionLine.hidden = (i == mainData.roots.count - 1);

            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.sectionLine.frame = CGRectMake(CGRectGetMinX(self.labels[i].frame), 22, self.cellSize.width, 2);
            [CATransaction commit];
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
}

#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    if(!self.selectable){
        return;
    }

    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];

    if (location.x < self.mainNegativeLimitX) {
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

        BOOL isMain = YES;
        if(location.x >= self.mainNegativeLimitX && location.x <= self.mainPositiveLimitX){
            isMain = YES;
        } else if (location.x >= self.secondNegativeLimitX && location.x <= self.secondPositiveLimitX){
            isMain = NO;
        }
        id <DTDimensionBarChartCellDelegate> o = self.delegate;
        if ([o respondsToSelector:@selector(chartCellHintTouchBegin:isMainAxisBar:touch:)]) {
            [o chartCellHintTouchBegin:self isMainAxisBar:isMain touch:touch];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    if(!self.selectable){
        return;
    }

    id <DTDimensionBarChartCellDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(chartCellHintTouchEnd)]) {
        [o chartCellHintTouchEnd];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    if(!self.selectable){
        return;
    }

    id <DTDimensionBarChartCellDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(chartCellHintTouchEnd)]) {
        [o chartCellHintTouchEnd];
    }
}

@end
