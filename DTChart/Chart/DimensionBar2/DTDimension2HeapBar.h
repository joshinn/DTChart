//
//  DTDimension2HeapBar.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/21.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTBar.h"

@interface DTDimension2HeapBar : DTBar

- (void)resetBar;

- (void)appendData:(id)data barLength:(CGFloat)length barColor:(UIColor *)color needLayout:(BOOL)need;
@end
