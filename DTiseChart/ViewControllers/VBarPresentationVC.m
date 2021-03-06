#import "DTChartBlockModel.h"//
//  VBarPresentationVC.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/16.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "VBarPresentationVC.h"
#import "DTVerticalBarChartController.h"

@interface VBarPresentationVC ()

@property(nonatomic) DTVerticalBarChartController *barChartController;

@end

@implementation VBarPresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = DTRGBColor(0x303030, 1);


    self.barChartController = [[DTVerticalBarChartController alloc] initWithOrigin:CGPointMake(8 * 15, 6 * 15) xAxis:71 yAxis:37];
//    self.barChartController.preferMainYAxisDataCount = 5;
    self.barChartController.chartMode = DTChartModePresentation;
//    self.barChartController = [[DTVerticalBarChartController alloc] initWithOrigin:CGPointMake(15 * 8, 6 * 15) xAxis:23 yAxis:11];
//    self.barChartController.chartMode = DTChartModeThumb;
    self.barChartController.valueSelectable = YES;
    self.barChartController.axisBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    self.barChartController.chartView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    self.barChartController.mainYAxisMaxValueLimit = 1;

    [self.barChartController setMainAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
//        [infos enumerateObjectsUsingBlock:^(DTChartBlockModel *obj, NSUInteger idx, BOOL *stop) {
//            DTLog(@"main axis color = %@ \nseriesId = %@ type = %@", obj.color, obj.seriesId, @(obj.type));
//        }];
    }];
    [self.barChartController setSecondAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
//        [infos enumerateObjectsUsingBlock:^(DTChartBlockModel *obj, NSUInteger idx, BOOL *stop) {
//            DTLog(@"main axis color = %@ \nseriesId = %@ type = %@", obj.color, obj.seriesId, @(obj.type));
//        }];
    }];
    WEAK_SELF;
    [self.barChartController setBarChartControllerTouchBlock:^NSString *(NSUInteger dataIndex, NSUInteger barIndex) {
        NSMutableString *mutableString = [NSMutableString string];
        DTCommonData *commonData = weakSelf.listBarData[dataIndex].commonDatas[barIndex];
        [mutableString appendString:commonData.ptName];
        [mutableString appendString:[NSString stringWithFormat:@"data:%@ bar:%@ -> %@", @(dataIndex), @(barIndex), @(commonData.ptValue)]];
        return mutableString;
    }];

    [self.view addSubview:self.barChartController.chartView];

    self.listBarData = [self simulateListCommonData:1 pointCount:11 mainAxis:YES];

    DTAxisFormatter *formatter = [DTAxisFormatter axisFormatter];
    formatter.mainYAxisType = DTAxisFormatterTypeNumber;
    formatter.mainYAxisScale = 100;
    formatter.mainYAxisFormat = @"%.0f%%";
    formatter.secondYAxisType = DTAxisFormatterTypeNumber;
    formatter.xAxisType = DTAxisFormatterTypeDate;
    formatter.xAxisDateSubType = DTAxisFormatterDateSubTypeMonth | DTAxisFormatterDateSubTypeDay;
    [self.barChartController setItems:self.chartId listData:self.listBarData axisFormat:formatter];


    [self.view addSubview:[self buttonFactory:@"加" frame:CGRectMake(0, CGRectGetMinY(self.barChartController.chartView.frame), 60, 48) action:@selector(add)]];
    [self.view addSubview:[self buttonFactory:@"减" frame:CGRectMake(0, CGRectGetMinY(self.barChartController.chartView.frame) + 60, 60, 48) action:@selector(minus)]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.barChartController drawChart];
}


- (UIButton *)buttonFactory:(NSString *)title frame:(CGRect)frame action:(SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (void)add {
    NSArray<DTListCommonData *> *list = [self simulateListCommonData:1 pointCount:11 mainAxis:YES];
    list.lastObject.seriesName = self.listBarData.lastObject.seriesName;
    [self.barChartController addItemsListData:list withAnimation:NO];
    [self.listBarData addObjectsFromArray:list];
}

- (void)minus {

    if (self.listBarData.count == 0) {
        return;
    }

    NSMutableArray<NSString *> *sIds = [NSMutableArray array];
    [sIds addObject:self.listBarData.lastObject.seriesId];
    [self.barChartController deleteItems:sIds withAnimation:NO];

    [self.listBarData removeObjectAtIndex:self.listBarData.count - 1];
}


- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count baseValue:(CGFloat)baseValue {
    NSMutableArray<DTCommonData *> *list = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSString *title = [NSString stringWithFormat:@"2016-12-%@~2016-12-%@", [self dayString:i + 1], [self dayString:i + 2]];
//        DTCommonData *data = [DTCommonData commonData:title value:baseValue + arc4random_uniform(160) * 10];
        DTCommonData *data = [DTCommonData commonData:title value:baseValue + 1];
        [list addObject:data];
    }

    return list;
}

- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count {
    return [self simulateCommonData:count baseValue:0];
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
