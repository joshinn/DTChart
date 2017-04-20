//
//  DTDimension2Model.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimension2Model.h"

@implementation DTDimension2Model

- (instancetype)initWithDictionary:(NSDictionary *)dictionary measureIndex:(NSInteger)index {
    return [self initFromJson:dictionary valueName:[NSString stringWithFormat:@"value%@", @(index)]];
}

- (instancetype)initFromJson:(NSDictionary *)json valueName:(NSString *)valueName {
    if (self = [super init]) {
        _ptNames = json[@"names"];
        _ptValue = [json[valueName] doubleValue];
    }
    return self;
}

@end


@implementation DTDimension2ListModel

@end