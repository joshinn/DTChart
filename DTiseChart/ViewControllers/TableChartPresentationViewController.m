//
//  TableChartPresentationViewController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/14.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "TableChartPresentationViewController.h"
#import "DTCommonData.h"
#import "DTTableChartController.h"

@interface TableChartPresentationViewController ()

@property(nonatomic) DTTableChartController *tableChartController;

@end

@implementation TableChartPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = DTRGBColor(0x303030, 1);

    self.tableChartController = [[DTTableChartController alloc] initWithOrigin:CGPointMake(8 * 15, 6 * 15) xAxis:75 yAxis:41];
    [self.view addSubview:self.tableChartController.chartView];

    DTAxisFormatter *formatter = [DTAxisFormatter axisFormatter];
    [self.tableChartController setItems:self.chartId listData:self.listLineData axisFormat:formatter];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.tableChartController drawChart];
}


@end
