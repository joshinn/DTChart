//
//  DTDimension2Model.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>


typedef NS_ENUM(NSInteger, DTDimensionBarStyle) {
    DTDimensionBarStyleStartLine = 0,
    DTDimensionBarStyleHeap = 1,
};

@interface DTDimension2Item : NSObject

@property(nonatomic) NSString *name;

@property(nonatomic) NSString *fullName;

@property(nonatomic) CGFloat value;

+ (instancetype)initWithName:(NSString *)name value:(CGFloat)value;

@end


@interface DTDimension2Model : NSObject

@property(nonatomic) NSArray<DTDimension2Item *> *roots;

@property(nonatomic) NSArray<DTDimension2Item *> *items;

@property(nonatomic) CGFloat itemsMaxValue;
@property(nonatomic) CGFloat itemsMinValue;

- (instancetype)initStartLineWithDictionary:(NSDictionary *)dictionary measureIndex:(NSInteger)index;

- (instancetype)initHeapWithDictionary:(NSDictionary *)dictionary measureIndex:(NSInteger)index prevModel:(DTDimension2Model *)prevModel;
@end


@interface DTDimension2ListModel : NSObject

@property(nonatomic) NSArray<DTDimension2Model *> *listDimensions;

@property(nonatomic) NSString *title;

@property(nonatomic) CGFloat minValue;

@property(nonatomic) CGFloat maxValue;

@end
