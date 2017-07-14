//
//  Dimension2PresentationVC.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "Dimension2PresentationVC.h"
#import "DTDimensionBarChart.h"
#import "DTDimensionBarChartController.h"
#import "DTDimensionModel.h"
#import "DTDimensionBarModel.h"

@interface Dimension2PresentationVC () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) DTDimensionBarChartController *chartController;

@property(nonatomic) DTDimension2ListModel *p1MainData;
@property(nonatomic) DTDimension2ListModel *p1SecondData;

@property(nonatomic) DTDimension2ListModel *p2MainData;
@property(nonatomic) DTDimension2ListModel *p2SecondData;

@property(nonatomic) UITableView *tableView;

@property(nonatomic) NSArray<DTDimensionBarModel *> *listBarInfos;

@end

@implementation Dimension2PresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DTRGBColor(0x2f2f2f, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.tableView];

    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 80, 60, 48)];
    [changeBtn setTitle:@"模式" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeChartMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];

    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 160, 60, 48)];
    [testBtn setTitle:@"test" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];

//    [self loadChart];
    [self loadChartController];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 300, 200, 450)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 15;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)changeChartMode {
    if (self.chartController.chartStyle == DTDimensionBarStyleStartLine) {
        self.chartController.chartStyle = DTDimensionBarStyleHeap;
        self.chartController.chartId = @"0906";
        [self.chartController setMainData:self.p2MainData secondData:self.p2SecondData];
        [self.chartController drawChart];

    } else if (self.chartController.chartStyle == DTDimensionBarStyleHeap) {
        self.chartController.chartStyle = DTDimensionBarStyleStartLine;
        self.chartController.chartId = @"0905";
        [self.chartController setMainData:self.p1MainData secondData:self.p1SecondData];
        [self.chartController drawChart];
    }
}


- (void)loadChartController {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
        NSString *path = [bundle pathForResource:@"d3" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSArray *array = json[@"data"];
        NSMutableArray *list = [NSMutableArray array];
        for (NSUInteger i = 0; i < 1; ++i) {
            [list addObjectsFromArray:array];
        }
        NSInteger measureNum = [json[@"measureNum"] integerValue];
        CGFloat p1Max1Value = 0;
        CGFloat p1Min1Value = 0;
        CGFloat p1Max2Value = 0;
        CGFloat p1Min2Value = 0;

        CGFloat p2Max1Value = 0;
        CGFloat p2Min1Value = 0;
        CGFloat p2Max2Value = 0;
        CGFloat p2Min2Value = 0;

        NSMutableArray<DTDimension2Model *> *listMainPt = [NSMutableArray arrayWithCapacity:list.count];
        NSMutableArray<DTDimension2Model *> *listSecondPt = [NSMutableArray arrayWithCapacity:list.count];

        NSMutableArray<DTDimension2Model *> *listMainP2 = [NSMutableArray array];
        NSMutableArray<DTDimension2Model *> *listSecondP2 = [NSMutableArray array];

        for (NSDictionary *dictionary in list) {
            DTDimension2Model *p1Model = [[DTDimension2Model alloc] initStartLineWithDictionary:dictionary measureIndex:1];
            [listMainPt addObject:p1Model];
            if (p1Max1Value < p1Model.itemsMaxValue) {
                p1Max1Value = p1Model.itemsMaxValue;
            }
            if (p1Min1Value > p1Model.itemsMinValue) {
                p1Min1Value = p1Model.itemsMinValue;
            }

            DTDimension2Model *p2Model = [[DTDimension2Model alloc] initHeapWithDictionary:dictionary measureIndex:1 prevModel:listMainP2.lastObject];
            if (listMainP2.lastObject != p2Model) {
                [listMainP2 addObject:p2Model];
            }

            if (p2Max1Value < listMainP2.lastObject.itemsMaxValue) {
                p2Max1Value = listMainP2.lastObject.itemsMaxValue;
            }
            if (p2Min1Value > listMainP2.lastObject.itemsMinValue) {
                p2Min1Value = listMainP2.lastObject.itemsMinValue;
            }
        }
        if (measureNum == 2) {
            for (NSDictionary *dictionary in list) {
                [listSecondPt addObject:[[DTDimension2Model alloc] initStartLineWithDictionary:dictionary measureIndex:2]];
                if (p1Max2Value < listSecondPt.lastObject.itemsMaxValue) {
                    p1Max2Value = listSecondPt.lastObject.itemsMaxValue;
                }
                if (p1Min2Value > listSecondPt.lastObject.itemsMinValue) {
                    p1Min2Value = listSecondPt.lastObject.itemsMinValue;
                }


                DTDimension2Model *p2Model = [[DTDimension2Model alloc] initHeapWithDictionary:dictionary measureIndex:2 prevModel:listSecondP2.lastObject];
                if (listSecondP2.lastObject != p2Model) {
                    [listSecondP2 addObject:p2Model];
                }

                if (p2Max2Value < listSecondP2.lastObject.itemsMaxValue) {
                    p2Max2Value = listSecondP2.lastObject.itemsMaxValue;
                }
                if (p2Min2Value > listSecondP2.lastObject.itemsMinValue) {
                    p2Min2Value = listSecondP2.lastObject.itemsMinValue;
                }
            }
        }

        DTDimension2ListModel *listMainModel = [[DTDimension2ListModel alloc] init];
        listMainModel.title = @"价格%税收";
        listMainModel.listDimensions = listMainPt;
        listMainModel.maxValue = p1Max1Value;
        listMainModel.minValue = p1Min1Value;
        self.p1MainData = listMainModel;

        DTDimension2ListModel *listSecondModel = [[DTDimension2ListModel alloc] init];
        listSecondModel.title = @"气温X雨水量";
        listSecondModel.listDimensions = listSecondPt;
        listSecondModel.maxValue = p1Max2Value;
        listSecondModel.minValue = p1Min2Value;
        self.p1SecondData = listSecondModel;


        DTDimension2ListModel *p2listMainModel = [[DTDimension2ListModel alloc] init];
        p2listMainModel.title = @"价格%税收";
        p2listMainModel.listDimensions = listMainP2;
        p2listMainModel.maxValue = p2Max1Value;
        p2listMainModel.minValue = p2Min1Value;
        self.p2MainData = p2listMainModel;

        DTDimension2ListModel *p2listSecondModel = [[DTDimension2ListModel alloc] init];
        p2listSecondModel.title = @"气温X雨水量";
        p2listSecondModel.listDimensions = listSecondP2;
        p2listSecondModel.maxValue = p2Max2Value;
        p2listSecondModel.minValue = p2Min2Value;
        self.p2SecondData = p2listSecondModel;

        DTDimensionBarChartController *chartController = [[DTDimensionBarChartController alloc] initWithOrigin:CGPointMake(120 + 15 * 17, 262 + 15 * 7) xAxis:55 yAxis:31];
        chartController.chartId = @"0905";
        chartController.chartStyle = DTDimensionBarStyleStartLine;
        chartController.showCoordinateAxisGrid = YES;
        chartController.valueSelectable = YES;
        chartController.preProcessBarInfo = YES;
        [chartController setMainData:listMainModel secondData:listSecondModel];
        self.chartController = chartController;


        dispatch_async(dispatch_get_main_queue(), ^{

            [chartController setControllerTouchBarBlock:^NSString *(DTDimensionBarStyle chartStyle, NSUInteger row, DTDimension2Item *touchData, NSArray<DTDimension2Item *> *allSubData, id dimensionData, id measureData, BOOL isMainAxis) {
                NSMutableString *message = [NSMutableString string];

                if (touchData) {

                    NSString *format = [NSString stringWithFormat:@"%%.%@f", @(3)];
                    NSString *valueString = [NSString stringWithFormat:format, touchData.value];
                    CGFloat sum = 0;
                    for (DTDimension2Item *item in allSubData) {
                        sum += item.value;
                    }
                    NSString *sumString = [NSString stringWithFormat:format, sum];


                    if (chartStyle == DTBarChartStyleHeap) {
                        if (dimensionData) {
//                        [message appendString:dimensionData.name];
                            [message appendString:@" : "];
                            [message appendString:touchData.name];
                            [message appendString:@"\n"];
                        }
                        if (measureData) {
//                        [message appendString:measureData.name];
                            [message appendString:@" : "];
                        }
                        [message appendString:valueString];
                        [message appendString:@"\n"];
                        [message appendString:@"总计"];
                        [message appendString:@" : "];
                        [message appendString:sumString];
                    } else {
                        if (dimensionData) {
//                        [message appendString:dimensionData.name];
                            [message appendString:@" : "];
                            [message appendString:touchData.name];
                            [message appendString:@"\n"];
                        }
                        if (measureData) {
//                        [message appendString:measureData.name];
                            [message appendString:@" : "];
                        }
                        [message appendString:valueString];
                    }
                }

                return message;
            }];

            WEAK_SELF;
            [chartController setControllerBarInfoBlock:^(NSArray<DTDimensionBarModel *> *listBarInfos, id dimensionData) {
                weakSelf.listBarInfos = listBarInfos;
                [weakSelf.tableView reloadData];
            }];

            [self.view addSubview:chartController.chartView];
            [chartController drawChart];

        });
    });
}


- (void)test {
    NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:resourcesPath];
    NSString *path = [bundle pathForResource:@"d3" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *array = json[@"data"];

    DTDimensionModel *dimensionModel = [DTDimensionModel new];
    for (NSDictionary *dictionary in array) {

        CGFloat value1 = [dictionary[@"value1"] doubleValue];
        NSArray<NSString *> *names = dictionary[@"names"];
        if (names.count > 1) {
            names = names.reverseObjectEnumerator.allObjects;
        }
        DTDimensionModel *existModel = dimensionModel;
        for (NSString *name in names) {
            BOOL exist = NO;
            for (DTDimensionModel *model in existModel.ptListValue) {
                if ([model.ptName isEqualToString:name]) {
                    existModel = model;
                    exist = YES;
                    break;
                }
            }

            if (exist) {
                existModel.ptValue += value1;
            } else {
                DTDimensionModel *newModel = [DTDimensionModel new];
                newModel.ptName = name;
                newModel.ptValue = value1;
                NSMutableArray *ptListValue = [NSMutableArray arrayWithArray:existModel.ptListValue];
                [ptListValue addObject:newModel];
                existModel.ptListValue = ptListValue.copy;
                existModel = newModel;
            }
        }

    }

}

- (void)processDimensionModel:(NSArray<NSString *> *)array {

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listBarInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableViewCell.textLabel.font = [UIFont systemFontOfSize:8];
        tableViewCell.textLabel.textColor = [UIColor whiteColor];
    }

    DTDimensionBarModel *barModel = self.listBarInfos[(NSUInteger) indexPath.row];

    tableViewCell.textLabel.text = barModel.title;
    tableViewCell.backgroundColor = barModel.color;

    return tableViewCell;
}


@end
