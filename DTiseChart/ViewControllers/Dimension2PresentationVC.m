//
//  Dimension2PresentationVC.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "Dimension2PresentationVC.h"
#import "DTDimensionBarChart.h"
#import "DTDimension2Model.h"
#import "DTDimensionBarChartController.h"

@interface Dimension2PresentationVC ()

@property (nonatomic) DTDimensionBarChartController *chartController;

@end

@implementation Dimension2PresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DTRGBColor(0x2f2f2f, 1);


//    [self loadChart];
    [self loadChartController];
}

- (void)loadChart {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"d2" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *array = json[@"data"];
    NSInteger measureNum = [json[@"measureNum"] integerValue];
    CGFloat max1Value = [json[@"max1"] doubleValue];
    CGFloat min1Value = [json[@"min1"] doubleValue];
    CGFloat max2Value = [json[@"max2"] doubleValue];
    CGFloat min2Value = [json[@"min2"] doubleValue];

    NSMutableArray<DTDimension2Model *> *listMainPt = [NSMutableArray arrayWithCapacity:array.count];
    NSMutableArray<DTDimension2Model *> *listSecondPt = [NSMutableArray arrayWithCapacity:array.count];

    for (NSDictionary *dictionary in array) {
        [listMainPt addObject:[[DTDimension2Model alloc] initWithDictionary:dictionary measureIndex:1]];
    }
    if (measureNum == 2) {
        for (NSDictionary *dictionary in array) {
            [listSecondPt addObject:[[DTDimension2Model alloc] initWithDictionary:dictionary measureIndex:2]];
        }
    }

    max1Value = 500;
    min1Value = -100;

    DTDimension2ListModel *listMainModel = [[DTDimension2ListModel alloc] init];
    listMainModel.title = @"价格%税收";
    listMainModel.listDimensions = listMainPt;
    listMainModel.maxValue = max1Value;
    listMainModel.minValue = min1Value;

    DTDimension2ListModel *listSecondModel = [[DTDimension2ListModel alloc] init];
    listSecondModel.title = @"气温X雨水量";
    listSecondModel.listDimensions = listSecondPt;
    listSecondModel.maxValue = max2Value;
    listSecondModel.minValue = min2Value;


    NSMutableArray<DTAxisLabelData *> *xLabels = [NSMutableArray array];
    [xLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"-100" value:-100]];
    [xLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"0" value:0]];
    [xLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"100" value:100]];
    [xLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"200" value:200]];
    [xLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"300" value:300]];
    [xLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"400" value:400]];
    [xLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"500" value:500]];

    NSMutableArray<DTAxisLabelData *> *xSecondLabels = [NSMutableArray array];
    [xSecondLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"-100" value:-100]];
    [xSecondLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"0" value:0]];
    [xSecondLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"100" value:100]];
    [xSecondLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"200" value:200]];
    [xSecondLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"300" value:300]];
    [xSecondLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"400" value:400]];
    [xSecondLabels addObject:[[DTAxisLabelData alloc] initWithTitle:@"500" value:500]];

    DTDimensionBarChart *chart = [[DTDimensionBarChart alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 262 + 15 * 7) xAxis:55 yAxis:31];
    chart.xAxisLabelDatas = xLabels;
    chart.xSecondAxisLabelDatas = xSecondLabels;
    chart.valueSelectable = YES;
    chart.showCoordinateAxisGrid = YES;
    [self.view addSubview:chart];
    chart.mainData = listMainModel;
    chart.secondData = listSecondModel;
    [chart drawChart];
}

- (void)loadChartController {

    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"d3" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *array = json[@"data"];
    NSInteger measureNum = [json[@"measureNum"] integerValue];
    CGFloat max1Value = [json[@"max1"] doubleValue];
    CGFloat min1Value = [json[@"min1"] doubleValue];
    CGFloat max2Value = [json[@"max2"] doubleValue];
    CGFloat min2Value = [json[@"min2"] doubleValue];

    NSMutableArray<DTDimension2Model *> *listMainPt = [NSMutableArray arrayWithCapacity:array.count];
    NSMutableArray<DTDimension2Model *> *listSecondPt = [NSMutableArray arrayWithCapacity:array.count];

    for (NSDictionary *dictionary in array) {
        [listMainPt addObject:[[DTDimension2Model alloc] initWithDictionary:dictionary measureIndex:1]];
    }
    if (measureNum == 2) {
        for (NSDictionary *dictionary in array) {
            [listSecondPt addObject:[[DTDimension2Model alloc] initWithDictionary:dictionary measureIndex:2]];
        }
    }

    DTDimension2ListModel *listMainModel = [[DTDimension2ListModel alloc] init];
    listMainModel.title = @"价格%税收";
    listMainModel.listDimensions = listMainPt;
    listMainModel.maxValue = max1Value;
    listMainModel.minValue = min1Value;

    DTDimension2ListModel *listSecondModel = [[DTDimension2ListModel alloc] init];
    listSecondModel.title = @"气温X雨水量";
    listSecondModel.listDimensions = listSecondPt;
    listSecondModel.maxValue = max2Value;
    listSecondModel.minValue = min2Value;

//    listSecondModel = nil;

    DTDimensionBarChartController *chartController = [[DTDimensionBarChartController alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 262 + 15 * 7) xAxis:55 yAxis:31];
    chartController.chartId = @"0905";
    chartController.showCoordinateAxisGrid = YES;
    chartController.valueSelectable = YES;
    [chartController setMainData:listMainModel secondData:listSecondModel];
    [self.view addSubview:chartController.chartView];
    [chartController drawChart];

    self.chartController = chartController;
}

@end
