//
//  DTDimensionModel.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/24.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionModel.h"

@implementation DTDimensionModel

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary measureIndex:(NSInteger)index {
    return [self dataFromJson:dictionary valueName:[NSString stringWithFormat:@"value%@", @(index)]];
}

+ (DTDimensionModel *)dataFromJson:(NSDictionary *)json valueName:(NSString *)valueName {
    DTDimensionModel *model = [[DTDimensionModel alloc] init];

    if (json[@"name"]) {
        model.ptName = json[@"name"];
    }

    if (json[@"data"]) {
        id data = json[@"data"];
        if ([data isKindOfClass:[NSArray class]]) {

            NSArray *array = data;
            NSMutableArray<DTDimensionModel *> *list = [NSMutableArray arrayWithCapacity:array.count];
            for (NSDictionary *dictionary in array) {
                DTDimensionModel *model2 = [self dataFromJson:dictionary valueName:valueName];
                [list addObject:model2];
            }

            model.ptListValue = list;
        }
    }
    if (json[valueName]) {
        model.ptValue = [json[valueName] doubleValue];
    }

    return model;
}

+ (instancetype)initWith:(NSString *)name list:(NSArray<DTDimensionModel *> *)list value:(CGFloat)value {
    DTDimensionModel *model = [[DTDimensionModel alloc] init];
    model.ptName = name;
    model.ptListValue = list;
    model.ptValue = value;
    return model;
}

- (instancetype)init {
    if (self = [super init]) {
        _childrenSumValue = NAN;
        _objectId = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)));
    }
    return self;
}

- (void)setPtValue:(CGFloat)ptValue {
    _ptValue = ptValue;

    _childrenSumValue = NAN;
}

- (void)setPtListValue:(NSArray<DTDimensionModel *> *)ptListValue {
    _ptListValue = ptListValue;

    _childrenSumValue = NAN;
}

- (CGFloat)childrenSumValue {
    if (isnan(_childrenSumValue)) {
        BOOL childSumIsNull = YES;
        _childrenSumValue = [self childrenSum:self isNull:&childSumIsNull];
        _ptValueIsNull = childSumIsNull;
    }
    return _childrenSumValue;
}

- (CGFloat)childrenSum:(DTDimensionModel *)model isNull:(BOOL *)isNull {
    CGFloat sum = 0;
    if (model.ptListValue.count > 0) {
        BOOL childSumIsNull = YES;
        for (DTDimensionModel *item in model.ptListValue) {
            BOOL itemChildSumIsNull = YES;
            CGFloat childSum = [self childrenSum:item isNull:&itemChildSumIsNull];
            if (!itemChildSumIsNull) {
                childSumIsNull = NO;
                sum += childSum;
            }
        }

        *isNull = childSumIsNull;

        model.childrenSumValue = sum;
        model.ptValueIsNull = childSumIsNull;

    } else {

        *isNull = model.ptValueIsNull;

        sum += model.ptValue;
    }

    return sum;
}

@end

