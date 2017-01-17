//
//  DTLineChartSingleData.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/6.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartData.h"

typedef NS_ENUM(NSInteger, DTLinePointType) {
    DTLinePointTypeCircle = 0,      // 圆圈
    DTLinePointTypeSquare = 1,      // 正方形
    DTLinePointTypeTriangle = 2,    // 三角形
};


@interface DTLineChartSingleData : DTChartSingleData

/**
 * 顶点类型
 * @attention singleName相同，pointType不一致
 */
@property(nonatomic) DTLinePointType pointType;

@end
