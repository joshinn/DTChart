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
    DTCommonData *data = [[DTCommonData alloc] init];
    data.ptName = name;
    data.ptValue = value;
    return data;
}

+ (instancetype)commonData:(NSString *)name stringValue:(NSString *)value {
    DTCommonData *data = [[DTCommonData alloc] init];
    data.ptName = name;
    data.ptStringValue = value;
    return data;
}


- (id)copyWithZone:(nullable NSZone *)zone {
    DTCommonData *commonData = [[[self class] allocWithZone:zone] init];
    [self processCopy:commonData];
    return commonData;
}

- (void)processCopy:(DTCommonData *)copiedModel {
    copiedModel.ptName = self.ptName.copy;
    copiedModel.ptStringValue = self.ptStringValue.copy;
    copiedModel.ptValue = self.ptValue;
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

- (instancetype)init {
    if (self = [super init]) {
        _mainAxis = YES;
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    DTListCommonData *listCommonData = [[[self class] allocWithZone:zone] init];
    [self processCopy:listCommonData];
    return listCommonData;
}

- (void)processCopy:(DTListCommonData *)copiedModel {
    copiedModel.seriesId = self.seriesId;
    copiedModel.seriesName = self.seriesName.copy;
    copiedModel.mainAxis = self.isMainAxis;

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.commonDatas.count];
    for (DTCommonData *commonData in self.commonDatas) {
        [array addObject:commonData.copy];
    }
    copiedModel.commonDatas = array.count > 0 ? array.copy : nil;
}
@end
