#import "DTChartBlockModel.h"//
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
    [self.lineChartController setMainAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
//        [infos enumerateObjectsUsingBlock:^(DTChartBlockModel *obj, NSUInteger idx, BOOL *stop) {
//            DTLog(@"main axis color = %@ \nseriesId = %@ type = %@", obj.color, obj.seriesId, @(obj.type));
//        }];
    }];
    [self.lineChartController setSecondAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
//        [infos enumerateObjectsUsingBlock:^(DTChartBlockModel *obj, NSUInteger idx, BOOL *stop) {
//            DTLog(@"main axis color = %@ \nseriesId = %@ type = %@", obj.color, obj.seriesId, @(obj.type));
//        }];
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
