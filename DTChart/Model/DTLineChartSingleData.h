//
//  DTLineChartSingleData.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/6.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartData.h"

typedef NS_ENUM(NSInteger, DTLinePointType) {
    DTLinePointTypeCircle,      // 圆圈
    DTLinePointTypeTriangle,   // 三角形
    DTLinePointTypeSquare      // 正方形
};


@interface DTLineChartSingleData : DTChartSingleData

@property(nonatomic) DTLinePointType pointType;

@end
