//
//  TableChartViewController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "TableChartViewController.h"
#import "DTTableChart.h"
#import "DTTableAxisLabelData.h"

@interface TableChartViewController ()

@property(nonatomic) DTTableChart *tableChart;

@end

@implementation TableChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = YES;

    [self loadSubviews];
}

- (void)loadSubviews {
    self.view.backgroundColor = DTRGBColor(0x303030, 1);

    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 60, 48)];
    [changeBtn setTitle:@"更新" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [changeBtn addTarget:self action:@selector(updateChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];


    NSMutableArray<DTTableAxisLabelData *> *xAxisLabelDatas = [NSMutableArray array];
    {
        [xAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"版本" value:1]];
        [xAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"新增设备" value:2]];
        [xAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"会话次数" value:3]];
        [xAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"总使用时长" value:4]];
        [xAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"Crash次数" value:5]];
        [xAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"单次使用" value:6]];
        [xAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"多人协作" value:7]];
    }
    xAxisLabelDatas.firstObject.showOrder = NO;
    xAxisLabelDatas[3].ascending = NO;

    self.tableChart = [DTTableChart tableChart:DTTableChartStyleC1C6 origin:CGPointMake(200, 100) widthCellCount:75 heightCellCount:45];
    self.tableChart.headViewHeight = 500;
    self.tableChart.headView.backgroundColor = [UIColor lightGrayColor];
    self.tableChart.xAxisLabelDatas = xAxisLabelDatas;
    self.tableChart.multiData = @[[self simulateData:7], [self simulateData:700], [self simulateData:600], [self simulateData:466], [self simulateData:550], [self simulateData:256], [self simulateData:368]];
    [self.view addSubview:self.tableChart];
    [self.tableChart drawChart];
}

- (DTChartSingleData *)simulateData:(NSUInteger)count {
    NSMutableArray<DTChartItemData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= count; ++i) {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(i, 30 + arc4random_uniform(90));
        data.title = [NSString stringWithFormat:@"{%@,%@}", @(data.itemValue.x), @(data.itemValue.y)];
        [values addObject:data];
    }
    DTChartSingleData *singleData = [DTChartSingleData singleData:values];
    return singleData;
}


- (void)updateChart {
    self.tableChart.tableChartStyle = DTTableChartStyleC1C3;
    [self.tableChart drawChart];
}

@end
