//
//  DTTableChartTitleOrderModel.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/3.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTTableChartTitleOrderModel : NSObject
/**
 * 是否显示升降序按钮，默认YES
 */
@property(nonatomic, getter=isShowOrder) BOOL showOrder;
/**
 * 是否是升序，默认YES
 */
@property(nonatomic, getter=isAscending) BOOL ascending;

@end
