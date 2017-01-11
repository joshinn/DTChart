//
//  LineGridCell.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/11.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "GridCell.h"

@class DTCommonData;

@interface LineGridCell : GridCell


- (void)setLineChartData:(NSString *)seriesName data:(NSArray<DTCommonData *> *)listData;
@end
