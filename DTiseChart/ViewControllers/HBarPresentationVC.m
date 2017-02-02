//
//  HBarPresentationVC.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "HBarPresentationVC.h"
#import "DTCommonData.h"
#import "DTHorizontalBarChartController.h"

@interface HBarPresentationVC ()

@property (nonatomic) DTHorizontalBarChartController *tBarChartController;
@property (nonatomic) DTHorizontalBarChartController *pBarChartController;

@end

@implementation HBarPresentationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DTRGBColor(0x303030, 1);
    

        self.tBarChartController = [[DTHorizontalBarChartController alloc] initWithOrigin:CGPointMake(15 * 8, 6 * 15) xAxis:23 yAxis:11];
        self.tBarChartController.chartMode = DTChartModeThumb;
    
    //    self.barChartController.barWidth = 2;

    [self.tBarChartController setMainAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
        //        [infos enumerateObjectsUsingBlock:^(DTChartBlockModel *obj, NSUInteger idx, BOOL *stop) {
        //            DTLog(@"main axis color = %@ \nseriesId = %@ type = %@", obj.color, obj.seriesId, @(obj.type));
        //        }];
    }];
    [self.tBarChartController setSecondAxisColorsCompletionBlock:^(NSArray<DTChartBlockModel *> *infos) {
//                [infos enumerateObjectsUsingBlock:^(DTChartBlockModel *obj, NSUInteger idx, BOOL *stop) {
//                    DTLog(@"main axis color = %@ \nseriesId = %@ type = %@", obj.color, obj.seriesId, @(obj.type));
//                }];
    }];
    [self.view addSubview:self.tBarChartController.chartView];
    
    DTAxisFormatter *formatter = [DTAxisFormatter axisFormatter];
    formatter.mainYAxisType = DTAxisFormatterTypeText;
    formatter.xAxisType = DTAxisFormatterTypeNumber;
    [self.tBarChartController setItems:self.chartId listData:[self simulateListCommonData:1 pointCount:5 mainAxis:YES] axisFormat:formatter];

    self.pBarChartController = [[DTHorizontalBarChartController alloc] initWithOrigin:CGPointMake(8 * 15, 20 * 15) xAxis:75 yAxis:41];
    self.pBarChartController.chartMode = DTChartModePresentation;
    
    [self.view addSubview:self.pBarChartController.chartView];
    [self.pBarChartController setItems:self.chartId listData:[self simulateListCommonData:1 pointCount:10 mainAxis:YES] axisFormat:formatter];


//    [self.view addSubview:[self buttonFactory:@"加" frame:CGRectMake(0, CGRectGetMinY(self.tBarChartController.chartView.frame), 60, 48) action:@selector(add)]];
//    [self.view addSubview:[self buttonFactory:@"减" frame:CGRectMake(0, CGRectGetMinY(self.tBarChartController.chartView.frame) + 60, 60, 48) action:@selector(minus)]];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tBarChartController drawChart];
    [self.pBarChartController drawChart];
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
}

- (void)minus {
}


- (NSMutableArray<DTCommonData *> *)simulateCommonData:(NSUInteger)count baseValue:(CGFloat)baseValue {
    NSMutableArray<DTCommonData *> *list = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSString *title = [NSString stringWithFormat:@"www.google/from/%@", [self dayString:i + 1]];
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
