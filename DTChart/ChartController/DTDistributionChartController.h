//
//  DTDistributionChartController.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/20.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"

@interface DTDistributionChartController : DTChartController

@property (nonatomic) NSString *mainTitle;
@property (nonatomic) NSString *secondTitle;

/**
 * y轴起始时间整点数，默认是7
 */
@property (nonatomic) NSUInteger startHour;

@end
