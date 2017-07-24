//
//  DTDimension2Model.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimension2Model.h"

@implementation DTDimension2Item

+ (instancetype)initWithName:(NSString *)name value:(CGFloat)value {
    DTDimension2Item *item = [[self alloc] init];
    item.name = name;
    item.value = value;
    return item;
}

@end

@implementation DTDimension2Model


- (instancetype)initStartLineWithDictionary:(NSDictionary *)dictionary measureIndex:(NSInteger)index {
    return [self initFromJson:dictionary valueName:[NSString stringWithFormat:@"value%@", @(index)] style:DTDimensionBarStyleStartLine];
}

- (instancetype)initHeapWithDictionary:(NSDictionary *)dictionary measureIndex:(NSInteger)index {
    return [self initFromJson:dictionary valueName:[NSString stringWithFormat:@"value%@", @(index)] style:DTDimensionBarStyleHeap];
}

- (instancetype)processHeap:(DTDimension2Model *)model prevModel:(DTDimension2Model *)prevModel {

    if (!prevModel || model.roots.count != prevModel.roots.count) {
        return model;
    }

    BOOL isDifferent = NO;
    for (NSUInteger i = 0; i < model.roots.count; ++i) {
        DTDimension2Item *item1 = model.roots[i];
        DTDimension2Item *item2 = prevModel.roots[i];

        if (![item1.name isEqualToString:item2.name]) {
            isDifferent = YES;
            break;
        }
    }

    if (!isDifferent) { // 相同的根节点，合并
        NSMutableArray *items = prevModel.items.mutableCopy;
        [items addObjectsFromArray:model.items];
        prevModel.items = items;
        return prevModel;
    } else {
        return model;
    }
}


- (instancetype)initFromJson:(NSDictionary *)json valueName:(NSString *)valueName style:(DTDimensionBarStyle)style {
    if (self = [super init]) {
        NSArray *names = json[@"name"];
        CGFloat value = 0;
        BOOL valueIsNull = NO;
        id valueObj = json[valueName];
        if ([valueObj isKindOfClass:[NSString class]]) {
            NSString *valueString = valueObj;
            if ([valueString isEqualToString:@"null"]) {
                valueIsNull = YES;
            } else {
                value = valueString.doubleValue;
            }
        } else if ([valueObj isKindOfClass:[NSNumber class]]) {
            NSNumber *valueNumber = valueObj;
            value = valueNumber.doubleValue;
        }

        if (names.count > 0) {
            NSMutableArray<DTDimension2Item *> *roots = [NSMutableArray arrayWithCapacity:names.count - 1];

            NSUInteger count = 0;
            if (style == DTDimensionBarStyleStartLine) {
                count = names.count;
            } else if (style == DTDimensionBarStyleHeap) {
                count = names.count - 1;
            }

            for (NSUInteger i = 0; i < count; ++i) {
                id obj = names[i];
                NSString *name = nil;
                NSString *fullName = nil;
                if ([obj isKindOfClass:[NSString class]]) {
                    name = obj;
                    fullName = obj;
                } else if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *nameDic = obj;
                    name = nameDic[@"name"];
                    if (!name) {
                        name = @"";
                    }
                    fullName = nameDic[@"fullName"];
                    if (!fullName) {
                        fullName = name;
                    }
                }

                DTDimension2Item *item = [DTDimension2Item initWithName:name value:0];
                item.fullName = fullName;
                [roots addObject:item];
            }
            _roots = roots;
        }

        NSMutableArray<DTDimension2Item *> *items = [NSMutableArray array];

        id obj = names.lastObject;
        NSString *name = nil;
        NSString *fullName = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            name = obj;
            fullName = obj;
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *nameDic = obj;
            name = nameDic[@"name"];
            if (!name) {
                name = @"";
            }
            fullName = nameDic[@"fullName"];
            if (!fullName) {
                fullName = name;
            }
        }

        DTDimension2Item *item = [DTDimension2Item initWithName:name value:value];
        item.valueIsNull = valueIsNull;
        item.fullName = fullName;
        [items addObject:item];
        _items = items;
    }
    return self;
}

- (CGFloat)itemsMaxValue {
    _itemsMaxValue = 0;
    for (DTDimension2Item *item in self.items) {
        if (item.value > 0) {
            _itemsMaxValue += item.value;
        }
    }
    return _itemsMaxValue;
}

- (CGFloat)itemsMinValue {
    _itemsMinValue = 0;
    for (DTDimension2Item *item in self.items) {
        if (item.value < 0) {
            _itemsMinValue += item.value;
        }
    }
    return _itemsMinValue;
}

@end


@implementation DTDimension2ListModel

@end
