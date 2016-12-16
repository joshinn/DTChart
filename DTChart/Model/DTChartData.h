//
//  DTChartData.h
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

struct ChartItemValue {
    CGFloat x;
    CGFloat y;
};
typedef struct ChartItemValue ChartItemValue;

CG_INLINE ChartItemValue ChartItemValueMake(CGFloat x, CGFloat y) {
    ChartItemValue value;
    value.x = x;
    value.y = y;
    return value;
}

CG_INLINE NSString *NSStringFromChartItemValue(ChartItemValue value) {
    return [NSString stringWithFormat:@"{ x = %@, y = %@ }", @(value.x), @(value.y)];
}

#pragma mark - DTChartData 坐标系数据

@interface DTChartItemData : NSObject
/**
 * 坐标系里具体的值
 */
@property(nonatomic) ChartItemValue itemValue;
/**
 * 在坐标系里的位置
 */
@property (nonatomic) CGPoint position;

+ (instancetype)chartData;

@end


#pragma mark - DTAxisLabelData 坐标轴标签数据

@interface DTAxisLabelData : NSObject
/**
 * 文字标签
 */
@property(nonatomic) NSString *title;
/**
 * 标签值
 */
@property(nonatomic) CGFloat value;
/**
 * 坐标轴上的点的位置
 */
@property(nonatomic) CGFloat axisPosition;

- (instancetype)initWithTitle:(NSString *)title value:(CGFloat)value;

+ (instancetype)axisLabelData;

@end