//
//  DTTableChartSingleData.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/2.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTTableChartSingleData.h"

@implementation DTTableChartSingleData

+ (instancetype)singleData:(NSArray<DTChartItemData *> *)values {
    DTTableChartSingleData *data = [[DTTableChartSingleData alloc] init];
    data.itemValues = values;
    data.lineWidth = 5;
    return data;
}


- (instancetype)init {
    if(self = [super init]){
        _headerRow = YES;
        _expandType = DTTableChartCellWillExpand;
    }
    return self;
}

@end
