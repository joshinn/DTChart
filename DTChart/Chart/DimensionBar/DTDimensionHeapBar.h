//
//  DTDimensionHeapBar.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/7.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBar.h"

@interface DTDimensionHeapBar : DTDimensionBar

@property(nonatomic) DTBarBorderStyle subBarBorderStyle;

@property (nonatomic, readonly) NSArray<DTDimensionModel *> *itemDatas;

+ (instancetype)heapBar:(DTBarOrientation)orientation;

- (void)appendData:(DTDimensionModel *)data barLength:(CGFloat)length barColor:(UIColor *)color needLayout:(BOOL)need;

- (void)appendData:(DTDimensionModel *)data barLength:(CGFloat)length barColor:(UIColor *)color barBorderColor:(UIColor *)borderColor needLayout:(BOOL)need;

- (DTDimensionBar *)touchSubBar:(CGPoint)point;
@end
