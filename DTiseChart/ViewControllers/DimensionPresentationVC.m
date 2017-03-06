//
//  DimensionPresentationVC.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/24.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DimensionPresentationVC.h"
#import "DTDimensionVerticalBarChart.h"
#import "DTDimensionModel.h"
#import "DTDimensionReturnModel.h"
#import "DTDimensionVerticalBarChartController.h"
#import "DTDimensionHorizontalBarChart.h"
#import "DTDimensionHorizontalBarChartController.h"

@interface DimensionPresentationVC ()

@property(nonatomic) DTDimensionVerticalBarChartController *vChartController;
@property(nonatomic) DTDimensionHorizontalBarChartController *hChartController;

@property(nonatomic) DTDimensionModel *model1;
@property(nonatomic) DTDimensionModel *model2;

@end

@implementation DimensionPresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DTRGBColor(0x2f2f2f, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 60, 48)];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeBtn setTitle:@"更新" forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];

    // Do any additional setup after loading the view.

    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data3" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    self.model1 = [self dataFromJson:json];


//    [self horizontalChart];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self chartController];
    [self horizontalChartController];
}


- (void)chartController {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data3" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    self.model1 = [self dataFromJson:json];

    DTDimensionVerticalBarChartController *chartController = [[DTDimensionVerticalBarChartController alloc] initWithOrigin:CGPointMake(100, 80) xAxis:55 yAxis:31];
    chartController.valueSelectable = YES;
    chartController.chartId = @"chart9527";
    chartController.axisBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    chartController.showCoordinateAxisGrid = YES;
    [chartController setItem:self.model1];
    [chartController setDimensionBarChartControllerTouchBlock:^NSString *(NSUInteger touchIndex) {

        return nil;
    }];

    self.vChartController = chartController;

    [self.view addSubview:chartController.chartView];

    [chartController drawChart];
}

- (void)horizontalChartController {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    self.model2 = [self dataFromJson:json];

    DTDimensionHorizontalBarChartController *chartController = [[DTDimensionHorizontalBarChartController alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 262 + 15 * 7 + 190) xAxis:55 yAxis:31];
    chartController.valueSelectable = YES;
    chartController.chartId = @"chart9528";
    chartController.axisBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    chartController.showCoordinateAxisGrid = YES;
    [chartController setItem:self.model2];

    self.hChartController = chartController;

    [self.view addSubview:chartController.chartView];

    [chartController drawChart];
}


- (void)chart {

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


    DTDimensionVerticalBarChart *barChart = [[DTDimensionVerticalBarChart alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 262 + 15 * 7) xAxis:55 yAxis:31];
//    DTDimensionVerticalBarChart *barChart = [[DTDimensionVerticalBarChart alloc] initWithOrigin:CGPointMake(15 * 5, 262 + 15 * 7) xAxis:85 yAxis:31];
    barChart.barWidth = 2;

    DTDimensionReturnModel *returnModel = [barChart calculate:self.model1];
    DTLog(@"********************************************************sectionWidth cell count = %@", @(returnModel.sectionWidth / 15));
    barChart.coordinateAxisInsets = ChartEdgeInsetsMake(barChart.coordinateAxisInsets.left, barChart.coordinateAxisInsets.top, barChart.coordinateAxisInsets.right, (NSUInteger) returnModel.level);


    barChart.xOffset = (CGRectGetWidth(barChart.contentView.bounds) - returnModel.sectionWidth) / 2;
    barChart.xOffset = (NSInteger) (barChart.xOffset / 15) * 15;
//    barChart.xOffset = 5 * 15;

    barChart.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    barChart.yAxisLabelDatas = yAxisLabelDatas;

    barChart.xAxisLabelColor = barChart.yAxisLabelColor = [UIColor whiteColor];
    barChart.dimensionModel = self.model1;
    [self.view addSubview:barChart];
//    barChart.showCoordinateAxisLine  = NO;
    barChart.showCoordinateAxisLine = YES;
    barChart.showCoordinateAxisGrid = YES;


    [barChart drawChart];
}

- (void)horizontalChart {

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


    DTDimensionHorizontalBarChart *barChart = [[DTDimensionHorizontalBarChart alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 262 + 15 * 7) xAxis:55 yAxis:31];
    barChart.valueSelectable = YES;
//    DTDimensionVerticalBarChart *barChart = [[DTDimensionVerticalBarChart alloc] initWithOrigin:CGPointMake(15 * 5, 262 + 15 * 7) xAxis:85 yAxis:31];
    barChart.barWidth = 2;

    DTDimensionReturnModel *returnModel = [barChart calculate:self.model1];
    DTLog(@"********************************************************sectionWidth cell count = %@", @(returnModel.sectionWidth / 15));
    barChart.coordinateAxisInsets = ChartEdgeInsetsMake((NSUInteger) returnModel.level, barChart.coordinateAxisInsets.top, barChart.coordinateAxisInsets.right, barChart.coordinateAxisInsets.bottom);


//    barChart.yOffset = (CGRectGetWidth(barChart.contentView.bounds) - returnModel.sectionWidth) / 2;
//    barChart.yOffset = (NSInteger) (barChart.yOffset / 15) * 15;
//    barChart.xOffset = 5 * 15;

    barChart.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    barChart.xAxisLabelDatas = yAxisLabelDatas;

    barChart.xAxisLabelColor = barChart.yAxisLabelColor = [UIColor whiteColor];
    barChart.dimensionModel = self.model1;
    [self.view addSubview:barChart];
//    barChart.showCoordinateAxisLine  = NO;
    barChart.showCoordinateAxisLine = YES;
    barChart.showCoordinateAxisGrid = YES;


    [barChart drawChart];
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

- (DTDimensionModel *)dataFromJson:(NSDictionary *)json {
    DTDimensionModel *model = [[DTDimensionModel alloc] init];

    if (json[@"name"]) {
        model.ptName = json[@"name"];
    }

    if (json[@"data"]) {
        id data = json[@"data"];
        if ([data isKindOfClass:[NSArray class]]) {

            NSArray *array = data;
            NSMutableArray<DTDimensionModel *> *list = [NSMutableArray arrayWithCapacity:array.count];
            for (NSDictionary *dictionary in array) {
                DTDimensionModel *model2 = [self dataFromJson:dictionary];
                [list addObject:model2];
            }

            model.ptListValue = list;
        }
    }
    if (json[@"value"]) {
        model.ptValue = [json[@"value"] floatValue];
    }

    return model;
}


- (void)change:(UIButton *)sender {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data2" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    [self.hChartController setItem:[self dataFromJson:json]];
    [self.hChartController drawChart];



    [self.vChartController setItem:self.model2];
    [self.vChartController drawChart];
}

@end
