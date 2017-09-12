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

@property(nonatomic) NSArray<NSString *> *listTitles;

@property(nonatomic) DTPieChartController *pieChartController;

@property(nonatomic) DTPieChartController *pPieCC;

@end

@implementation PiePresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DTRGBColor(0x303030, 1);

    self.listTitles = @[@"自然搜索", @"百度搜索", @"谷歌搜索", @"必应搜索", @"蛤蛤蛤蛤", @"续一秒", @"苟利国家生死以", @"岂因祸福避趋之", @"图样", @"图森破"];
    self.listBarData = [self simulateListCommonData:1 pointCount:6 mainAxis:YES];

    WEAK_SELF;

    self.pieChartController = [[DTPieChartController alloc] initWithOrigin:CGPointMake(15 * 8, 6 * 15) xAxis:23 yAxis:11];
    self.pieChartController.valueSelectable = YES;
    [self.pieChartController setMainAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
        [infos enumerateObjectsUsingBlock:^(DTChartBlockModel *obj, NSUInteger idx, BOOL *stop) {
            DTLog(@"main axis color = %@ \nseriesId = %@", obj.color, obj.seriesId);
        }];
    }];
    [self.pieChartController setPieChartTouchBlock:^(NSString *partName, NSInteger partIndex) {
        DTLog(@"pie chart series name = %@ index = %@", partName, @(partIndex));

    }];

    [self.pieChartController setMainChartItemsColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
        DTLog(@"pie chart main chart items color = %@", infos);
    }];
    [self.pieChartController setSecondChartItemsColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
        DTLog(@"pie chart second chart items color = %@", infos);
    }];

    [self.view addSubview:self.pieChartController.chartView];

    [self.pieChartController setItems:self.chartId listData:self.listBarData axisFormat:nil];


    self.pPieCC = [[DTPieChartController alloc] initWithOrigin:CGPointMake(8 * 15, 20 * 15) xAxis:71 yAxis:37];
    self.pPieCC.chartMode = DTChartModePresentation;
    self.pPieCC.valueSelectable = YES;
    self.pPieCC.chartView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];

    [self.pPieCC setMainAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
        [infos enumerateObjectsUsingBlock:^(DTChartBlockModel *obj, NSUInteger idx, BOOL *stop) {
            DTLog(@"main axis color = %@ \nseriesId = %@", obj.color, obj.seriesId);
        }];
    }];
    [self.pPieCC setPieChartTouchBlock:^(NSString *partName, NSInteger partIndex) {
        DTLog(@"pie chart series name = %@ index = %@", partName, @(partIndex));
        [weakSelf drawSubChart];
    }];
    [self.pPieCC setMainChartItemsColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
        DTLog(@"pie chart main chart items color = %@", infos);
    }];


    [self.view addSubview:self.pPieCC.chartView];

    [self.pPieCC setItems:self.chartId listData:self.listBarData axisFormat:nil];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.pieChartController drawChart];
    [self.pPieCC drawChart];
}


- (void)drawSubChart {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pPieCC setSecondChartItems:[self simulateListCommonData:1 pointCount:6 mainAxis:NO]];
        [self.pPieCC drawSecondChart];
    });
}

- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count baseValue:(CGFloat)baseValue {
    NSMutableArray<DTCommonData *> *list = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSString *title = self.listTitles[i];
        DTCommonData *data = [DTCommonData commonData:title value:baseValue + arc4random_uniform(160) * 10];
        [list addObject:data];
    }

    return list;
}

- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count {
    return [self simulateCommonData:count baseValue:300];
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
    for (NSUInteger i = 0; i < lineCount; ++i) {

        NSString *seriesId = [NSString stringWithFormat:@"%@", @(arc4random_uniform(20) * arc4random_uniform(20))];
        NSString *seriesName = [NSString stringWithFormat:@"No.20%@", @(i)];
        DTListCommonData *listCommonData = [DTListCommonData listCommonData:seriesId seriesName:seriesName arrayData:[self simulateCommonData:pCount] mainAxis:isMain];

        [list addObject:listCommonData];
    }

    return list;
}

@end
