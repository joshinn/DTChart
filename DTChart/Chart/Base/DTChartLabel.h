//
//  DTChartLabel.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTChartLabel : UILabel
/**
 * 是否是副轴标签
 * @note 暂时只有DTLineChart使用到
 */
@property(nonatomic, getter=isSecondAxis) BOOL secondAxis;

+ (instancetype)chartLabel;

@end
