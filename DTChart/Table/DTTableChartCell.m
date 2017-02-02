//
//  DTTableChartCell.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/5.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTTableChartCell.h"
#import "DTChartLabel.h"
#import "DTTableAxisLabelData.h"


CGFloat const DTTableChartCellHeight = 35;

@interface DTTableChartCell ()

@property(nonatomic) NSArray<UIView *> *containerViews;
@property(nonatomic) DTTableChartStyle style;
@property(nonatomic) UIImage *ascendImg;
@property(nonatomic) UIImage *descendImg;
@end

@implementation DTTableChartCell

static NSInteger const LabelViewTag = 10100;
static NSInteger const IconViewTag = 10101;

#define EvenRowBackgroundColor DTRGBColor(0x3b3b3b, 1)
#define OddRowBackgroundColor [UIColor clearColor]

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        _style = DTTableChartStyleCustom;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (UIImage *)ascendImg {
    if (!_ascendImg) {
        NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
        _ascendImg = [UIImage imageWithContentsOfFile:[bundle.resourcePath stringByAppendingPathComponent:@"ascend.png"]];
    }
    return _ascendImg;
}

- (UIImage *)descendImg {
    if (!_descendImg) {
        NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
        _descendImg = [UIImage imageWithContentsOfFile:[bundle.resourcePath stringByAppendingPathComponent:@"descend.png"]];
    }
    return _descendImg;
}


#pragma mark - private method

- (void)orderButton:(UIButton *)sender {

    if (self.orderClickBlock) {
        DTLog(@"click label tag = %@", @(sender.superview.tag));
        self.orderClickBlock(sender.superview.tag);
    }
}

/**
 * 布局子view
 * @param widths 宽度集合
 * @return 子view数组
 */
- (NSMutableArray<UIView *> *)layoutSubviewsWithWidths:(NSArray *)widths {
    CGFloat x = 0;
    NSMutableArray<UIView *> *list = [NSMutableArray array];
    for (NSDictionary *dictionary in widths) {
        if (dictionary[@"label"]) {
            NSNumber *number = dictionary[@"label"];
            CGFloat width = number.floatValue / 2;

            UIView *container = [UIView new];
            container.frame = CGRectMake(x, 0, width, DTTableChartCellHeight);

            DTChartLabel *label = [DTChartLabel chartLabel];
            label.tag = LabelViewTag;
            label.font = [UIFont systemFontOfSize:15];
            label.frame = container.bounds;
            label.textAlignment = NSTextAlignmentCenter;
            [container addSubview:label];

            UIButton *iconView = [[UIButton alloc] init];
            [iconView addTarget:self action:@selector(orderButton:) forControlEvents:UIControlEventTouchUpInside];
            iconView.frame = CGRectMake(width - DTTableChartCellHeight, 0, DTTableChartCellHeight, DTTableChartCellHeight);
            iconView.tag = IconViewTag;

            [container addSubview:iconView];

            [self.contentView addSubview:container];

            [list addObject:container];
            x += width;

        } else if (dictionary[@"gap"]) {
            NSNumber *number = dictionary[@"gap"];
            x += number.floatValue / 2;
        }
    }
    return list;
}

#pragma mark - public method

- (void)setStyle:(DTTableChartStyle)style widths:(NSArray *)widths {

    if (_style != style) {

        [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];

        _containerViews = [self layoutSubviewsWithWidths:widths];
        _style = style;

    } else if (style == DTTableChartStyleNone) {
        [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        _style = style;

    }

}

- (void)setCellTitle:(NSArray<DTTableAxisLabelData *> *)titleDatas secondTitles:(NSArray<DTTableAxisLabelData *> *)secondTitleDatas {

    BOOL hasSecondAxis = secondTitleDatas.count > 0;


    for (NSUInteger i = 0; i < self.containerViews.count; ++i) {

        UIView *container = self.containerViews[i];
        container.tag = i;

        DTChartLabel *label = [container viewWithTag:LabelViewTag];
        UIButton *icon = [container viewWithTag:IconViewTag];

        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.userInteractionEnabled = YES;

        DTTableAxisLabelData *axisLabelData = nil;
        NSInteger halfViewsCount = i - self.containerViews.count / 2;
        if ((halfViewsCount >= 0) && hasSecondAxis && halfViewsCount < secondTitleDatas.count) {
            axisLabelData = secondTitleDatas[(NSUInteger) halfViewsCount];
        } else if (i < titleDatas.count) {
            axisLabelData = titleDatas[i];
        }

        if (axisLabelData) {
            label.text = axisLabelData.title;
            icon.hidden = !axisLabelData.isShowOrder;
            if (axisLabelData.ascending) {
                [icon setImage:self.ascendImg forState:UIControlStateNormal];
            } else {
                [icon setImage:self.descendImg forState:UIControlStateNormal];
            }

        } else {
            label.text = @"";
            icon.hidden = YES;
        }

        label.backgroundColor = EvenRowBackgroundColor;
    }
}

- (void)setCellData:(DTChartSingleData *)singleData second:(DTChartSingleData *)secondSingleData indexPath:(NSIndexPath *)indexPath {
    BOOL isOddRow = indexPath.row % 2 == 0;
    BOOL hasSecondAxis = secondSingleData != nil;

    for (NSUInteger i = 0; i < self.containerViews.count; ++i) {

        UIView *container = self.containerViews[i];

        UIButton *icon = [container viewWithTag:IconViewTag];
        icon.hidden = YES;

        DTChartLabel *label = [container viewWithTag:LabelViewTag];
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.userInteractionEnabled = NO;


        DTChartItemData *itemData = nil;
        NSInteger halfViewsCount = i - self.containerViews.count / 2;
        if ((halfViewsCount >= 0) && hasSecondAxis && halfViewsCount < secondSingleData.itemValues.count) {
            itemData = secondSingleData.itemValues[(NSUInteger) halfViewsCount];
        } else if (i < singleData.itemValues.count) {
            itemData = singleData.itemValues[i];
        }


        if (itemData) {
            label.text = itemData.title;
        } else {
            label.text = @"";
        }

        if (isOddRow) {
            label.backgroundColor = OddRowBackgroundColor;
        } else {
            label.backgroundColor = EvenRowBackgroundColor;
        }

    }
}

@end
