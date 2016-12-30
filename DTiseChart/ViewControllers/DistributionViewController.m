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

@property (nonatomic) DTDistributionChart *distributionChart;

@end

@implementation DistributionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self loadSubviews];
}

-(void)loadSubviews{
    self.distributionChart = [[DTDistributionChart alloc] initWithOrigin:CGPointMake(15, 100) xAxis:22 yAxis:11];

    [self.view addSubview:self.distributionChart];
}



@end
