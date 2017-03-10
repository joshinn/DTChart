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

- (instancetype)init {
    if (self = [super init]) {
        _childrenSumValue = -1;
        _objectId = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)));
    }
    return self;
}

- (void)setPtValue:(CGFloat)ptValue {
    _ptValue = ptValue;

    _childrenSumValue = -1;
}

- (void)setPtListValue:(NSArray<DTDimensionModel *> *)ptListValue {
    _ptListValue = ptListValue;

    _childrenSumValue = -1;
}

- (CGFloat)childrenSumValue {
    if (_childrenSumValue == -1) {
        _childrenSumValue = [self childrenSum:self];
    }
    return _childrenSumValue;
}

- (CGFloat)childrenSum:(DTDimensionModel *)model {
    CGFloat sum = 0;
    if (model.ptListValue.count > 0) {
        for (DTDimensionModel *item in model.ptListValue) {
            sum += [self childrenSum:item];
        }
    } else {
        sum += model.ptValue;
    }

    return sum;
}

@end

