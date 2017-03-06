//
//  DTTableLabel.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/6.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartLabel.h"

@class DTTableLabel;

@protocol DTTableLabelDelegate <NSObject>
@optional
- (void)tableLabelTouchBegin:(DTTableLabel *)label touch:(UITouch *)touch;

- (void)tableLabelTouchEnd;

@end

@interface DTTableLabel : DTChartLabel

@property(nonatomic, weak) id <DTTableLabelDelegate> delegate;

@property(nonatomic) BOOL selectable;

@end
