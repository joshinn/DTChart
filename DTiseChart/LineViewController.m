//
//  LineViewController.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/13.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "LineViewController.h"
#import "DTChartData.h"
#import "DTLineChart.h"

@interface LineViewController ()

@property(nonatomic) NSMutableArray<DTAxisLabelData *> *xAxisLabelDatas;
@property(nonatomic) DTLineChart *lineChart;

@end

@implementation LineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self loadSubviews];
}

- (void)loadSubviews {
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 600, 60, 48)];
    [changeBtn setTitle:@"随机" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(updateChart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];

    UIButton *reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 600, 60, 48)];
    [reloadBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [reloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reloadBtn addTarget:self action:@selector(reloadChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadBtn];

    UIButton *insertBtn = [[UIButton alloc] initWithFrame:CGRectMake(180, 600, 60, 48)];
    [insertBtn setTitle:@"新增" forState:UIControlStateNormal];
    [insertBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [insertBtn addTarget:self action:@selector(insertChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:insertBtn];

    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 600, 60, 48)];
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [delBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delBtn];


    NSArray<NSString *> *xTitles = @[@"9/5", @"9/6", @"9/7", @"9/8", @"9/9", @"9/10", @"9/11", @"9/12"];
//    NSArray<NSString *> *xTitles = @[@"9/5"];
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

    // 水平chart
    DTLineChart *lineChart = [[DTLineChart alloc] initWithOrigin:CGPointMake(30, 260) xAxis:22 yAxis:11];
    lineChart.xAxisLabelDatas = self.xAxisLabelDatas;
    lineChart.yAxisLabelDatas = yAxisLabelDatas;
    lineChart.multiData = @[[self simulateData:8],[self simulateData:8],[self simulateData:8]];
    lineChart.xAxisLabelColor = lineChart.yAxisLabelColor = [UIColor blackColor];
    self.lineChart = lineChart;
    [self.view addSubview:lineChart];
//    self.lineChart = lineChart;
//    barChart.showCoordinateAxisLine  = NO;
//    barChart.showCoordinateAxis = NO;
//    lineChart.showAnimation = NO;
    lineChart.showCoordinateAxisGrid = YES;
//    lineChart.barSelectable = NO;


    [lineChart drawChart];

}

- (DTChartSingleData *)simulateData:(NSUInteger)count {
    NSMutableArray<DTChartItemData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= count; ++i) {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(i, 30 + arc4random_uniform(90));

        [values addObject:data];
    }
    DTChartSingleData *singleData = [DTChartSingleData singleData:values];
    return singleData;
}

- (void)updateChart:(UIButton *)sender {
    NSUInteger count = 1 + arc4random_uniform(6);
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 1; i <= count; ++i) {
        [values addObject:[self simulateData:8]];
    }
    self.lineChart.multiData = values;
    self.lineChart.xAxisAlignGrid = arc4random_uniform(2) % 2 != 1;
    self.lineChart.showAnimation = arc4random_uniform(2) % 2 == 1;
    [self.lineChart drawChart];
}

- (void)reloadChart {
    NSMutableArray *data = [self.lineChart.multiData mutableCopy];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];

    data[0] = [self simulateData:2 + arc4random_uniform(6)];
    [indexSet addIndex:0];

    if (data.count >= 2) {
        data[1] = [self simulateData:2 + arc4random_uniform(6)];
        [indexSet addIndex:1];
    }

    self.lineChart.multiData = data;
    self.lineChart.showAnimation = arc4random_uniform(2) % 2 == 1;
    [self.lineChart reloadChartItems:indexSet withAnimation:arc4random_uniform(2) % 2 != 1];
}

- (void)insertChart {
    NSMutableArray<DTChartSingleData *> *data = [self.lineChart.multiData mutableCopy];
    [data insertObject:[self simulateData:2 + arc4random_uniform(6)] atIndex:0];
    [data insertObject:[self simulateData:2 + arc4random_uniform(6)] atIndex:0];


    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:0];
    [indexSet addIndex:1];

    self.lineChart.multiData = data;
    self.lineChart.showAnimation = arc4random_uniform(2) % 2 == 1;
    [self.lineChart insertChartItems:indexSet withAnimation:arc4random_uniform(2) % 2 != 1];
}

- (void)delChart {
    NSMutableArray *data = [self.lineChart.multiData mutableCopy];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];

    if (data.count >= 3) {
        [data removeObjectAtIndex:2];
        [data removeObjectAtIndex:0];

        [indexSet addIndex:0];
        [indexSet addIndex:2];
    }

    self.lineChart.multiData = data;
    [self.lineChart deleteChartItems:indexSet withAnimation:arc4random_uniform(2) % 2 != 1];
}

@end
