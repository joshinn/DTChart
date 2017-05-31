//
//  DTDimensionBarChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/19.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"
#import "DTDimension2Model.h"

@class DTDimension2ListModel;

@interface DTDimensionBarChartController : DTChartController

@property(nonatomic) DTDimensionBarStyle chartStyle;

@property(nonatomic, copy) NSString *_Nullable (^ _Nullable controllerTouchLabelBlock)(DTDimensionBarStyle chartStyle, NSUInteger row, DTDimension2Model *_Nullable data, NSUInteger index);

@property(nonatomic, copy) NSString *_Nullable (^ _Nullable controllerTouchBarBlock)(DTDimensionBarStyle chartStyle, NSUInteger row, DTDimension2Item *_Nullable touchData, NSString *_Nullable measureName, NSArray<DTDimension2Item *> *_Nullable allSubData, BOOL isMainAxis);

- (void)setMainData:(DTDimension2ListModel *_Nonnull)mainData secondData:(DTDimension2ListModel *_Nullable)secondData;

@end
