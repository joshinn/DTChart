//
//  DTChartBlockModel.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/17.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 坐标系颜色，type，id回调数据model
 *
 */
@interface DTChartBlockModel : NSObject

@property(nonatomic) NSString *seriesId;

@property(nonatomic) UIColor *color;
/**
 * 类型
 * @note DTLineChart type:0 圆形 1:方形 2:三角形
 */
@property(nonatomic) NSUInteger type;

@end
