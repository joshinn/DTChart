//
//  LineGridCell.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/11.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "LineGridCell.h"
#import "DTLineChartController.h"
#import "DTCommonData.h"

@interface LineGridCell ()

@property(nonatomic) DTLineChartController *lineChartController;

@end

@implementation LineGridCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.lineChartController = [[DTLineChartController alloc] initWithOrigin:CGPointMake(15, 3 * 15) xAxis:23 yAxis:11];
        [self.contentView addSubview:self.lineChartController.chartView];

    }
    return self;
}


- (void)setLineChartData:(NSString *)seriesName data:(NSArray<DTCommonData *> *)listData {
    [self.lineChartController addItem:@"10086" seriesName:seriesName values:listData];
    [self.lineChartController drawChart];
}

@end
