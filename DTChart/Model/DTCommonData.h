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

- (instancetype)initWithName:(NSString *)name value:(CGFloat)value;
@end
