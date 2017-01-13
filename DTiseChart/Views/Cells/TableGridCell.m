//
//  TableGridCell.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/13.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "TableGridCell.h"
#import "DTTableChartController.h"
#import "DTChartBaseComponent.h"

@implementation TableGridCell


- (void)setLineChartData:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData {

    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartBaseComponent class]]) {
            [obj removeFromSuperview];
        }
    }];


}

@end
