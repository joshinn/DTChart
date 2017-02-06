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
#import "DTTableChartTitleOrderModel.h"

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


    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 100, 60)];
    label.text = @"这是内容";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];

    self.tableChartController = [[DTTableChartController alloc] initWithOrigin:CGPointMake(8 * 15, 6 * 15) xAxis:75 yAxis:41];
    self.tableChartController.headViewHeight = 300;
    [self.view addSubview:self.tableChartController.chartView];

    [self.tableChartController.headView addSubview:label];

    self.listLineData = [self simulateListCommonData:20 pointCount:self.chartTitles.count mainAxis:YES];
//    self.listLineData[3].seriesId = self.listLineData[2].seriesId;
//    self.listLineData[4].seriesId = self.listLineData[2].seriesId;
//    self.listLineData[10].seriesId = self.listLineData[9].seriesId;
//    self.listLineData[11].seriesId = self.listLineData[9].seriesId;
//    self.listLineData[12].seriesId = self.listLineData[9].seriesId;


//    [self.listLineData addObjectsFromArray:[self simulateListCommonData:20 pointCount:self.chartTitles.count mainAxis:NO]];
//    self.tableChartController.collapseColumn = 0;
    __weak typeof(self) weakSelf = self;
    [self.tableChartController setTableChartExpandTouchBlock:^(NSString *seriesId) {
        DTLog(@"to expand seriesId = %@", seriesId);

        [weakSelf addExpandData:seriesId];
    }];

    NSMutableArray<DTTableChartTitleOrderModel *> *orderModels = [NSMutableArray arrayWithCapacity:self.chartTitles.count];
    {
        [self.chartTitles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            DTTableChartTitleOrderModel *model = [[DTTableChartTitleOrderModel alloc] init];
            if(idx < 3){
                model.showOrder = NO;
            } else{
                model.showOrder = YES;
                model.ascending = YES;
            }
            [orderModels addObject:model];
        }];
    }
    self.tableChartController.titleOrderModels = orderModels;

    DTAxisFormatter *formatter = [DTAxisFormatter axisFormatter];
    [self.tableChartController setItems:self.chartId listData:self.listLineData axisFormat:formatter];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.tableChartController drawChart];
}


- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count row:(NSUInteger)row sId:(NSString *)sId {
    NSMutableArray<DTCommonData *> *list = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSString *title = self.chartTitles[i];
        DTCommonData *data = [DTCommonData commonData:title stringValue:[NSString stringWithFormat:@"%@~%@", sId, @(row)]];
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

        NSString *seriesId = [NSString stringWithFormat:@"id%@", @(i)];
        NSString *seriesName = [NSString stringWithFormat:@"No.20%@", @(i)];
        DTListCommonData *listCommonData = [DTListCommonData listCommonData:seriesId seriesName:seriesName arrayData:[self simulateCommonData:pCount row:i sId:seriesId] mainAxis:isMain];

        [list addObject:listCommonData];
    }

    return list;
}


- (void)addExpandData:(NSString *)seriesId {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray<DTListCommonData *> *list = [self simulateListCommonData:10 pointCount:self.chartTitles.count mainAxis:YES];
        [list enumerateObjectsUsingBlock:^(DTListCommonData *obj, NSUInteger idx, BOOL *stop) {
            obj.seriesId = seriesId;
        }];

        [self.tableChartController addExpandItems:list];
    });

}

@end
