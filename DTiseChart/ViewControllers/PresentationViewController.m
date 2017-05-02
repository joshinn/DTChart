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
#import "DTChartBlockModel.h"

@interface PresentationViewController ()

@property(nonatomic) DTLineChartController *lineChartController;

@end

@implementation PresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = DTRGBColor(0x303030, 1);

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 1366, 800)];
    scrollView.contentSize = CGSizeMake(1366, 1600);
    [self.view addSubview:scrollView];

    self.lineChartController = [[DTLineChartController alloc] initWithOrigin:CGPointMake(8 * 15, 6 * 15) xAxis:71 yAxis:37];
    self.lineChartController.chartMode = DTChartModePresentation;
    self.lineChartController.valueSelectable = YES;
    self.lineChartController.axisBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    self.lineChartController.chartView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    self.lineChartController.mainYAxisMaxValueLimit = 1;

    WEAK_SELF;
    [self.lineChartController setLineChartTouchBlock:^NSString *(NSString *seriesId, NSUInteger pointIndex) {
        DTLog(@"touched id = %@ point = %@", seriesId, @(pointIndex));
        __block DTCommonData *commonData = nil;
        [weakSelf.listLineData enumerateObjectsUsingBlock:^(DTListCommonData *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.seriesId isEqualToString:seriesId]) {
                commonData = obj.commonDatas[pointIndex];
            }
        }];
        return [NSString stringWithFormat:@"点击了%@\n大小是%@", commonData.ptName, @(commonData.ptValue)];
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
    [scrollView addSubview:self.lineChartController.chartView];

    DTAxisFormatter *formatter = [DTAxisFormatter axisFormatter];
    formatter.mainYAxisFormat = @"%.0f%%";
    formatter.mainYAxisUnit = @"人";
    formatter.mainYAxisScale = 100;
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

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//
//    [self.lineChartController destroyChart];
//}

@end
