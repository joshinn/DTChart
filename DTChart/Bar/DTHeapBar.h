//
//  DTHeapBar.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/21.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTBar.h"

@interface DTHeapBar : DTBar

@property (nonatomic) CGFloat barTag;

+ (instancetype)bar:(DTBarOrientation)orientation;

- (void)appendData:(DTChartItemData *)data barLength:(CGFloat)length barColor:(UIColor *)color;

@end
