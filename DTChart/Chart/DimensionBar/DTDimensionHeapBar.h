//
//  DTDimensionHeapBar.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/7.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBar.h"

@interface DTDimensionHeapBar : DTDimensionBar

+ (instancetype)heapBar:(DTBarOrientation)orientation;

- (void)appendData:(DTDimensionModel *)data barLength:(CGFloat)length barColor:(UIColor *)color needLayout:(BOOL)need;
@end
