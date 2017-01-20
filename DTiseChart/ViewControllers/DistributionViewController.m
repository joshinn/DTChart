//
//  DistributionViewController.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/30.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DistributionViewController.h"
#import "DTDistributionChart.h"

@interface DistributionViewController ()

@property(nonatomic) DTDistributionChart *distributionChart;
@property(nonatomic) NSMutableArray<DTAxisLabelData *> *xAxisLabelDatas;

@end

@implementation DistributionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self loadSubviews];
}

- (void)loadSubviews {

    UIButton *updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 60, 48)];
    [updateBtn setTitle:@"更新" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updateBtn];


    {
        NSArray<NSString *> *xTitles = @[@"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT", @"SUN"];
        self.xAxisLabelDatas = [NSMutableArray array];
        {
            [xTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
                [self.xAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:idx + 1]];
            }];
        }
    }


    self.distributionChart = [[DTDistributionChart alloc] initWithOrigin:CGPointMake(15, 100) xAxis:17 yAxis:11];
//    self.mainDistributionChart = [[DTDistributionChart alloc] initWithOrigin:CGPointMake(15, 100) xAxis:31 yAxis:29];
    self.distributionChart.chartYAxisStyle = DTDistributionChartYAxisStyleSmall;
//    self.mainDistributionChart.coordinateAxisInsets = ChartEdgeInsetsMake(0, 0, 0, 2);
    self.distributionChart.showCoordinateAxisGrid = YES;
    self.distributionChart.xAxisLabelDatas = self.xAxisLabelDatas;

    self.distributionChart.multiData = @[[self simulateData:24 x:1], [self simulateData:24 x:2], [self simulateData:24 x:3], [self simulateData:24 x:4]
//            , [self simulateData:24 x:5]
            , [self simulateData:24 x:6], [self simulateData:24 x:7]];
    [self.view addSubview:self.distributionChart];
    self.view.backgroundColor = self.distributionChart.backgroundColor = DTRGBColor(0x303030, 1);

    [self.distributionChart drawChart];
}


- (DTChartSingleData *)simulateData:(NSUInteger)count x:(CGFloat)x {
    NSMutableArray<DTChartItemData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= count; ++i) {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(x, arc4random_uniform(4));

        [values addObject:data];
    }
    DTChartSingleData *singleData = [DTChartSingleData singleData:values];
    return singleData;
}

- (void)updateChart {
    self.distributionChart.multiData = @[[self simulateData:24 x:1], [self simulateData:24 x:2], [self simulateData:24 x:3], [self simulateData:24 x:4], [self simulateData:24 x:5], [self simulateData:24 x:6], [self simulateData:24 x:7]];

    [self.distributionChart drawChart];
}

@end
