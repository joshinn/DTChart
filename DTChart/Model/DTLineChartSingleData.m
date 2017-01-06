//
//  DTLineChartSingleData.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/6.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTLineChartSingleData.h"

@implementation DTLineChartSingleData

+ (instancetype)singleData {
    DTLineChartSingleData *data = [DTLineChartSingleData singleData:nil];
    return data;
}

+ (instancetype)singleData:(NSArray<DTChartItemData *> *)values {
    DTLineChartSingleData *data = [[DTLineChartSingleData alloc] init];
    data.itemValues = values;
    data.lineWidth = 5;
    data.pointType = DTLinePointTypeCircle;
    return data;
}

@end
