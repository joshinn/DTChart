//
//  DTDimension2HeapBar.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/21.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTBar.h"

@class DTDimension2Bar;

@interface DTDimension2HeapBar : DTBar

- (void)resetBar;

- (void)appendData:(id)data barLength:(CGFloat)length barColor:(UIColor *)color needLayout:(BOOL)need;

- (DTDimension2Bar *)touchSubBar:(CGPoint)point;

/**
 * 根据名称查找对应的子柱状体
 * @param title 名称
 * @return 子柱状体
 */
- (DTDimension2Bar *)subBarFromTitle:(NSString *)title;
@end
