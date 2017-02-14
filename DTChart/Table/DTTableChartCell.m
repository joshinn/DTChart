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
#import "DTTableChartSingleData.h"


CGFloat const DTTableChartCellHeight = 35;

@interface DTTableChartCell ()

@property(nonatomic) NSArray<UIView *> *containerViews;
@property(nonatomic) DTTableChartStyle style;
@property(nonatomic) UIImage *ascendImg;
@property(nonatomic) UIImage *descendImg;

@property(nonatomic) NSIndexPath *indexPath;

@property(nonatomic) DTTableChartSingleData *cellData;

@end

@implementation DTTableChartCell

static NSInteger const LabelViewTag = 10100;
static NSInteger const IconViewTag = 10101;

static NSInteger const MainAxisOrderButtonTagPrefix = 1000;
static NSInteger const SecondAxisOrderButtonTagPrefix = 2000;


#define EvenRowBackgroundColor DTRGBColor(0x3b3b3b, 1)
#define OddRowBackgroundColor [UIColor clearColor]

#define NormalLabelTextColor DTRGBColor(0xc0c0c0, 1)
#define ExpandLabelTextColor DTRGBColor(0xe861a4, 1)

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
        _ascendImg = [UIImage imageWithCGImage:_ascendImg.CGImage scale:2 orientation:_ascendImg.imageOrientation];
    }
    return _ascendImg;
}

- (UIImage *)descendImg {
    if (!_descendImg) {
        NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
        _descendImg = [UIImage imageWithContentsOfFile:[bundle.resourcePath stringByAppendingPathComponent:@"descend.png"]];
        _descendImg = [UIImage imageWithCGImage:_descendImg.CGImage scale:2 orientation:_descendImg.imageOrientation];
    }
    return _descendImg;
}


#pragma mark - private method

- (void)orderButton:(UIButton *)sender {
    NSUInteger tag = (NSUInteger) sender.superview.tag;
    BOOL isMainAxis;
    if (tag >= SecondAxisOrderButtonTagPrefix) {
        tag -= SecondAxisOrderButtonTagPrefix;
        isMainAxis = NO;
    } else {
        tag -= MainAxisOrderButtonTagPrefix;
        isMainAxis = YES;
    }
    [self.delegate chartCellOrderTouched:isMainAxis column:tag];
}

- (void)touchEvent:(DTChartLabel *)sender {
    if (self.cellData.expandType == DTTableChartCellWillExpand) {
        [self.delegate chartCellToExpandTouched:self.cellData.singleId];
    } else if (self.cellData.expandType == DTTableChartCellDidExpand) {
        [self.delegate chartCellToCollapseTouched:self.cellData.singleId];
    }
}

/**
 * 布局子view
 * @param widths 宽度集合
 * @return 子view数组
 */
- (NSMutableArray<UIView *> *)layoutSubviewsWithWidths:(NSArray *)widths {


    CGFloat x = self.labelLeftOffset;
    NSMutableArray<UIView *> *list = [NSMutableArray array];
    for (NSDictionary *dictionary in widths) {
        if (dictionary[@"label"]) {
            NSNumber *number = dictionary[@"label"];
            CGFloat width = number.floatValue / 2;

            UIView *container = [UIView new];
            container.frame = CGRectMake(x, 0, width, DTTableChartCellHeight);

            DTChartLabel *label = [DTChartLabel chartLabel];
            label.textColor = NormalLabelTextColor;
            label.tag = LabelViewTag;
            label.font = [UIFont systemFontOfSize:15];
            label.frame = container.bounds;
            label.textAlignment = NSTextAlignmentCenter;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchEvent:)];
            [label addGestureRecognizer:tap];

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

        DTChartLabel *label = [container viewWithTag:LabelViewTag];
        label.userInteractionEnabled = NO;
        label.textColor = NormalLabelTextColor;
        label.lineBreakMode = NSLineBreakByTruncatingTail;

        UIButton *icon = [container viewWithTag:IconViewTag];

        DTTableAxisLabelData *axisLabelData = nil;
        NSInteger halfViewsCount = i - self.containerViews.count / 2;
        if ((halfViewsCount >= 0) && hasSecondAxis && halfViewsCount < secondTitleDatas.count) {

            axisLabelData = secondTitleDatas[(NSUInteger) halfViewsCount];
            container.tag = SecondAxisOrderButtonTagPrefix + halfViewsCount;

        } else if (i < titleDatas.count) {

            axisLabelData = titleDatas[i];
            container.tag = MainAxisOrderButtonTagPrefix + i;
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

- (void)setCellData:(DTTableChartSingleData *)singleData second:(DTTableChartSingleData *)secondSingleData indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    self.cellData = singleData;

    BOOL isOddRow = indexPath.row % 2 == 0;
    BOOL hasSecondAxis = secondSingleData != nil;

    for (NSUInteger i = 0; i < self.containerViews.count; ++i) {

        UIView *container = self.containerViews[i];

        UIButton *icon = [container viewWithTag:IconViewTag];
        icon.hidden = YES;

        DTChartLabel *label = [container viewWithTag:LabelViewTag];
        label.textColor = NormalLabelTextColor;
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

        // 展开/收起处理
        if (self.collapseColumn == i) {
            if ((halfViewsCount >= 0) && hasSecondAxis && !secondSingleData.isHeaderRow) {
                label.text = @"";
            } else if (!singleData.isHeaderRow) {
                label.text = @"";
            }
        }

        if (self.collapseColumn >= 0 && self.collapseColumn == i - 1) {
            if ((halfViewsCount >= 0) && hasSecondAxis && secondSingleData.isHeaderRow) {
                if (secondSingleData.expandType == DTTableChartCellDidExpand) {
                    label.text = @"收起…";
                } else {
                    label.text = @"展开…";
                }
                label.userInteractionEnabled = YES;
                label.textColor = ExpandLabelTextColor;
            } else if (singleData.isHeaderRow) {
                if (singleData.expandType == DTTableChartCellDidExpand) {
                    label.text = @"收起…";
                } else {
                    label.text = @"展开…";
                }
                label.userInteractionEnabled = YES;
                label.textColor = ExpandLabelTextColor;
            }
        }

        if (isOddRow) {
            label.backgroundColor = OddRowBackgroundColor;
        } else {
            label.backgroundColor = EvenRowBackgroundColor;
        }

    }
}

@end
