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
#import "DTTableChartSingleData.h"

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


    NSMutableArray<DTTableAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];
    {
        [yAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"来源" value:1]];
        [yAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"来源明细" value:2]];
        [yAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"会话次数" value:3]];
        [yAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"总使用时长" value:4]];
        [yAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"Crash次数" value:5]];
        [yAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"单次使用" value:6]];
        [yAxisLabelDatas addObject:[[DTTableAxisLabelData alloc] initWithTitle:@"多人协作" value:7]];
    }
    yAxisLabelDatas.firstObject.showOrder = NO;
    yAxisLabelDatas[3].ascending = NO;

    NSMutableArray<DTChartSingleData *> *rowData = [NSMutableArray array];
    {
        [rowData addObject:[self simulateData:7 index:0 sId:@"xx1"]];
        [rowData addObject:[self simulateData:7 index:1 sId:@"xx2"]];
        [rowData addObject:[self simulateData:7 index:3 sId:@"xx3"]];
        [rowData addObject:[self simulateData:7 index:4 sId:@"xx3"]];
        [rowData addObject:[self simulateData:7 index:5 sId:@"xx4"]];
        [rowData addObject:[self simulateData:7 index:6 sId:@"xx5"]];
        [rowData addObject:[self simulateData:7 index:7 sId:@"xx6"]];
        [rowData addObject:[self simulateData:7 index:8 sId:@"xx6"]];
        [rowData addObject:[self simulateData:7 index:9 sId:@"xx6"]];
        [rowData addObject:[self simulateData:7 index:10 sId:@"xx7"]];
    }

    self.tableChart = [DTTableChart tableChart:DTTableChartStyleC1C6 origin:CGPointMake(200, 100) widthCellCount:75 heightCellCount:45];
    self.tableChart.headViewHeight = 500;
    self.tableChart.headView.backgroundColor = [UIColor lightGrayColor];
//    self.tableChart.collapseColumn = -1;
    self.tableChart.yAxisLabelDatas = yAxisLabelDatas;
    self.tableChart.multiData = rowData;
    [self.view addSubview:self.tableChart];
    [self.tableChart drawChart];
}

- (DTChartSingleData *)simulateData:(NSUInteger)count index:(NSUInteger)index sId:(NSString *)sId {
    NSMutableArray<DTChartItemData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= count; ++i) {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(i, 30 + arc4random_uniform(90));
        data.title = [NSString stringWithFormat:@"%@~%@~%@", sId, @(index), @(data.itemValue.y)];
        [values addObject:data];
    }
    DTTableChartSingleData *singleData = [DTTableChartSingleData singleData:values];
    singleData.singleId = sId;
    singleData.singleName = [sId stringByAppendingString:@"~name"];
    return singleData;
}


- (void)updateChart {
    self.tableChart.tableChartStyle = DTTableChartStyleC1C3;
    [self.tableChart drawChart];
}

@end
