//
//  DTDimension2Model.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

@interface DTDimension2Model : NSObject

@property(nonatomic) NSString *ptName;

@property(nonatomic) CGFloat ptValue;

@property(nonatomic) NSArray<NSString *> *ptNames;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary measureIndex:(NSInteger)index;

- (instancetype)initFromJson:(NSDictionary *)json valueName:(NSString *)valueName;
@end


@interface DTDimension2ListModel : NSObject

@property(nonatomic) NSArray<DTDimension2Model *> *listDimensions;

@property(nonatomic) NSString *title;

@property(nonatomic) CGFloat minValue;

@property(nonatomic) CGFloat maxValue;

@end