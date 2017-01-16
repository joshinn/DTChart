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
#import "DTChartBaseComponent.h"
#import "DTAxisFormatter.h"

@interface LineGridCell ()


@end

@implementation LineGridCell


- (void)setLineChartData:(NSString *)chartId listData:(NSArray<DTListCommonData *> *)listData {

    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartBaseComponent class]]) {
            [obj removeFromSuperview];
        }
    }];

    self.lineChartController = [[DTLineChartController alloc] initWithOrigin:CGPointMake(15, 3 * 15) xAxis:23 yAxis:11];
    [self.lineChartController setMainAxisColorsCompletionBlock:^(NSArray<UIColor *> *colors, NSArray<NSString *> *seriesIds) {
        DTLog(@"main axis colors = %@ \nseriesIds = %@", colors, seriesIds);
    }];
    [self.lineChartController setSecondAxisColorsCompletionBlock:^(NSArray<UIColor *> *colors, NSArray<NSString *> *seriesIds) {
        DTLog(@"second axis colors = %@ \nseriesIds = %@", colors, seriesIds);
    }];
    [self.contentView addSubview:self.lineChartController.chartView];

    DTAxisFormatter *formatter = [DTAxisFormatter axisFormatter];
    formatter.mainYAxisType = DTAxisFormatterTypeNumber;
    formatter.secondYAxisType = DTAxisFormatterTypeNumber;
    formatter.xAxisType = DTAxisFormatterTypeDate;
    formatter.xAxisDateSubType = DTAxisFormatterDateSubTypeMonth | DTAxisFormatterDateSubTypeDay;
    [self.lineChartController setItems:chartId listData:listData axisFormat:formatter];
    [self.lineChartController drawChart];
}

@end
