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

@interface MultiMeasureDimensionPresentationViewController ()

@property(nonatomic) DTDimensionModel *model;

@property(nonatomic) DTMeasureDimensionHorizontalBarChart *barChart;

@property(nonatomic) DTMeasureDimensionHorizontalBarChartController *chartController;

@end

@implementation MultiMeasureDimensionPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = DTRGBColor(0x2f2f2f, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view.
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 60, 48)];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeBtn setTitle:@"更新" forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self chartControllerDraw];
//    [self chartDraw];
}

- (void)chartControllerDraw {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data2" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    self.model = [self dataFromJson:json];

    DTMeasureDimensionHorizontalBarChartController *chartController = [[DTMeasureDimensionHorizontalBarChartController alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 262 + 15 * 7) xAxis:55 yAxis:31];
    [self.view addSubview:chartController.chartView];
    chartController.chartId = @"1991";
    [chartController setMainItem:self.model secondItem:self.model];
    chartController.axisBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    chartController.showCoordinateAxisGrid = YES;

    self.chartController = chartController;

    [chartController drawChart];

}

- (void)chartDraw {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data2" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    self.model = [self dataFromJson:json];

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
    NSString *path = [bundle pathForResource:@"data3" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    self.model = [self dataFromJson:json];

    [self.chartController setMainItem:self.model secondItem:self.model];
    [self.chartController drawChart];
}

@end
