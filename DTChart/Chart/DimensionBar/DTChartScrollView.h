//
//  DTChartScrollView.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/6.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTChartScrollView : UIScrollView

@property(nonatomic, getter=isSelectable) BOOL selectable;

@property(nonatomic, copy) void (^scrollViewTouchBegin)(CGPoint touchPoint);
@property(nonatomic, copy) void (^scrollViewTouchEnd)();

@end
