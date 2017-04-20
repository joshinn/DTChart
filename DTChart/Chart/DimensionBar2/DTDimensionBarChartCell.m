//
//  DTDimensionBarChartCell.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBarChartCell.h"
#import "DTBar.h"
#import "DTDimension2Model.h"
#import "DTDimensionSectionLine.h"
#import "DTTableLabel.h"

@interface DTDimensionBarChartCell ()

@property(nonatomic) DTBar *mainBar;
@property(nonatomic) DTBar *secondBar;

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

        _mainBar = [DTBar bar:DTBarOrientationRight style:DTBarBorderStyleNone];
        _mainBar.barColor = MainBarColor;
        _mainBar.barBorderColor = MainBarBorderColor;
        [self.contentView addSubview:_mainBar];

        _secondBar = [DTBar bar:DTBarOrientationRight style:DTBarBorderStyleNone];
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

    if (self.labels.count != mainData.ptNames.count) {
        [self.labels enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        [self.labels removeAllObjects];

        for (NSUInteger i = 0; i < mainData.ptNames.count; ++i) {
            DTChartLabel *label = [self labelFactory];
            label.frame = CGRectMake(i * (self.titleWidth + self.titleGap), 0, self.titleWidth, 15);
            [self.labels addObject:label];
            [self.contentView addSubview:label];
        }
    }

    BOOL align = NO;
    for (NSUInteger i = 0; i < mainData.ptNames.count; ++i) {
        NSString *prevName = prevData.ptNames[i];
        NSString *name = mainData.ptNames[i];
        NSString *nextName = nextData.ptNames[i];
        if ([prevName isEqualToString:name]) {
            self.labels[i].text = nil;
        } else {
            self.labels[i].text = name;
        }

        if (!align && ![name isEqualToString:nextName]) {
            align = YES;
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.sectionLine.frame = CGRectMake(CGRectGetMinX(self.labels[i].frame), 22, self.cellSize.width, 2);
            [CATransaction commit];
        }
        self.sectionLine.hidden = nextName == nil;
    }

    CGFloat barWidth = 0;
    if (mainData.ptValue >= 0) {
        barWidth = mainData.ptValue / self.mainPositiveLimitValue * (self.mainPositiveLimitX - self.mainZeroX);
        self.mainBar.frame = CGRectMake(self.mainZeroX, 0, barWidth, 15);
    } else {
        barWidth = mainData.ptValue / self.mainNegativeLimitValue * (self.mainZeroX - self.mainNegativeLimitX);
        self.mainBar.frame = CGRectMake(self.mainZeroX - barWidth, 0, barWidth, 15);
    }


    if (secondData) {
        self.secondBar.hidden = NO;
        if (secondData.ptValue >= 0) {
            barWidth = secondData.ptValue / self.secondPositiveLimitValue * (self.secondPositiveLimitX - self.secondZeroX);
            self.secondBar.frame = CGRectMake(self.secondZeroX, 0, barWidth, 15);
        } else {
            barWidth = secondData.ptValue / self.secondNegativeLimitValue * (self.secondZeroX - self.secondNegativeLimitX);
            self.secondBar.frame = CGRectMake(self.secondZeroX - barWidth, 0, barWidth, 15);
        }
    } else {
        self.secondBar.hidden = YES;
    }
}

#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

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

        BOOL isMain = location.x < self.secondNegativeLimitX;
        id <DTDimensionBarChartCellDelegate> o = self.delegate;
        if ([o respondsToSelector:@selector(chartCellHintTouchBegin:isMainAxisBar:touch:)]) {
            [o chartCellHintTouchBegin:self isMainAxisBar:isMain touch:touch];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    id <DTDimensionBarChartCellDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(chartCellHintTouchEnd)]) {
        [o chartCellHintTouchEnd];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    id <DTDimensionBarChartCellDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(chartCellHintTouchEnd)]) {
        [o chartCellHintTouchEnd];
    }
}

@end
