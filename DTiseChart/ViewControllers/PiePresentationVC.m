//
//  PiePresentationVC.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/19.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "PiePresentationVC.h"
#import "DTCommonData.h"
#import "DTPieChartController.h"

@interface PiePresentationVC ()

@property (nonatomic) DTPieChartController *pieChartController;

@property (nonatomic) DTPieChartController *pPieCC;

@end

@implementation PiePresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DTRGBColor(0x303030, 1);


    self.pieChartController = [[DTPieChartController alloc] initWithOrigin:CGPointMake(15 * 8, 6 * 15) xAxis:23 yAxis:11];
    self.pieChartController.drawMainChartSingleIndex = 0;
    [self.pieChartController setMainAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
        [infos enumerateObjectsUsingBlock:^(DTChartBlockModel *obj, NSUInteger idx, BOOL *stop) {
            DTLog(@"main axis color = %@ \nseriesId = %@", obj.color, obj.seriesId);
        }];
    }];
    [self.pieChartController setPieChartTouchBlock:^(NSString *seriesId, NSInteger partIndex) {
        DTLog(@"pie chart series id = %@ index = %@", seriesId, @(partIndex));
    }];

    [self.pieChartController setMainChartItemsColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
        DTLog(@"pie chart main chart items color = %@", infos);
    }];
    [self.pieChartController setSecondChartItemsColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
        DTLog(@"pie chart second chart items color = %@", infos);
    }];

    [self.view addSubview:self.pieChartController.chartView];

    [self.pieChartController setItems:self.chartId listData:self.listBarData axisFormat:nil];


    self.pPieCC = [[DTPieChartController alloc] initWithOrigin:CGPointMake(8 * 15, 20 * 15) xAxis:75 yAxis:41];
    self.pPieCC.chartMode = DTChartModePresentation;
    self.pPieCC.valueSelectable = YES;

    [self.pPieCC setMainAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
        [infos enumerateObjectsUsingBlock:^(DTChartBlockModel *obj, NSUInteger idx, BOOL *stop) {
            DTLog(@"main axis color = %@ \nseriesId = %@", obj.color, obj.seriesId);
        }];
    }];
    [self.pPieCC setPieChartTouchBlock:^(NSString *seriesId, NSInteger partIndex) {
        DTLog(@"pie chart series id = %@ index = %@", seriesId, @(partIndex));
    }];

    [self.view addSubview:self.pPieCC.chartView];

    [self.pPieCC setItems:self.chartId listData:self.listBarData axisFormat:nil];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.pieChartController drawChart];
    [self.pPieCC drawChart];
}


@end
