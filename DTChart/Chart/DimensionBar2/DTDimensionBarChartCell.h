//
//  DTDimensionBarChartCell.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTColor.h"

@class DTDimension2Model;
@class DTDimensionBarChartCell;

#define MainBarColor DTColorBlue;
#define MainBarBorderColor DTColorBlueLight;
#define SecondBarColor DTColorPink;
#define SecondBarBorderColor DTColorPinkLight;


@protocol DTDimensionBarChartCellDelegate <NSObject>

@optional
- (void)chartCellHintTouchBegin:(DTDimensionBarChartCell *)cell labelIndex:(NSUInteger)index touch:(UITouch *)touch;

- (void)chartCellHintTouchBegin:(DTDimensionBarChartCell *)cell isMainAxisBar:(BOOL)isMain touch:(UITouch *)touch;

- (void)chartCellHintTouchEnd;


@end

@interface DTDimensionBarChartCell : UITableViewCell

@property(nonatomic, weak) id <DTDimensionBarChartCellDelegate> delegate;

@property(nonatomic, getter=isSelectable) BOOL selectable;

@property(nonatomic) CGSize cellSize;
@property(nonatomic) CGFloat titleWidth;
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


- (void)setCellData:(DTDimension2Model *)data second:(DTDimension2Model *)secondData prev:(DTDimension2Model *)prevData next:(DTDimension2Model *)nextData;
@end
