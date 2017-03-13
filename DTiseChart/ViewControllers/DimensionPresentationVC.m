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
#import "DTDimensionBurgerBarChart.h"
#import "DTDimensionBurgerBarChartController.h"
#include <objc/runtime.h>


@interface DimensionPresentationVC ()

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic) DTDimensionVerticalBarChartController *vChartController;
@property(nonatomic) DTDimensionHorizontalBarChartController *hChartController;

@property(nonatomic) DTDimensionBurgerBarChart *burgerBarChart;

@property(nonatomic) DTDimensionModel *model1;
@property(nonatomic) DTDimensionModel *model2;

@end

@implementation DimensionPresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DTRGBColor(0x2f2f2f, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.contentSize = CGSizeMake(0, 2000);

    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 60, 48)];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeBtn setTitle:@"改模式" forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:changeBtn];

    // Do any additional setup after loading the view.

    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data3" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    self.model1 = [self dataFromJson:json];
    DTDimensionModel *model1 = [self dataFromJson:json];
    


    // *********************
    NSMutableArray *array = @[].mutableCopy;
    [self divideDimensionModel:model1 array:array];

    for (NSUInteger i = 0; i < array.count; ++i) {
        DTDimensionModel *model = array[i];

        DTDimensionModel *tModel = model;
        while (tModel.ptListValue.firstObject != nil) {
            tModel = tModel.ptListValue.firstObject;
        }
        
        if(model.ptName.length > 0){
            model.ptValue = tModel.ptValue;
        }else{
            model.ptListValue.firstObject.ptValue = tModel.ptValue;
        }
        
        tModel.ptValue = 0;

        DTDimensionModel *reverseModel = [self reverseDimensionModel:model];
        array[i] = reverseModel;

    }

    DTDimensionModel * mergedModel = [self mergeArrayToDimensionModel:array];

    // *********************

//    [self horizontalChart];


    [self burgerBarChartController:mergedModel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self chartController];
    [self horizontalChartController];
}


- (DTDimensionModel *)mergeArrayToDimensionModel:(NSArray *)array {


    NSMutableArray<NSString *> *names = [NSMutableArray array];

    for (DTDimensionModel *model in array) {

        BOOL exist = NO;
        for (NSString *name in names) {
            if ([name isEqualToString:model.ptName]) {
                exist = YES;
                break;
            }
        }

        if (!exist && model.ptName) {
            [names addObject:model.ptName];
        }
    }

    DTDimensionModel *pModel = [[DTDimensionModel alloc] init];
    
    
    for (NSString *name in names) {
        NSMutableArray<DTDimensionModel *> *sameNameArray = [NSMutableArray array];

        for (DTDimensionModel *model in array) {
            if ([name isEqualToString:model.ptName]) {
                [sameNameArray addObject:model];
            }
        }

        if (sameNameArray.count > 0) {
            DTDimensionModel *firstModel = sameNameArray.firstObject;
            DTDimensionModel *cModel = [[DTDimensionModel alloc] init];
            cModel.ptName = firstModel.ptName;
            cModel.ptValue = firstModel.ptValue;
            
            NSMutableArray *ptListValue = [NSMutableArray arrayWithArray:pModel.ptListValue];
            [ptListValue addObject:cModel];
            pModel.ptListValue = ptListValue.copy;
            
            NSMutableArray *subArray = [NSMutableArray array];
            for (DTDimensionModel *model in sameNameArray) {
                if(model.ptListValue.count > 0){
                    [subArray addObject:model.ptListValue.firstObject];
                }
                
            }

            if (subArray.count > 0) {
                DTDimensionModel *tempModel = [self mergeArrayToDimensionModel:subArray];
                
                cModel.ptListValue = tempModel.ptListValue;
                
                DTLog(@"cModel = %@", cModel.ptName);
            }else{
                cModel.ptListValue = @[sameNameArray.firstObject];
            }
        }
    }




    return pModel;
}


- (void)divideDimensionModel:(DTDimensionModel *)model array:(NSMutableArray *)array {

    if (model.ptListValue.count > 0) {
        for (DTDimensionModel *item in model.ptListValue) {
            [self divideDimensionModel:item array:array];

            DTLog(@"array name = %@", model.ptName);


            DTDimensionModel *tModel = nil;
            NSArray *tempArray = array.copy;
            for (DTDimensionModel *m in tempArray) {
                if ([m.objectId isEqualToString:item.objectId]) {
                    tModel = m;


                    NSUInteger index = [array indexOfObject:tModel];
                    [array removeObject:tModel];


                    DTDimensionModel *cModel = [[DTDimensionModel alloc] init];
                    cModel.ptValue = model.ptValue;
                    cModel.ptName = model.ptName;
                    cModel.objectId = model.objectId;
                    cModel.ptListValue = @[tModel];

                    [array insertObject:cModel atIndex:index];

                }
            }


        }
    } else {
        [array addObject:model];
    }

}

- (DTDimensionModel *)reverseDimensionModel:(DTDimensionModel *)model {
    if (model.ptListValue.count > 0) {
        DTDimensionModel *rModel = [self reverseDimensionModel:model.ptListValue.firstObject];


        DTDimensionModel *tModel = rModel;
        while (tModel.ptListValue.firstObject != nil) {
            tModel = tModel.ptListValue.firstObject;
        }

        
        DTDimensionModel *cModel = [[DTDimensionModel alloc] init];
        cModel.ptValue = model.ptValue;
        cModel.ptName = model.ptName;
        cModel.objectId = model.objectId;

        tModel.ptListValue = @[cModel];

        return rModel;

    } else {
        return model;
    }


}


- (void)chartController {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data2" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    DTDimensionModel *model = [self dataFromJson:json];

    self.model1 = model;
    DTDimensionVerticalBarChartController *chartController = [[DTDimensionVerticalBarChartController alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 60) xAxis:55 yAxis:31];
    chartController.barChartStyle = DTBarChartStyleHeap;
    chartController.valueSelectable = YES;
    chartController.chartId = @"chart9527";
    chartController.axisBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    chartController.showCoordinateAxisGrid = YES;
    [chartController setItem:self.model1];
    [chartController setDimensionBarChartControllerTouchBlock:^NSString *(NSUInteger touchIndex) {

        return nil;
    }];

    self.vChartController = chartController;

    [self.scrollView addSubview:chartController.chartView];

    [chartController drawChart];
}

- (void)horizontalChartController {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data2" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    self.model2 = [self dataFromJson:json];
    DTDimensionModel *model = self.model2;
//    DTDimensionModel *item = model.ptListValue.firstObject;
//    NSMutableArray *array = [NSMutableArray array];
//    for(NSUInteger i = 0; i < 300; ++i){
//        [array addObject:item];
//    }
//    model.ptListValue = array;

    DTDimensionHorizontalBarChartController *chartController = [[DTDimensionHorizontalBarChartController alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 262 + 15 * 7 + 190) xAxis:55 yAxis:31];
    chartController.barChartStyle = DTBarChartStyleHeap;
    chartController.valueSelectable = YES;
    chartController.chartId = @"chart9528";
    chartController.axisBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    chartController.showCoordinateAxisGrid = YES;
    [chartController setItem:model];

    self.hChartController = chartController;

    [self.scrollView addSubview:chartController.chartView];

    [chartController drawChart];
}

- (void)burgerBarChartController:(DTDimensionModel *)model {
    DTDimensionBurgerBarChartController *burgerController = [[DTDimensionBurgerBarChartController alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 262 + 15 * (7 + 33) + 190) xAxis:55 yAxis:31];
    burgerController.showCoordinateAxisGrid = YES;
    burgerController.valueSelectable = YES;
    [self.scrollView addSubview:burgerController.chartView];

//    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
//    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
//    NSString *path = [bundle pathForResource:@"data2" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSError *error = nil;
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    [burgerController setItem:model];

    [burgerController drawChart];
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
    [self.scrollView addSubview:barChart];
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
    [self.scrollView addSubview:barChart];
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


- (void)showBurgerBarChart {
    NSMutableArray<DTAxisLabelData *> *yLabelDatas = [NSMutableArray arrayWithCapacity:11];
    for (NSUInteger i = 0; i < 11; i++) {
        DTAxisLabelData *labelData = [[DTAxisLabelData alloc] initWithTitle:[NSString stringWithFormat:@"%@%%", @(i * 10)] value:i * 0.1f];
        [yLabelDatas addObject:labelData];
    }


    self.burgerBarChart = [[DTDimensionBurgerBarChart alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 262 + 15 * (7 + 33) + 190) xAxis:55 yAxis:31];
    self.burgerBarChart.barWidth = 2;
    self.burgerBarChart.yAxisLabelDatas = yLabelDatas;
    self.burgerBarChart.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.burgerBarChart.showCoordinateAxisGrid = YES;
    self.burgerBarChart.showAnimation = YES;
    self.burgerBarChart.valueSelectable = YES;
    [self.scrollView addSubview:self.burgerBarChart];


    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"data2" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    DTDimensionModel *model = [self dataFromJson:json];

    self.burgerBarChart.dimensionModel = model;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.burgerBarChart drawChart];
    });

}

- (void)change:(UIButton *)sender {
//    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
//    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
//    NSString *path = [bundle pathForResource:@"data2" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSError *error = nil;
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//
//    [self.hChartController setItem:[self dataFromJson:json]];

    if (self.hChartController.barChartStyle == DTBarChartStyleHeap) {
        self.hChartController.barChartStyle = DTBarChartStyleStartingLine;
    } else if (self.hChartController.barChartStyle == DTBarChartStyleStartingLine) {
        self.hChartController.barChartStyle = DTBarChartStyleHeap;
    }

    [self.hChartController drawChart];


    if (self.vChartController.barChartStyle == DTBarChartStyleHeap) {
        self.vChartController.barChartStyle = DTBarChartStyleStartingLine;
    } else if (self.vChartController.barChartStyle == DTBarChartStyleStartingLine) {
        self.vChartController.barChartStyle = DTBarChartStyleHeap;
    }
    [self.vChartController setItem:self.model2];
    [self.vChartController drawChart];
}

@end
