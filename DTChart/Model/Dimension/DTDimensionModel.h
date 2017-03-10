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

+ (instancetype)initWith:(NSString *)name list:(NSArray<DTDimensionModel *> *)list value:(CGFloat)value;
@end


