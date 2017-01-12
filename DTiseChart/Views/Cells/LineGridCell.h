//
//  LineGridCell.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/11.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "GridCell.h"

@class DTListCommonData;
@class DTLineChartController;

@interface LineGridCell : GridCell

@property(nonatomic) DTLineChartController *lineChartController;

- (void)setLineChartData:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData;

@end
