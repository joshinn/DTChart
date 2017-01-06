 //
//  DTTableChartCell.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/5.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTTableChartCell.h"
#import "DTChartLabel.h"
#import "DTChartData.h"
#import "DTTableAxisLabelData.h"


 CGFloat const DTTableChartCellHeight = 35;

@interface DTTableChartCell ()

@property(nonatomic) NSArray<UIView *> *containerViews;

@property (nonatomic) UIImage *ascendImg;
@property (nonatomic) UIImage *descendImg;
@end

@implementation DTTableChartCell

static NSInteger const LabelViewTag = 10100;
static NSInteger const IconViewTag = 10101;

#define EvenRowBackgroundColor DTRGBColor(0x3b3b3b, 1)
#define OddRowBackgroundColor [UIColor clearColor]

- (instancetype)initWithWidths:(NSArray *)widths reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {

        DTLog(@"DTTableChartCell init");

        CGFloat x = 0;
        _containerViews = [NSArray array];
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

        _containerViews = list;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImage *)ascendImg {
    if(!_ascendImg){
        NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
        _ascendImg = [UIImage imageWithContentsOfFile:[bundle.resourcePath stringByAppendingPathComponent:@"ascend.png"]];
    }
    return _ascendImg;
}

- (UIImage *)descendImg {
    if(!_descendImg){
        NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
        _descendImg = [UIImage imageWithContentsOfFile:[bundle.resourcePath stringByAppendingPathComponent:@"descend.png"]];
    }
    return _descendImg;
}


#pragma mark - private method

- (void)orderButton:(UIButton *)sender {

    if(self.orderClickBlock){
        DTLog(@"click label tag = %@", @(sender.superview.tag));
        self.orderClickBlock(sender.superview.tag);
    }
}

#pragma mark - public method

- (void)setCellTitle:(NSArray<DTTableAxisLabelData *> *)titleDatas {
    for (NSUInteger i = 0; i < self.containerViews.count; ++i) {

        UIView *container = self.containerViews[i];
        container.tag = i;

        DTChartLabel *label = [container viewWithTag:LabelViewTag];
        UIButton *icon = [container viewWithTag:IconViewTag];

        label.userInteractionEnabled = YES;

        if (i < titleDatas.count) {
            DTTableAxisLabelData *axisLabelData = titleDatas[i];
            label.text = axisLabelData.title;
            icon.hidden = !axisLabelData.isShowOrder;
            if(axisLabelData.ascending){
                [icon setImage:self.ascendImg forState:UIControlStateNormal];
            } else{
                [icon setImage:self.descendImg forState:UIControlStateNormal];
            }

        } else {
            label.text = @"";
            icon.hidden = YES;
        }

        label.backgroundColor = EvenRowBackgroundColor;
    }
}

- (void)setCellData:(NSArray<DTChartItemData *> *)items indexPath:(NSIndexPath *)indexPath {
    BOOL isOddRow = indexPath.row % 2 == 0;

    for (NSUInteger i = 0; i < self.containerViews.count && items.count; ++i) {

        UIView *container = self.containerViews[i];

        UIButton *icon = [container viewWithTag:IconViewTag];
        icon.hidden = YES;

        DTChartLabel *label = [container viewWithTag:LabelViewTag];
        label.userInteractionEnabled = NO;

        if (i < items.count) {
            label.text = items[i].title;
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
