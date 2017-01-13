//
//  BarViewController.m
//  DTiseChart
//
//  Created by 徐进 on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "BarViewController.h"
#import "DTBarChart.h"
#import "DTChartData.h"
#import "DTVerticalBarChart.h"
#import "DTHorizontalBarChart.h"
#import "DTColor.h"

@interface BarViewController ()

@property(nonatomic) NSMutableArray<DTAxisLabelData *> *xAxisLabelDatas;
@property(nonatomic) DTVerticalBarChart *barChart;
@property(nonatomic) DTHorizontalBarChart *horizontalBarChart;

@end

@implementation BarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self loadSubviews];
}

- (void)loadSubviews {
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 600, 60, 48)];
    [changeBtn setTitle:@"更新" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(updateChart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];



//    NSArray<NSString *> *xTitles = @[@"新昌", @"上海", @"南京", @"杭州", @"绍兴", @"苏州", @"无锡", @"发改委", @"徐州", @"中南海"];
//    NSArray<NSString *> *xTitles = @[@"新昌", @"上海", @"南京", @"杭州", @"绍兴", @"苏州", @"无锡", @"发改委"];
    NSArray<NSString *> *xTitles = @[@"新昌", @"上海", @"南京", @"杭州", @"绍兴", @"苏州"];
    self.xAxisLabelDatas = [NSMutableArray array];
    {
        [xTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            [self.xAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:idx + 1]];
        }];
    }
    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];
    {
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"30" value:30]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"60" value:60]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"90" value:90]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"120" value:120]];
    }

    NSMutableArray<DTChartSingleData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 3; ++i) {
        [values addObject:[self simulateData:8]];
    }

    // 竖直chart
    DTVerticalBarChart *barChart = [[DTVerticalBarChart alloc] initWithOrigin:CGPointMake(15, 70) xAxis:21 yAxis:11];
    barChart.xAxisLabelDatas = self.xAxisLabelDatas;
    barChart.yAxisLabelDatas = yAxisLabelDatas;
    barChart.multiData = values;
    barChart.xAxisLabelColor = barChart.yAxisLabelColor = [UIColor blackColor];
    [self.view addSubview:barChart];
    self.barChart = barChart;
//    barChart.showCoordinateAxisLine  = NO;
//    barChart.showCoordinateAxis = NO;
    barChart.showCoordinateAxisGrid = YES;


    [barChart drawChart];


    NSMutableArray<DTChartItemData *> *values2 = [NSMutableArray array];
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(60, 1);

        [values2 addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(76, 2);

        [values2 addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(54, 3);

        [values2 addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(63, 4);

        [values2 addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(82, 5);

        [values2 addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(98, 6);

        [values2 addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(116, 7);

        [values2 addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(100, 8);

        [values2 addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(45, 9);

        [values2 addObject:data];
    }
    {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(70, 10);

        [values2 addObject:data];
    }


    // 水平chart
    DTHorizontalBarChart *hBarChart = [[DTHorizontalBarChart alloc] initWithOrigin:CGPointMake(60, 260) xAxis:11 yAxis:21];
    hBarChart.yAxisLabelDatas = self.xAxisLabelDatas;
    hBarChart.xAxisLabelDatas = yAxisLabelDatas;
    hBarChart.singleData = [DTChartSingleData singleData:values2];
    hBarChart.xAxisLabelColor = hBarChart.yAxisLabelColor = [UIColor blackColor];
    [self.view addSubview:hBarChart];
    self.horizontalBarChart = hBarChart;
//    barChart.showCoordinateAxisLine  = NO;
//    barChart.showCoordinateAxis = NO;
    hBarChart.showAnimation = NO;
    hBarChart.showCoordinateAxisGrid = YES;
    hBarChart.valueSelectable = NO;


    [hBarChart drawChart];
}

- (DTChartSingleData *)simulateData:(NSUInteger)count {
    NSMutableArray<DTChartItemData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= count; ++i) {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(i, 30 + arc4random_uniform(40));

        [values addObject:data];
    }
    DTChartSingleData *singleData = [DTChartSingleData singleData:values];
    return singleData;
}

- (DTChartSingleData *)simulateHorizontalData:(NSUInteger)count {
    NSMutableArray<DTChartItemData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= count; ++i) {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(30 + arc4random_uniform(90), i);

        [values addObject:data];
    }
    DTChartSingleData *singleData = [DTChartSingleData singleData:values];
    return singleData;
}


- (void)updateChart:(UIButton *)sender {
//    NSArray<NSString *> *xTitles;
//    if (self.xAxisLabelDatas.count > 5) {
//        xTitles = @[@"新昌", @"上海"];
//    } else {
//        xTitles = @[@"新昌", @"上海", @"南京", @"杭州", @"绍兴", @"苏州", @"无锡", @"发改委", @"徐州", @"中南海"];
//    }
//    [self.xAxisLabelDatas removeAllObjects];
//    [xTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
//        [self.xAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:idx + 1]];
//    }];
//
//    self.barChart.xAxisLabelDatas = self.xAxisLabelDatas;
//    [self.barChart drawChart];
//
//    self.horizontalBarChart.yAxisLabelDatas = self.xAxisLabelDatas;
//    [self.horizontalBarChart drawChart];


    NSMutableArray<DTChartSingleData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 3; ++i) {
        [values addObject:[self simulateData:8]];
    }
    self.barChart.multiData = values;
    self.barChart.barChartStyle = DTBarChartStyleHeap;
    [self.barChart drawChart];

    NSMutableArray<DTChartSingleData *> *values2 = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 3; ++i) {
        [values2 addObject:[self simulateHorizontalData:8]];
    }
    self.horizontalBarChart.multiData = values2;
    self.horizontalBarChart.barChartStyle = DTBarChartStyleLump;
    self.horizontalBarChart.showAnimation = YES;
    [self.horizontalBarChart drawChart];
}

@end
