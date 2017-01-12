//
//  DTCommonData.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTCommonData.h"

@implementation DTCommonData

+ (instancetype)commonData:(NSString *)name value:(CGFloat)value {
    DTCommonData *data = [[DTCommonData alloc] initWithName:name value:value];
    return data;
}

- (instancetype)initWithName:(NSString *)name value:(CGFloat)value {
    if (self = [super init]) {
        _ptName = name;
        _ptValue = value;
    }
    return self;
}

@end


@implementation DTListCommonData

+ (instancetype)listCommonData:(NSString *)seriesId seriesName:(NSString *)seriesName arrayData:(NSArray<DTCommonData *> *)array mainAxis:(BOOL)isMainAxis {
    DTListCommonData *listCommonData = [[DTListCommonData alloc] init];
    listCommonData.seriesId = seriesId;
    listCommonData.seriesName = seriesName;
    listCommonData.commonDatas = array;
    listCommonData.mainAxis = isMainAxis;
    return listCommonData;
}

@end