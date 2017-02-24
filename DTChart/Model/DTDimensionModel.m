//
//  DTDimensionModel.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/24.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionModel.h"

@implementation DTDimensionModel

+ (instancetype)initWith:(NSString *)name list:(NSArray<DTDimensionModel *> *)list value:(CGFloat)value {
    DTDimensionModel *model = [[DTDimensionModel alloc] init];
    model.ptName = name;
    model.ptListValue = list;
    model.ptValue = value;
    return model;
}

@end

