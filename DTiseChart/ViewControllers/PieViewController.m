//
//  PieViewController.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/26.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "PieViewController.h"
#import "DTPieChart.h"
#import "DTChartData.h"

@interface PieViewController ()

@property(nonatomic) DTPieChart *pieChart;

@end

@implementation PieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self loadSubviews];
}

- (void)loadSubviews {

    self.pieChart = [[DTPieChart alloc] initWithOrigin:CGPointMake(30, 150) xAxis:21 yAxis:20];
    self.pieChart.coordinateAxisInsets = ChartEdgeInsetsMake(0, 0, 0, 0);
    self.pieChart.showAnimation = YES;
    self.pieChart.multiData = @[[self simulateData:3], [self simulateData:4], [self simulateData:2], [self simulateData:1]];
    WEAK_SELF;
    [self.pieChart setPieChartTouchBlock:^(NSUInteger index) {
        [weakSelf itemClicked:index];
    }];


    [self.view addSubview:self.pieChart];
    [self.pieChart drawChart];
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

- (void)itemClicked:(NSUInteger)index {
    self.pieChart.drawSingleDataIndex = index;
    self.pieChart.pieChartTouchBlock = nil;
    [self.pieChart drawChart];
}



@end
