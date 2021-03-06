//
//  DTDimensionBarModel.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/28.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTDimensionBarModel : NSObject

@property(nonatomic) NSString *title;
@property(nonatomic) UIColor *color;
@property(nonatomic) UIColor *secondColor;

/**
 * 筛选多余项使用，与数据无关
 */
@property(nonatomic) BOOL selected;

@end
