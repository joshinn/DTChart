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
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 600, 60, 48)];
    [changeBtn setTitle:@"更新" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(updateChart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];


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
    lineChart.multiValues = @[[self simulateData:4], [self simulateData:5], [self simulateData:8]];
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

- (NSMutableArray<DTChartItemData *> *)simulateData:(NSUInteger)count {
    NSMutableArray<DTChartItemData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= count; ++i) {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(i, 30 + arc4random_uniform(90));

        [values addObject:data];
    }

    return values;
}

- (void)updateChart:(UIButton *)sender {
    NSUInteger count = 1 + arc4random_uniform(6);
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 1; i <= count; ++i) {
        [values addObject:[self simulateData:8]];
    }
    self.lineChart.multiValues = values;

    self.lineChart.showAnimation = arc4random_uniform(2) % 2 == 1;
    [self.lineChart drawChart];
}


@end
