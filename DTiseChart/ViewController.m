//
//  ViewController.m
//  DTiseChart
//
//  Created by 徐进 on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "ViewController.h"
#import "DTBarChart.h"
#import "DTChartData.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self loadSubviews];
}

- (void)loadSubviews {
    NSMutableArray<DTChartItemData *> *values = [NSMutableArray array];
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(1, 40);

        [values addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(2, 30);

        [values addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(3, 60);

        [values addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(4, 90);

        [values addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(5, 10);

        [values addObject:data];
    }

    NSArray<NSString *> *xTitles = @[@"新昌", @"上海", @"南京", @"杭州", @"绍兴"];
    NSMutableArray<DTAxisLabelData *> *xAxisLabelDatas = [NSMutableArray array];
    {
        [xTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            [xAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:idx + 1]];
        }];
    }
    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];
    {
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"0" value:0]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"30" value:30]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"60" value:60]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"90" value:90]];
    }

    DTBarChart *barChart = [[DTBarChart alloc] initWithFrame:CGRectMake(15, 200, DefaultCoordinateAxisCellWidth * 23, DefaultCoordinateAxisCellWidth * 11)];
    barChart.xAxisMaxValue = xAxisLabelDatas.lastObject.value;
    barChart.yAxisMaxValue = yAxisLabelDatas.lastObject.value;
    barChart.backgroundColor = [UIColor lightGrayColor];
    barChart.xAxisLabelDatas = xAxisLabelDatas;
    barChart.yAxisLabelDatas = yAxisLabelDatas;
    barChart.values = values;
    [self.view addSubview:barChart];
//    barChart.showCoordinateAxisLine  = NO;
//    barChart.showCoordinateAxis = NO;

    [barChart drawChart];
}


@end
