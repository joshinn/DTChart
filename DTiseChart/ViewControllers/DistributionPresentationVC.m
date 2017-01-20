//
//  DistributionPresentationVC.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/20.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DistributionPresentationVC.h"
#import "DTDistributionChart.h"
#import "DTDistributionChartController.h"

@interface DistributionPresentationVC ()

@property(nonatomic) DTDistributionChartController *thumbChart;
@property(nonatomic) DTDistributionChartController *presentChart;

@end

@implementation DistributionPresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = DTRGBColor(0x303030, 1);

    self.listBarData = [self simulateListCommonData:7 pointCount:24 mainAxis:YES];
    [self.listBarData addObjectsFromArray:[self simulateListCommonData:7 pointCount:24 mainAxis:NO]];

    self.thumbChart = [[DTDistributionChartController alloc] initWithOrigin:CGPointMake(15 * 8, 6 * 15) xAxis:23 yAxis:11];

    [self.view addSubview:self.thumbChart.chartView];

    [self.thumbChart setItems:self.chartId listData:self.listBarData axisFormat:nil];


    self.presentChart = [[DTDistributionChartController alloc] initWithOrigin:CGPointMake(8 * 15, 20 * 15) xAxis:75 yAxis:41];
    self.presentChart.chartMode = DTChartModePresentation;
    self.presentChart.mainTitle = @"手机";
    self.presentChart.secondTitle = @"平板";
//    self.presentChart.startHour = 10;

    [self.view addSubview:self.presentChart.chartView];

    [self.presentChart setItems:self.chartId listData:self.listBarData axisFormat:nil];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.thumbChart drawChart];
    [self.presentChart drawChart];
}


- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count {
    return [self simulateCommonData:count baseValue:0];
}

- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count baseValue:(CGFloat)baseValue {
    NSMutableArray<DTCommonData *> *list = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSString *title = [NSString stringWithFormat:@"%@", @(i)];
        CGFloat value = 0;
        if (i <= 6) {
            value = 20;
        } else if (i <= 12) {
            value = 820;
        } else if (i <= 18) {
            value = 1220;
        } else {
            value = 800;
        }
        DTCommonData *data = [DTCommonData commonData:title value:baseValue + value];
        [list addObject:data];
    }

    return list;
}

- (NSString *)dayString:(NSUInteger)value {
    if (value >= 10) {
        return [NSString stringWithFormat:@"%@", @(value)];
    } else {
        return [NSString stringWithFormat:@"0%@", @(value)];
    }

}


- (NSMutableArray<DTListCommonData *> *)simulateListCommonData:(NSUInteger)lineCount pointCount:(NSUInteger)pCount mainAxis:(BOOL)isMain {
    NSMutableArray<DTListCommonData *> *list = [NSMutableArray arrayWithCapacity:lineCount];
    for (NSUInteger i = 0; i < lineCount; ++i) {

        NSString *seriesId = [NSString stringWithFormat:@"weekday%@", @(i)];
        NSString *seriesName = [NSString stringWithFormat:@"星期%@", @(i)];
        DTListCommonData *listCommonData = [DTListCommonData listCommonData:seriesId seriesName:seriesName arrayData:[self simulateCommonData:pCount] mainAxis:isMain];

        [list addObject:listCommonData];
    }

    return list;
}


@end
