//
//  DTHeapBar.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/21.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTBar.h"

@interface DTHeapBar : DTBar

+ (instancetype)bar:(DTBarOrientation)orientation;

/**
 * 堆柱状体添加一个子块
 * @param data 子块数据
 * @param length 该数据在坐标轴里的所占长度(比如DTBarOrientationUp下就是高度)
 * @param color 该子块的颜色
 * @param need 是否需要刷新(在所有子块添加完，减少布局次数)
 */
- (void)appendData:(DTChartItemData *)data barLength:(CGFloat)length barColor:(UIColor *)color needLayout:(BOOL)need;

@end
