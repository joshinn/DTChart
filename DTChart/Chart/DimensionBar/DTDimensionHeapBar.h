//
//  DTDimensionHeapBar.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/7.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBar.h"

CG_INLINE CGFloat CGPointGetDistance(CGPoint point1, CGPoint point2) {
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);
    return sqrtf((fx * fx + fy * fy));
}

@interface DTDimensionHeapBar : DTDimensionBar

@property(nonatomic) DTBarBorderStyle subBarBorderStyle;

@property(nonatomic) NSArray<UIColor *> *barAllColors;
@property(nonatomic, readonly) NSArray<DTDimensionModel *> *itemDatas;

+ (instancetype)heapBar:(DTBarOrientation)orientation;

- (void)appendData:(DTDimensionModel *)data barLength:(CGFloat)length barColor:(UIColor *)color needLayout:(BOOL)need;

- (void)appendData:(DTDimensionModel *)data barLength:(CGFloat)length barColor:(UIColor *)color barBorderColor:(UIColor *)borderColor needLayout:(BOOL)need;

- (DTDimensionBar *)touchSubBar:(CGPoint)point;

/**
 * 根据名称查找对应的子柱状体
 * @param title 名称
 * @return 子柱状体
 */
- (DTDimensionBar *)subBarFromTitle:(NSString *)title;

@end
