//
//  DTTableAxisLabelData.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/6.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartData.h"

@interface DTTableAxisLabelData : DTAxisLabelData
/**
 * 是否显示升降序按钮，默认NO
 */
@property(nonatomic, getter=isShowOrder) BOOL showOrder;
/**
 * 是否是升序，默认YES
 */
@property(nonatomic, getter=isAscending) BOOL ascending;

@end
