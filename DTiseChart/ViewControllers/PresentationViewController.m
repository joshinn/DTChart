//
//  PresentationViewController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/13.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "PresentationViewController.h"
#import "DTCommonData.h"
#import "DTLineChartController.h"
#import "DTAxisFormatter.h"
#import "DTChartBlockModel.h"

@interface PresentationViewController ()

@property(nonatomic) DTLineChartController *lineChartController;

@end

@implementation PresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = DTRGBColor(0x303030, 1);

    self.lineChartController = [[DTLineChartController alloc] initWithOrigin:CGPointMake(8 * 15, 6 * 15) xAxis:75 yAxis:41];
    self.lineChartController.chartMode = DTChartModePresentation;
    self.lineChartController.valueSelectable = YES;
    [self.lineChartController setLineChartTouchBlock:^(NSUInteger lineIndex, NSUInteger pointIndex, BOOL isMainAxis) {
        DTLog(@"touch line index = %@ point = %@", @(lineIndex), @(pointIndex));
    }];

    [self.lineChartController setMainAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
        [infos enumerateObjectsUsingBlock:^(DTChartBlockModel *obj, NSUInteger idx, BOOL *stop) {
            DTLog(@"main axis color = %@ \nseriesId = %@", obj.color, obj.seriesId);
        }];
    }];
    [self.lineChartController setSecondAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
        [infos enumerateObjectsUsingBlock:^(DTChartBlockModel *obj, NSUInteger idx, BOOL *stop) {
            DTLog(@"main axis color = %@ \nseriesId = %@", obj.color, obj.seriesId);
        }];
    }];
    [self.view addSubview:self.lineChartController.chartView];

    DTAxisFormatter *formatter = [DTAxisFormatter axisFormatter];
    formatter.mainYAxisType = DTAxisFormatterTypeNumber;
    formatter.secondYAxisType = DTAxisFormatterTypeNumber;
    formatter.xAxisType = DTAxisFormatterTypeDate;
    formatter.xAxisDateSubType = DTAxisFormatterDateSubTypeMonth | DTAxisFormatterDateSubTypeDay;
    [self.lineChartController setItems:self.chartId listData:self.listLineData axisFormat:formatter];

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.lineChartController drawChart];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.lineChartController destroyChart];
}

@end
