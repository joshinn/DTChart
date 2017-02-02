//
//  TableChartPresentationViewController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/14.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "TableChartPresentationViewController.h"
#import "DTCommonData.h"
#import "DTTableChartController.h"

@interface TableChartPresentationViewController ()

@property(nonatomic) DTTableChartController *tableChartController;

@property(nonatomic) NSMutableArray<NSString *> *chartTitles;

@end

@implementation TableChartPresentationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = DTRGBColor(0x303030, 1);

    self.chartTitles = [NSMutableArray array];
    [self.chartTitles addObject:@"来源"];
    [self.chartTitles addObject:@"来源明细"];
    [self.chartTitles addObject:@"来访次数"];
    [self.chartTitles addObject:@"新来访占比"];
    [self.chartTitles addObject:@"跳出率"];
    [self.chartTitles addObject:@"平均访问深度"];
    [self.chartTitles addObject:@"平均访问时长"];
    
    self.tableChartController = [[DTTableChartController alloc] initWithOrigin:CGPointMake(8 * 15, 6 * 15) xAxis:75 yAxis:41];
    [self.view addSubview:self.tableChartController.chartView];
    
    self.listLineData = [self simulateListCommonData:20 pointCount:self.chartTitles.count mainAxis:YES];
    [self.listLineData addObjectsFromArray:[self simulateListCommonData:20 pointCount:self.chartTitles.count mainAxis:NO]];

    DTAxisFormatter *formatter = [DTAxisFormatter axisFormatter];
    [self.tableChartController setItems:self.chartId listData:self.listLineData axisFormat:formatter];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.tableChartController drawChart];
}


- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count row:(NSUInteger)row{
    NSMutableArray<DTCommonData *> *list = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSString *title = self.chartTitles[i];
        DTCommonData *data = [DTCommonData commonData:title stringValue:[NSString stringWithFormat:@"%@", @(row)]];
        [list addObject:data];
    }
    
    return list;
}


- (NSString *)dayString:(NSUInteger)value {
    if (value >= 10) {
        return [NSString stringWithFormat:@"%@", @(value)];
    } else {
        return [NSString stringWithFormat:@"0%@", @(value)];
    }
    
}


- (NSMutableArray<DTListCommonData *> *)simulateListCommonData:(NSUInteger)rowCount pointCount:(NSUInteger)pCount mainAxis:(BOOL)isMain {
    NSMutableArray<DTListCommonData *> *list = [NSMutableArray arrayWithCapacity:rowCount];
    for (NSUInteger i = 0; i < rowCount; ++i) {
        
        NSString *seriesId = [NSString stringWithFormat:@"%@", @(arc4random_uniform(20) * arc4random_uniform(20))];
        NSString *seriesName = [NSString stringWithFormat:@"No.20%@", @(i)];
        DTListCommonData *listCommonData = [DTListCommonData listCommonData:seriesId seriesName:seriesName arrayData:[self simulateCommonData:pCount row:i] mainAxis:isMain];
        
        [list addObject:listCommonData];
    }
    
    return list;
}

@end
