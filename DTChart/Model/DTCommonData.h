//
//  DTCommonData.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>


@interface DTCommonData : NSObject

@property(nonatomic) NSString *ptName;
@property(nonatomic) CGFloat ptValue;

+ (instancetype)commonData:(NSString *)name value:(CGFloat)value;
@end


@interface DTListCommonData : NSObject

@property(nonatomic) NSString *seriesId;
/**
 * 单组数据业务名称
 * @attention 同一个seriesName，颜色等相同
 */
@property(nonatomic) NSString *seriesName;
@property(nonatomic) NSArray<DTCommonData *> *commonDatas;
/**
 * 是否主坐标轴，默认YES
 */
@property(nonatomic, getter=isMainAxis) BOOL mainAxis;

+ (instancetype)listCommonData:(NSString *)seriesId seriesName:(NSString *)seriesName arrayData:(NSArray<DTCommonData *> *)array mainAxis:(BOOL)isMainAxis;

@end