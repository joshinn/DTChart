//
//  DTDimensionModel.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/24.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

@interface DTDimensionModel : NSObject

@property(nonatomic) NSString *ptName;

@property(nonatomic) NSArray<DTDimensionModel *> *ptListValue;

@property(nonatomic) CGFloat ptValue;

@property(nonatomic) CGFloat childrenSumValue;

@property(nonatomic) NSString *objectId;

/**
 * 通过字典创建
 * @param dictionary 字典
 * @param index 度量序号，从1开始
 * @return DTDimensionModel instance
 */
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary measureIndex:(NSInteger)index;

+ (instancetype)initWith:(NSString *)name list:(NSArray<DTDimensionModel *> *)list value:(CGFloat)value;

@end


