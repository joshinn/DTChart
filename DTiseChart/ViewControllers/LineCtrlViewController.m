//
//  LineCtrlViewController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "LineCtrlViewController.h"
#import "DTLineChartController.h"

@interface LineCtrlViewController ()

@property (nonatomic) DTLineChartController *lineChartController;

@end

@implementation LineCtrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    self.lineChartController = [[DTLineChartController alloc] initWithOrigin:CGPointMake(30, 260) xAxis:22 yAxis:11];

    [self.view addSubview:self.lineChartController.chartView];
}


@end
