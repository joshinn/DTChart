//
//  DTDimensionBarChartCell.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTColor.h"
#import "DTDimension2Model.h"

@class DTDimension2Model;
@class DTDimensionBarChartCell;
@class DTDimension2Item;

#define MainBarColor DTColorBlue
#define MainBarBorderColor DTColorBlueLight
#define SecondBarColor DTColorPink
#define SecondBarBorderColor DTColorPinkLight

static CGFloat const TitleLabelFontSize = 10;   ///< 标题label的的字体大小

@protocol DTDimensionBarChartCellDelegate <NSObject>

@optional
- (void)chartCellHintTouchBegin:(DTDimensionBarChartCell *)cell labelIndex:(NSUInteger)index touch:(UITouch *)touch;

- (void)chartCellHintTouchBegin:(DTDimensionBarChartCell *)cell isMainAxisBar:(BOOL)isMain data:(DTDimension2Item *)touchData touch:(UITouch *)touch;

- (void)chartCellHintTouchEnd;

- (BOOL)chartCellCanLeftSwipe:(DTDimensionBarChartCell *)cell;

- (BOOL)chartCellCanRightSwipe:(DTDimensionBarChartCell *)cell;

- (void)chartCellLeftSwipe:(DTDimensionBarChartCell *)cell data:(DTDimension2Model *)data;

- (void)chartCellRightSwipe:(DTDimensionBarChartCell *)cell data:(DTDimension2Model *)data;

@required
- (UIColor *)chartCellRequestItemColor:(id)data isMainAxis:(BOOL)isMain;

@end

@interface DTDimensionBarChartCell : UITableViewCell

@property(nonatomic, weak) id <DTDimensionBarChartCellDelegate> delegate;

@property(nonatomic, getter=isSelectable) BOOL selectable;

@property(nonatomic) CGSize cellSize;
@property(nonatomic) NSArray<NSNumber *> *titleWidths;
@property(nonatomic) CGFloat titleGap;

#pragma mark - ##############第一度量##############

@property(nonatomic) CGFloat mainZeroX; ///< 第一度量0的x值
@property(nonatomic) CGFloat mainPositiveLimitValue;    ///< 第一度量正值的最大值
@property(nonatomic) CGFloat mainPositiveLimitX;        ///< 第一度量正值的最大值的x
@property(nonatomic) CGFloat mainNegativeLimitValue;    ///< 第一度量负值的最小值
@property(nonatomic) CGFloat mainNegativeLimitX;        ///< 第一度量负值的最小值的x

#pragma mark - ##############第二度量##############

@property(nonatomic) CGFloat secondZeroX;
@property(nonatomic) CGFloat secondPositiveLimitValue;
@property(nonatomic) CGFloat secondPositiveLimitX;
@property(nonatomic) CGFloat secondNegativeLimitValue;
@property(nonatomic) CGFloat secondNegativeLimitX;


#pragma mark - common

@property(nonatomic) DTDimensionBarStyle chartStyle;

/**
 * 高亮的sub bar标题
 */
@property(nonatomic) NSString *highlightTitle;

- (void)setCellData:(DTDimension2Model *)data second:(DTDimension2Model *)secondData prev:(DTDimension2Model *)prevData next:(DTDimension2Model *)nextData;
@end
