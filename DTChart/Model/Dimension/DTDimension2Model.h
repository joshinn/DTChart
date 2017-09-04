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

@property(nonatomic) NSString *name;    ///< 显示坐标系里的名称

@property(nonatomic) NSString *fullName;    ///< 触摸显示的全名

@property(nonatomic) CGFloat value;

/**
 * 值是否是空值
 */
@property(nonatomic) BOOL valueIsNull;

+ (instancetype)initWithName:(NSString *)name value:(CGFloat)value;

@end


@interface DTDimension2Model : NSObject

@property(nonatomic) NSArray<DTDimension2Item *> *roots;

@property(nonatomic) NSArray<DTDimension2Item *> *items;

@property(nonatomic) CGFloat itemsMaxValue;
@property(nonatomic) CGFloat itemsMinValue;

- (instancetype)initStartLineWithDictionary:(NSDictionary *)dictionary measureIndex:(NSInteger)index;

- (instancetype)initHeapWithDictionary:(NSDictionary *)dictionary measureIndex:(NSInteger)index;

/**
 * 处理heap模式柱状体
 * @param model 当前柱状体数据
 * @param prevModel 上一个柱状体数据
 * @return 如果model和prevModel的root数组里有重复的值，则返回合并后的prevModel，反之返回model
 */
- (instancetype)processHeap:(DTDimension2Model *)model prevModel:(DTDimension2Model *)prevModel;

@end


@interface DTDimension2ListModel : NSObject

@property(nonatomic) NSArray<DTDimension2Model *> *listDimensions;

@property(nonatomic) NSString *title;

@property(nonatomic) CGFloat minValue;

@property(nonatomic) CGFloat maxValue;

@end
