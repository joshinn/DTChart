//
//  FillPresentationVC.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/2/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "FillPresentationVC.h"
#import "DTFillChart.h"
#import "DTFillChartController.h"

@interface FillPresentationVC ()

@property(nonatomic) DTFillChart *fillChart;
@property(nonatomic) NSMutableArray<DTAxisLabelData *> *xAxisLabelDatas;

@property(nonatomic) DTFillChartController *fillChartController;
@property(nonatomic) NSMutableArray<DTListCommonData *> *listLineData;

@end

@implementation FillPresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = DTRGBColor(0x303030, 1);

//    [self loadSubviews];

    [self loadChartController];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.fillChartController drawChart];
}


#pragma mark - Only Chart

- (void)loadSubviews {


    NSArray<NSString *> *xTitles = @[@"9/5", @"9/6", @"9/7", @"9/8", @"9/9", @"9/10", @"9/11", @"9/12"];
//    NSArray<NSString *> *xTitles = @[@"9/5"];
    self.xAxisLabelDatas = [NSMutableArray array];
    {
        [xTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            [self.xAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:title value:idx + 1]];
        }];
    }
    NSMutableArray<DTAxisLabelData *> *yAxisLabelDatas = [NSMutableArray array];
    {
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"30" value:30]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"180" value:180]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"330" value:330]];
        [yAxisLabelDatas addObject:[[DTAxisLabelData alloc] initWithTitle:@"480" value:480]];
    }


    NSMutableArray *multiData = [NSMutableArray array];
    DTChartSingleData *prevSingleData = nil;
    for (NSUInteger i = 0; i < 30; ++i) {
        DTChartSingleData *singleData = [self simulateData:8 prev:prevSingleData];
        prevSingleData = singleData;

        [multiData addObject:singleData];
    }


    // 水平chart
    self.fillChart = [[DTFillChart alloc] initWithOrigin:CGPointMake(30, 260) xAxis:75 yAxis:41];
    self.fillChart.xAxisLabelDatas = self.xAxisLabelDatas;
    self.fillChart.yAxisLabelDatas = yAxisLabelDatas;
    self.fillChart.multiData = multiData;
    self.fillChart.showCoordinateAxisGrid = YES;
    self.fillChart.xAxisLabelColor = self.fillChart.yAxisLabelColor = [UIColor whiteColor];
//    self.fillChart.beginRangeIndex = 25;
//    self.fillChart.endRangeIndex = 30;

//    self.fillChart.contentView.backgroundColor = DTRGBColor(0xe8e8e8, 1);
    [self.view addSubview:self.fillChart];
//    self.lineChart = lineChart;
//    barChart.showCoordinateAxisLine  = NO;
//    barChart.showCoordinateAxis = NO;
//    lineChart.showAnimation = NO;
//    self.fillChart.showCoordinateAxisGrid = YES;
//    lineChart.barSelectable = NO;


//    [self.fillChart setLineChartTouchBlock:^(NSUInteger lineIndex, NSUInteger pointIndex, BOOL isMainAxis) {
//        DTLog(@"line touch index = %@, %@, %@", @(lineIndex), @(pointIndex), isMainAxis ? @"Main axis" : @"Second axis");
//    }];

    [self.fillChart drawChart];

}

- (DTChartSingleData *)simulateData:(NSUInteger)count prev:(DTChartSingleData *)prevData {
    NSMutableArray<DTChartItemData *> *values = [NSMutableArray array];
    for (NSUInteger i = 1; i <= count; ++i) {
        DTChartItemData *data = [DTChartItemData chartData];

        if (prevData) {
            DTChartItemData *prevItemData = prevData.itemValues[i - 1];
            data.itemValue = ChartItemValueMake(i, prevItemData.itemValue.y + MAX(2, arc4random_uniform(20)));
//            data.itemValue = ChartItemValueMake(i, prevItemData.itemValue.y + 10);
        } else {
            data.itemValue = ChartItemValueMake(i, 30 + arc4random_uniform(60));
//            data.itemValue = ChartItemValueMake(i, 30 + 10);
        }

        [values addObject:data];
    }
    DTChartSingleData *singleData = [DTChartSingleData singleData:values];

    return singleData;
}


#pragma mark - Chart Controller

- (void)loadChartController {
    DTFillChartController *fillChartController = [[DTFillChartController alloc] initWithOrigin:CGPointMake(8 * 15, 6 * 15) xAxis:75 yAxis:41];
    fillChartController.chartMode = DTChartModePresentation;
    fillChartController.valueSelectable = YES;

    [self.view addSubview:fillChartController.chartView];
    self.fillChartController = fillChartController;
    [self.fillChartController setFillChartTouchBlock:^NSString *(NSUInteger lineIndex, NSUInteger pointIndex) {
        return [NSString stringWithFormat:@"一周最佳是第%@天  那天最佳第%@名", @(lineIndex), @(pointIndex)];
    }];

    self.listLineData = [self simulateListCommonData:30 pointCount:28 mainAxis:YES].reverseObjectEnumerator.allObjects.mutableCopy;

    DTAxisFormatter *formatter = [DTAxisFormatter axisFormatter];
    formatter.mainYAxisType = DTAxisFormatterTypeNumber;
    formatter.secondYAxisType = DTAxisFormatterTypeNumber;
    formatter.xAxisType = DTAxisFormatterTypeDate;
    formatter.xAxisDateSubType = DTAxisFormatterDateSubTypeMonth | DTAxisFormatterDateSubTypeDay;
    [fillChartController setItems:@"20000x" listData:self.listLineData axisFormat:formatter];
//    fillChartController.beginRangeIndex = 25;
//    fillChartController.endRangeIndex = 30;
}

- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count baseValue:(CGFloat)baseValue prev:(NSMutableArray<DTCommonData *> *)prevArray {
    NSMutableArray<DTCommonData *> *list = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSString *title = [NSString stringWithFormat:@"2016-12-%@~2016-12-%@", [self dayString:i + 1], [self dayString:i + 2]];

        if (prevArray) {
            DTCommonData *prevData = prevArray[i];
            DTCommonData *data = [DTCommonData commonData:title value:prevData.ptValue + arc4random_uniform(100) * 2];
            [list addObject:data];
        } else {
            DTCommonData *data = [DTCommonData commonData:title value:baseValue + arc4random_uniform(160) * 10];
            [list addObject:data];
        }


    }

    return list;
}

- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count prev:(NSMutableArray<DTCommonData *> *)prevArray {
    return [self simulateCommonData:count baseValue:300 prev:prevArray];
}


- (NSString *)dayString:(NSUInteger)value {
    if (value >= 10) {
        return [NSString stringWithFormat:@"%@", @(value)];
    } else {
        return [NSString stringWithFormat:@"0%@", @(value)];
    }

}


- (NSMutableArray<DTListCommonData *> *)simulateListCommonData:(NSUInteger)lineCount pointCount:(NSUInteger)pCount mainAxis:(BOOL)isMain {
    NSMutableArray<DTListCommonData *> *list = [NSMutableArray arrayWithCapacity:lineCount];

    NSMutableArray<DTCommonData *> *prevArrayCommonData = nil;

    for (NSUInteger i = 0; i < lineCount; ++i) {

        NSString *seriesId = [NSString stringWithFormat:@"%@", @(arc4random_uniform(20) * arc4random_uniform(20))];
        NSString *seriesName = [NSString stringWithFormat:@"No.20%@", @(i)];

        NSMutableArray<DTCommonData *> *arrayCommonData = [self simulateCommonData:pCount prev:prevArrayCommonData];

        DTListCommonData *listCommonData = [DTListCommonData listCommonData:seriesId seriesName:seriesName arrayData:arrayCommonData mainAxis:isMain];

        prevArrayCommonData = arrayCommonData;

        [list addObject:listCommonData];
    }

    return list;
}


@end
