//
//  VBarPresentationVC.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/16.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "VBarPresentationVC.h"
#import "DTCommonData.h"
#import "DTVerticalBarChartController.h"
#import "DTAxisFormatter.h"

@interface VBarPresentationVC ()

@property (nonatomic) DTVerticalBarChartController *barChartController;

@end

@implementation VBarPresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DTRGBColor(0x303030, 1);


    self.barChartController = [[DTVerticalBarChartController alloc] initWithOrigin:CGPointMake(8 * 15, 6 * 15) xAxis:75 yAxis:41];
    self.barChartController.chartMode = DTChartModePresentation;
    self.barChartController.valueSelectable = YES;

    [self.barChartController setMainAxisColorsCompletionBlock:^(NSArray<UIColor *> *colors, NSArray<NSString *> *seriesIds) {
        DTLog(@"vertical bar main axis colors = %@ \nseriesIds = %@", colors, seriesIds);
    }];
    [self.barChartController setSecondAxisColorsCompletionBlock:^(NSArray<UIColor *> *colors, NSArray<NSString *> *seriesIds) {
        DTLog(@"vertical bar second axis colors = %@ \nseriesIds = %@", colors, seriesIds);
    }];
    [self.view addSubview:self.barChartController.chartView];

    DTAxisFormatter *formatter = [DTAxisFormatter axisFormatter];
    formatter.mainYAxisType = DTAxisFormatterTypeNumber;
    formatter.secondYAxisType = DTAxisFormatterTypeNumber;
    formatter.xAxisType = DTAxisFormatterTypeDate;
    formatter.xAxisDateSubType = DTAxisFormatterDateSubTypeMonth | DTAxisFormatterDateSubTypeDay;
    [self.barChartController setItems:self.chartId listData:self.listBarData axisFormat:formatter];



}



@end
