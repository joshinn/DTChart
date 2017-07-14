//
//  MultiMeasureDimensionPresentationViewController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/1.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "MultiMeasureDimensionPresentationViewController.h"
#import "DTDimensionHorizontalBarChart.h"
#import "DTDimensionReturnModel.h"
#import "DTDimensionModel.h"
#import "DTMeasureDimensionHorizontalBarChart.h"
#import "DTMeasureDimensionHorizontalBarChartController.h"
#import "DTMeasureDimensionBurgerBarChart.h"
#import "DTMeasureDimensionBurgerBarChartController.h"

@interface MultiMeasureDimensionPresentationViewController ()

@property(nonatomic) DTDimensionModel *model;

@property(nonatomic) DTMeasureDimensionHorizontalBarChart *barChart;

@property(nonatomic) DTMeasureDimensionHorizontalBarChartController *chartController;

@property(nonatomic) DTMeasureDimensionBurgerBarChartController *burgerBarChartController;

@end

@implementation MultiMeasureDimensionPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = DTRGBColor(0x2f2f2f, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view.
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 60, 48)];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeBtn setTitle:@"改模式" forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self chartControllerDraw];
//    [self drawBurgerChart];
    [self drawBurgerChartController];
//    [self chartDraw];
}

- (void)chartControllerDraw {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data4" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    DTDimensionModel *model1 = [DTDimensionModel initWithDictionary:json measureIndex:1];
    DTDimensionModel *model2 = [DTDimensionModel initWithDictionary:json measureIndex:2];


    DTMeasureDimensionHorizontalBarChartController *chartController = [[DTMeasureDimensionHorizontalBarChartController alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 75) xAxis:55 yAxis:31];
//    chartController.barChartStyle = DTBarChartStyleHeap;
    [self.view addSubview:chartController.chartView];
    chartController.chartId = @"1991";
    chartController.valueSelectable = YES;
    [chartController setMainItem:model1 secondItem:model2];
    chartController.axisBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    chartController.showCoordinateAxisGrid = YES;

    self.chartController = chartController;

    [chartController drawChart];

}

- (void)drawBurgerChart {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data4" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    DTDimensionModel *model1 = [DTDimensionModel initWithDictionary:json measureIndex:1];
    DTDimensionModel *model2 = [DTDimensionModel initWithDictionary:json measureIndex:2];

    NSMutableArray *xLabelDatas = [NSMutableArray array];
    for (NSUInteger i = 0; i < 5; i++) {
        DTAxisLabelData *labelData = [[DTAxisLabelData alloc] initWithTitle:[NSString stringWithFormat:@"%@%%", @(i * 25)] value:i * 0.25f];
        [xLabelDatas addObject:labelData];
    }
    NSMutableArray *xSecondLabelDatas = [NSMutableArray array];
    for (NSUInteger i = 0; i < 5; i++) {
        DTAxisLabelData *labelData = [[DTAxisLabelData alloc] initWithTitle:[NSString stringWithFormat:@"%@%%", @(i * 25)] value:i * 0.25f];
        [xSecondLabelDatas addObject:labelData];
    }

    DTMeasureDimensionBurgerBarChart *burgerChart = [[DTMeasureDimensionBurgerBarChart alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 75 + 32 * 15) xAxis:55 yAxis:31];
    burgerChart.valueSelectable = YES;
    burgerChart.barWidth = 2;
    burgerChart.yOffset = 2 * 15;
    burgerChart.mainDimensionModel = model1;
    burgerChart.secondDimensionModel = model2;
    burgerChart.xAxisLabelDatas = xLabelDatas;
    burgerChart.xSecondAxisLabelDatas = xSecondLabelDatas;
    burgerChart.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    burgerChart.showCoordinateAxisGrid = YES;
    [self.view addSubview:burgerChart];

    [burgerChart drawChart];
}

- (void)drawBurgerChartController {

    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data4" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    DTDimensionModel *model1 = [DTDimensionModel initWithDictionary:json measureIndex:1];
    DTDimensionModel *model2 = [DTDimensionModel initWithDictionary:json measureIndex:2];

    DTMeasureDimensionBurgerBarChartController *controller = [[DTMeasureDimensionBurgerBarChartController alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 75 + 32 * 15) xAxis:55 yAxis:31];
    [self.view addSubview:controller.chartView];


    [controller setTouchBurgerMainSubBarBlock:^NSString *(NSArray<DTDimensionModel *> *allSubData, DTDimensionModel *touchData, NSString *dimensionData, NSString *measureData) {

        NSString *format = [NSString stringWithFormat:@"%%.%@f", @(3)];
        NSString *valueString = [NSString stringWithFormat:format, touchData.childrenSumValue];
        CGFloat sum = 0;
        for (DTDimensionModel *item in allSubData) {
            sum += item.childrenSumValue;
        }
        CGFloat percent = 0;
        if (sum != 0) {
            percent = touchData.childrenSumValue / sum;
        }
        NSString *percentString = [NSString stringWithFormat:@"%@%%", [NSString stringWithFormat:format, percent * 100]];


        NSMutableString *message = [NSMutableString string];

        if (dimensionData) {
//            [message appendString:dimensionData.name];   ///< 维度
            [message appendString:@" : "];
            [message appendString:touchData.ptName];
            [message appendString:@"\n"];
        }
        if (measureData) {
//            [message appendString:measureData.name];     ///< 度量
            [message appendString:@" : "];
        }
        [message appendString:valueString];
        [message appendString:@"("];
        [message appendString:percentString];
        [message appendString:@")"];

        return message;

    }];
    [controller setTouchBurgerSecondSubBarBlock:^NSString *(NSArray<DTDimensionModel *> *allSubData, DTDimensionModel *touchData, NSString *dimensionData, NSString *measureData) {
        NSString *format = [NSString stringWithFormat:@"%%.%@f", @(0)];
        NSString *valueString = [NSString stringWithFormat:format, touchData.childrenSumValue];
        CGFloat sum = 0;
        for (DTDimensionModel *item in allSubData) {
            sum += item.childrenSumValue;
        }
        CGFloat percent = 0;
        if (sum != 0) {
            percent = touchData.childrenSumValue / sum;
        }
        NSString *percentString = [NSString stringWithFormat:@"%@%%", [NSString stringWithFormat:format, percent * 100]];


        NSMutableString *message = [NSMutableString string];

        if (dimensionData) {
//            [message appendString:dimensionData.name];   ///< 维度
            [message appendString:@" : "];
            [message appendString:touchData.ptName];
            [message appendString:@"\n"];
        }
        if (measureData) {
//            [message appendString:measureData.name];     ///< 度量
            [message appendString:@" : "];
        }
        [message appendString:valueString];
        [message appendString:@"("];
        [message appendString:percentString];
        [message appendString:@")"];

        return message;
    }];

    [controller setBurgerMainSubBarInfoBlock:^(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, id dimensionData, NSUInteger dimensionIndex) {
//        for (DTDimensionModel *model3 in allSubData) {
//            DTLog(@"name = %@", model3.ptName);
//        }
    }];
    [controller setBurgerSecondSubBarInfoBlock:^(NSArray<DTDimensionModel *> *allSubData, NSArray<UIColor *> *barAllColor, id dimensionData, NSUInteger dimensionIndex) {
//        for (DTDimensionModel *model3 in allSubData) {
//            DTLog(@"name = %@", model3.ptName);
//        }
    }];


    controller.chartMode = DTChartModeThumb;
    controller.valueSelectable = YES;
    controller.showCoordinateAxisGrid = YES;
    controller.chartId = @"1992";
    controller.axisBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [controller setMainItem:model1 secondItem:model2];
    [controller drawChart];

    self.burgerBarChartController = controller;

}

- (void)chartDraw {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data2" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    self.model = [DTDimensionModel initWithDictionary:json measureIndex:1];

    DTMeasureDimensionHorizontalBarChart *barChart = [[DTMeasureDimensionHorizontalBarChart alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 262 + 15 * 7) xAxis:55 yAxis:31];

    barChart.barWidth = 2;

    DTDimensionReturnModel *returnModel = [barChart calculateMain:self.model];
    DTLog(@"********************************************************sectionWidth cell count = %@", @(returnModel.sectionWidth / 15));
    barChart.coordinateAxisInsets = ChartEdgeInsetsMake((NSUInteger) returnModel.level, barChart.coordinateAxisInsets.top, barChart.coordinateAxisInsets.right, barChart.coordinateAxisInsets.bottom);


//    barChart.yOffset = (CGRectGetWidth(barChart.contentView.bounds) - returnModel.sectionWidth) / 2;
//    barChart.yOffset = (NSInteger) (barChart.yOffset / 15) * 15;
//    barChart.xOffset = 5 * 15;

    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];
    {
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"0" value:0]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"60" value:60]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"120" value:120]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"180" value:180]];
    }

    NSMutableArray<DTChartSingleData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 4; ++i) {
        [values addObject:[self simulateData:4 index:i]];
    }

    barChart.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    barChart.xAxisLabelDatas = yAxisLabelDatas;
    barChart.xSecondAxisLabelDatas = yAxisLabelDatas;

    barChart.xAxisLabelColor = barChart.yAxisLabelColor = [UIColor whiteColor];
    barChart.mainDimensionModel = self.model;
    barChart.secondDimensionModel = self.model;
    [self.view addSubview:barChart];
//    barChart.showCoordinateAxisLine  = NO;
    barChart.showCoordinateAxisLine = YES;
    barChart.showCoordinateAxisGrid = YES;

    self.barChart = barChart;

    [barChart drawChart:returnModel];

}


- (DTChartSingleData *)simulateData:(NSUInteger)count index:(NSUInteger)index {
    NSMutableArray<DTChartItemData *> *values = [NSMutableArray array];

    for (NSUInteger i = 1; i <= count; ++i) {
        DTChartItemData *data = [DTChartItemData chartData];
        data.itemValue = ChartItemValueMake(i, 30 + 10 * i);

        if (index != i) {
            [values addObject:data];
        }
    }

    DTChartSingleData *singleData = [DTChartSingleData singleData:values];
    return singleData;
}


- (void)change:(UIButton *)sender {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data3" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    self.model = [DTDimensionModel initWithDictionary:json measureIndex:1];

    if (self.chartController.barChartStyle == DTBarChartStyleHeap) {
        self.chartController.barChartStyle = DTBarChartStyleStartingLine;
    } else if (self.chartController.barChartStyle == DTBarChartStyleStartingLine) {
        self.chartController.barChartStyle = DTBarChartStyleHeap;
    }

    [self.chartController setMainItem:self.model secondItem:self.model];
    [self.chartController drawChart];
}

@end
