//
//  DTChartToastView.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/2.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTChartToastView : UIVisualEffectView

- (void)show:(NSString *)message location:(CGPoint)point;

- (void)hide;

@end
