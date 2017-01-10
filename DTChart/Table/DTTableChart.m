//
//  DTTableChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTTableChart.h"
#import "DTTableChartCell.h"


@interface DTTableChart () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) UITableView *tableView;

@property(nonatomic) NSArray *presetCellWidths;

@property(nonatomic) NSMutableArray<NSArray<DTChartItemData *> *> *listRowData;

@end

@implementation DTTableChart

static NSString *const DTTableChartCellReuseIdentifier = @"DTTableChartCellID";

/**
 * 获取表格一行所有label和间隙的宽度
 * @param chartStyle 预设表格风格
 * @return 宽度
 *
 * @attention 宽度是px，需除以2
 */
+ (NSArray *)presetTableChartCellWidth:(DTTableChartStyle)chartStyle {
    DTLog(@"presetTableChartCellWidth");
    NSArray *widths;
    switch (chartStyle) {
        case DTTableChartStyleC1C2: {
            widths = @[@{@"label": @170}, @{@"gap": @30}, @{@"label": @960}, @{@"gap": @10}, @{@"label": @960}];
        }
            break;
        case DTTableChartStyleC1C3: {
            widths = @[@{@"label": @170}, @{@"gap": @50}, @{@"label": @630}, @{@"gap": @10}, @{@"label": @630}, @{@"gap": @10}, @{@"label": @630}];
        }
            break;
        case DTTableChartStyleC1C4: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10},
                    @{@"label": @480}, @{@"gap": @10}, @{@"label": @480}, @{@"gap": @10},
                    @{@"label": @480}, @{@"gap": @10}, @{@"label": @480}];
        }
            break;
        case DTTableChartStyleC1C5: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10},
                    @{@"label": @380}, @{@"gap": @10}, @{@"label": @380}, @{@"gap": @10}, @{@"label": @380}, @{@"gap": @10},
                    @{@"label": @380}, @{@"gap": @10}, @{@"label": @380}];
        }
            break;
        case DTTableChartStyleC1C6: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10},
                    @{@"label": @300}, @{@"gap": @30}, @{@"label": @300}, @{@"gap": @30}, @{@"label": @300}, @{@"gap": @30},
                    @{@"label": @300}, @{@"gap": @30}, @{@"label": @300}, @{@"gap": @30}, @{@"label": @300}];
        }
            break;
        case DTTableChartStyleC1C7: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10},
                    @{@"label": @270}, @{@"gap": @10}, @{@"label": @270}, @{@"gap": @10}, @{@"label": @270}, @{@"gap": @10},
                    @{@"label": @270}, @{@"gap": @10}, @{@"label": @270}, @{@"gap": @10}, @{@"label": @270}, @{@"gap": @10},
                    @{@"label": @270}];
        }
            break;

        case DTTableChartStyleC1C8: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10},
                    @{@"label": @230}, @{@"gap": @10}, @{@"label": @230}, @{@"gap": @10}, @{@"label": @230}, @{@"gap": @10},
                    @{@"label": @230}, @{@"gap": @10}, @{@"label": @230}, @{@"gap": @10}, @{@"label": @230}, @{@"gap": @10},
                    @{@"label": @230}, @{@"gap": @10}, @{@"label": @230}];
        }
            break;
        case DTTableChartStyleC1C9: {
            widths = @[@{@"label": @170}, @{@"gap": @10},
                    @{@"label": @200}, @{@"gap": @10}, @{@"label": @200}, @{@"gap": @10}, @{@"label": @200}, @{@"gap": @10},
                    @{@"label": @200}, @{@"gap": @10}, @{@"label": @200}, @{@"gap": @10}, @{@"label": @200}, @{@"gap": @10},
                    @{@"label": @200}, @{@"gap": @10}, @{@"label": @200}, @{@"gap": @10}, @{@"label": @200}];
        }
            break;
        case DTTableChartStyleC1C1C14: {
            widths = @[
                    @{@"label": @140}, @{@"gap": @10},
                    @{@"label": @270}, @{@"gap": @10},
                    @{@"label": @110}, @{@"gap": @10}, @{@"label": @110}, @{@"gap": @10}, @{@"label": @110}, @{@"gap": @10}, @{@"label": @110}, @{@"gap": @10},
                    @{@"label": @110}, @{@"gap": @10}, @{@"label": @110}, @{@"gap": @10}, @{@"label": @110}, @{@"gap": @10}, @{@"label": @110}, @{@"gap": @10},
                    @{@"label": @110}, @{@"gap": @10}, @{@"label": @110}, @{@"gap": @10}, @{@"label": @110}, @{@"gap": @10}, @{@"label": @110}, @{@"gap": @10},
                    @{@"label": @110}, @{@"gap": @10}, @{@"label": @110}];
        }
            break;
        case DTTableChartStyleC1C1C31: {
            widths = @[
                    @{@"label": @120}, @{@"gap": @10},
                    @{@"label": @140}, @{@"gap": @10},
                    @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10},
                    @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10},
                    @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10},
                    @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10},
                    @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10},
                    @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10},
                    @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10},
                    @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10},
                    @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10},
                    @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10}, @{@"label": @50}, @{@"gap": @10},
                    @{@"label": @50}];
        }
            break;
        case DTTableChartStyleT2C1C2: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @50}, @{@"label": @410}, @{@"gap": @10}, @{@"label": @410},
                    @{@"gap": @30},
                    @{@"label": @170}, @{@"gap": @50}, @{@"label": @410}, @{@"gap": @10}, @{@"label": @410}];
        }
            break;
        case DTTableChartStyleT2C1C3: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10}, @{@"label": @270}, @{@"gap": @30}, @{@"label": @270}, @{@"gap": @30}, @{@"label": @270},
                    @{@"gap": @30},
                    @{@"label": @170}, @{@"gap": @10}, @{@"label": @270}, @{@"gap": @30}, @{@"label": @270}, @{@"gap": @30}, @{@"label": @270}];
        }
            break;
        case DTTableChartStyleT2C1C4: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10}, @{@"label": @210}, @{@"gap": @10}, @{@"label": @210}, @{@"gap": @10}, @{@"label": @210}, @{@"gap": @10}, @{@"label": @210},
                    @{@"gap": @30},
                    @{@"label": @170}, @{@"gap": @10}, @{@"label": @210}, @{@"gap": @10}, @{@"label": @210}, @{@"gap": @10}, @{@"label": @210}, @{@"gap": @10}, @{@"label": @210}];
        }
            break;
        default: {
            widths = @[];
        }
            break;
    }
    return widths;
}


+ (instancetype)tableChart:(DTTableChartStyle)chartStyle origin:(CGPoint)origin widthCellCount:(NSUInteger)width heightCellCount:(NSUInteger)height {

    NSArray *widths = [self presetTableChartCellWidth:chartStyle];

    DTTableChart *tableChart = [DTTableChart tableChartCustom:widths origin:origin widthCellCount:width heightCellCount:height];
    tableChart.tableChartStyle = chartStyle;
    return tableChart;
}

+ (instancetype)tableChartCustom:(NSArray *)widths origin:(CGPoint)origin widthCellCount:(NSUInteger)width heightCellCount:(NSUInteger)height {

    DTTableChart *tableChart = [[DTTableChart alloc] initWithOrigin:origin xAxis:width yAxis:height];
    tableChart.tableChartStyle = DTTableChartStyleCustom;
    tableChart.presetCellWidths = widths;
    return tableChart;
}

- (void)initial {
    [super initial];

    self.userInteractionEnabled = YES;
    self.coordinateAxisInsets = ChartEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.tableView];

}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = DTTableChartCellHeight;

        _headView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableHeaderView = _headView;

        [_tableView registerClass:[DTTableChartCell class] forCellReuseIdentifier:DTTableChartCellReuseIdentifier];
    }
    return _tableView;
}

- (NSMutableArray<NSArray<DTChartItemData *> *> *)listRowData {
    if (!_listRowData) {
        _listRowData = [NSMutableArray array];
    }
    return _listRowData;
}

- (void)setHeadViewHeight:(CGFloat)headViewHeight {
    _headViewHeight = headViewHeight;

    self.headView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), _headViewHeight);
}


- (void)setTableChartStyle:(DTTableChartStyle)tableChartStyle {
    _tableChartStyle = tableChartStyle;

    _presetCellWidths = [DTTableChart presetTableChartCellWidth:_tableChartStyle];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.xAxisLabelDatas.count > 0 ? 1 : 0;
    } else {
        return self.self.listRowData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTTableChartCell *cell = [tableView dequeueReusableCellWithIdentifier:DTTableChartCellReuseIdentifier];

    [cell setStyle:self.tableChartStyle widths:self.presetCellWidths];

    if (indexPath.section == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
        [cell setCellTitle:self.xAxisLabelDatas];
#pragma clang diagnostic pop
    } else {
        [cell setCellData:self.listRowData[(NSUInteger) indexPath.row] indexPath:indexPath];
    }

    return cell;
}

#pragma mark - override

/**
 * 清除坐标系里的值
 */
- (void)clearChartContent {

}

- (BOOL)drawXAxisLabels {
    if (![super drawXAxisLabels]) {
        return NO;
    }

    return YES;
}

- (BOOL)drawYAxisLabels {
    return YES;
}

- (void)drawValues {

    NSUInteger count = 0;
    for (DTChartSingleData *sData in self.multiData) {
        if (sData.itemValues.count > count) {
            count = sData.itemValues.count;
        }
    }

    [self.listRowData removeAllObjects];

    for (NSUInteger i = 0; i < count; ++i) {
        NSMutableArray<DTChartItemData *> *rowData = [NSMutableArray array];
        for (DTChartSingleData *sData in self.multiData) {
            if (sData.itemValues.count > i) {
                DTChartItemData *itemData = sData.itemValues[i];
                [rowData addObject:itemData];
            } else {
                DTChartItemData *itemData = [DTChartItemData chartData];
                itemData.title = @"";
                [rowData addObject:itemData];
            }

        }

        [self.listRowData addObject:rowData];
    }

    [self.tableView reloadData];
}

- (void)drawChart {
    [super drawChart];
}

@end
