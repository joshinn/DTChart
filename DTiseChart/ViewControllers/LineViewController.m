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
#import "DTLineChartSingleData.h"

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
    [self buttons];


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
    lineChart.multiData = @[[self simulateData:8], [self simulateData:8], [self simulateData:8]];
    lineChart.xAxisLabelColor = lineChart.yAxisLabelColor = [UIColor blackColor];
    self.lineChart = lineChart;
    [self.view addSubview:lineChart];
//    self.lineChart = lineChart;
//    barChart.showCoordinateAxisLine  = NO;
//    barChart.showCoordinateAxis = NO;
//    lineChart.showAnimation = NO;
    lineChart.showCoordinateAxisGrid = YES;
//    lineChart.barSelectable = NO;


    [lineChart setLineChartTouchBlock:^(NSUInteger lineIndex, NSUInteger pointIndex, BOOL isMainAxis) {
        DTLog(@"line touch index = %@, %@, %@", @(lineIndex), @(pointIndex), isMainAxis ? @"Main axis" : @"Second axis");
    }];

    [lineChart drawChart];

}

- (void)buttons {
    [self buttonFactory:@"随机" frame:CGRectMake(0, 600, 60, 48) action:@selector(updateChart)];
    [self buttonFactory:@"刷新" frame:CGRectMake(60, 600, 60, 48) action:@selector(reloadChart)];
    [self buttonFactory:@"新增" frame:CGRectMake(120, 600, 60, 48) action:@selector(insertChart)];
    [self buttonFactory:@"删除" frame:CGRectMake(180, 600, 60, 48) action:@selector(delChart)];
    [self buttonFactory:@"副轴" frame:CGRectMake(240, 600, 60, 48) action:@selector(addChartSecondAxis)];
    [self buttonFactory:@"副轴新增" frame:CGRectMake(300, 600, 60, 48) action:@selector(secondAxisChartInsert)];

}

- (UIButton *)buttonFactory:(NSString *)title frame:(CGRect)frame action:(SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:button];
    return button;
}

- (DTLineChartSingleData *)simulateData:(NSUInteger)count {
    NSMutableArray<DTChartItemData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= count; ++i) {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(i, 30 + arc4random_uniform(90));
        [values addObject:data];
    }
    DTLineChartSingleData *singleData = [DTLineChartSingleData singleData:values];
    DTLinePointType type;
    switch (arc4random_uniform(3)) {
        case 0:
            type = DTLinePointTypeCircle;
            break;
        case 1:
            type = DTLinePointTypeTriangle;
            break;
        case 2:
            type = DTLinePointTypeSquare;
            break;
        default:
            type = DTLinePointTypeCircle;
            break;
    }
    singleData.pointType = type;
    return singleData;
}

- (DTLineChartSingleData *)simulateSecondData:(NSUInteger)count {
    NSMutableArray<DTChartItemData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= count; ++i) {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(i, 3000 + arc4random_uniform(90) * 100);
        [values addObject:data];
        DTLog(@"second y = %@", @(data.itemValue.y));
    }
    DTLineChartSingleData *singleData = [DTLineChartSingleData singleData:values];
    DTLinePointType type;
    switch (arc4random_uniform(3)) {
        case 0:
            type = DTLinePointTypeCircle;
            break;
        case 1:
            type = DTLinePointTypeTriangle;
            break;
        case 2:
            type = DTLinePointTypeSquare;
            break;
        default:
            type = DTLinePointTypeCircle;
            break;
    }
    singleData.pointType = type;
    return singleData;
}

- (void)updateChart {
    NSUInteger count = 1 + arc4random_uniform(6);
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 1; i <= count; ++i) {
        [values addObject:[self simulateData:8]];
    }
    self.lineChart.multiData = values;
    self.lineChart.xAxisAlignGrid = arc4random_uniform(2) % 2 != 1;
    self.lineChart.showAnimation = arc4random_uniform(2) % 2 == 1;
//    self.lineChart.showCoordinateAxisGrid = arc4random_uniform(2) % 2 == 1;
    self.lineChart.valueSelectable = YES;
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

- (void)addChartSecondAxis {
    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];
    {
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"3k" value:3000]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"6k" value:6000]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"9k" value:9000]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"12k" value:12000]];
    }
    self.lineChart.ySecondAxisLabelDatas = yAxisLabelDatas;
    self.lineChart.secondMultiData = @[[self simulateSecondData:5], [self simulateSecondData:8]];
    self.lineChart.showAnimation = arc4random_uniform(2) % 2 == 1;
    [self.lineChart drawSecondChart];
}


- (void)secondAxisChartInsert {
    NSMutableArray<DTLineChartSingleData *> *data = [self.lineChart.secondMultiData mutableCopy];
    [data insertObject:[self simulateSecondData:2 + arc4random_uniform(6)] atIndex:0];
    [data insertObject:[self simulateSecondData:2 + arc4random_uniform(6)] atIndex:0];


    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:0];
    [indexSet addIndex:1];

    self.lineChart.secondMultiData = data;
    [self.lineChart insertChartSecondAxisItems:indexSet withAnimation:arc4random_uniform(2) % 2 != 1];
}

@end
