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
@property(nonatomic) DTTableChartStyle tableChartStyle;
@property(nonatomic) NSArray *presetCellWidths;
@property(nonatomic) NSMutableArray<NSArray<DTChartItemData *> *> *listRowData;

@end

@implementation DTTableChart

static NSString *const DTTableChartCellReuseIdentifier = @"DTTableChartCellReuseIdentifier";

/**
 * 获取表格一行所有label和间隙的宽度
 * @param chartStyle 预设表格风格
 * @return 宽度
 *
 * @attention 宽度是px，需除以2
 */
+ (NSArray *)presetTableChartCellWidth:(DTTableChartStyle)chartStyle {
    NSArray *widths;
    switch (chartStyle) {
        case DTTableChartStyleC1C6: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10},
                    @{@"label": @300}, @{@"gap": @30}, @{@"label": @300}, @{@"gap": @30}, @{@"label": @300}, @{@"gap": @30},
                    @{@"label": @300}, @{@"gap": @30}, @{@"label": @300}, @{@"gap": @30}, @{@"label": @300}];
        }
            break;
        case DTTableChartStyleC1C2: {
            widths = @[@{@"label": @170}, @{@"gap": @30}, @{@"label": @960}, @{@"gap": @10}, @{@"label": @960}];
        }
            break;
        case DTTableChartStyleC1C5: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10},
                    @{@"label": @380}, @{@"gap": @10}, @{@"label": @380}, @{@"gap": @10}, @{@"label": @380}, @{@"gap": @10},
                    @{@"label": @380}, @{@"gap": @10}, @{@"label": @380}];
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
        case DTTableChartStyleT2C1C4: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10}, @{@"label": @210}, @{@"gap": @10}, @{@"label": @210}, @{@"gap": @10}, @{@"label": @210}, @{@"gap": @10}, @{@"label": @210},
                    @{@"gap": @30},
                    @{@"label": @170}, @{@"gap": @10}, @{@"label": @210}, @{@"gap": @10}, @{@"label": @210}, @{@"gap": @10}, @{@"label": @210}, @{@"gap": @10}, @{@"label": @210}];
        }
            break;
        case DTTableChartStyleC1C9: {
            widths = @[@{@"label": @170}, @{@"gap": @10},
                    @{@"label": @200}, @{@"gap": @10}, @{@"label": @200}, @{@"gap": @10}, @{@"label": @200}, @{@"gap": @10},
                    @{@"label": @200}, @{@"gap": @10}, @{@"label": @200}, @{@"gap": @10}, @{@"label": @200}, @{@"gap": @10},
                    @{@"label": @200}, @{@"gap": @10}, @{@"label": @200}, @{@"gap": @10}, @{@"label": @200}];
        }
            break;
        case DTTableChartStyleT2C1C3: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10}, @{@"label": @270}, @{@"gap": @30}, @{@"label": @270}, @{@"gap": @30}, @{@"label": @270},
                    @{@"gap": @30},
                    @{@"label": @170}, @{@"gap": @10}, @{@"label": @270}, @{@"gap": @30}, @{@"label": @270}, @{@"gap": @30}, @{@"label": @270}];
        }
            break;
        case DTTableChartStyleC1C3: {
            widths = @[@{@"label": @170}, @{@"gap": @50}, @{@"label": @630}, @{@"gap": @10}, @{@"label": @630}, @{@"gap": @10}, @{@"label": @630}];
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
        case DTTableChartStyleC1C7: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10},
                    @{@"label": @270}, @{@"gap": @10}, @{@"label": @270}, @{@"gap": @10}, @{@"label": @270}, @{@"gap": @10},
                    @{@"label": @270}, @{@"gap": @10}, @{@"label": @270}, @{@"gap": @10}, @{@"label": @270}, @{@"gap": @10},
                    @{@"label": @270}];
        }
            break;
        case DTTableChartStyleC1C4: {
            widths = @[
                    @{@"label": @170}, @{@"gap": @10},
                    @{@"label": @480}, @{@"gap": @10}, @{@"label": @480}, @{@"gap": @10},
                    @{@"label": @480}, @{@"gap": @10}, @{@"label": @480}];
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
        default: {
            widths = @[];
        }
            break;
    }
    return widths;
}

+ (instancetype)tableChart:(DTTableChartStyle)chartStyle origin:(CGPoint)origin heightCellCount:(NSUInteger)height {

    NSArray *widths = [self presetTableChartCellWidth:chartStyle];

    DTTableChart *tableChart =[DTTableChart tableChartCustom:widths origin:origin heightCellCount:height];
    tableChart.tableChartStyle = chartStyle;
    return tableChart;
}

+ (instancetype)tableChartCustom:(NSArray<NSDictionary *> *)widths origin:(CGPoint)origin heightCellCount:(NSUInteger)height {
    NSUInteger xCount = 0;

    CGFloat totalWidth = 0;
    for (NSDictionary *dictionary in widths) {
        if (dictionary[@"label"]) {
            NSNumber *number = dictionary[@"label"];
            totalWidth += number.floatValue / 2;
        } else if (dictionary[@"gap"]) {
            NSNumber *number = dictionary[@"gap"];
            totalWidth += number.floatValue / 2;
        }
    }

    xCount = (NSUInteger) ceil(totalWidth / DefaultCoordinateAxisCellWidth);

    DTTableChart *tableChart = [[DTTableChart alloc] initWithOrigin:origin xAxis:xCount yAxis:height];
    tableChart.tableChartStyle = DTTableChartStyleCustom;
    return tableChart;
}

- (void)initial {
    [super initial];

    self.userInteractionEnabled = YES;
    self.coordinateAxisInsets = ChartEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.tableView];

    NSMutableArray<NSDictionary *> *list = [NSMutableArray array];
    [list addObject:@{}];

}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _headView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableHeaderView = _headView;
    }
    return _tableView;
}

- (NSMutableArray<NSArray<DTChartItemData *> *> *)listRowData {
    if (!_listRowData) {
        _listRowData = [NSMutableArray array];
    }
    return _listRowData;
}

- (void)setTableChartStyle:(DTTableChartStyle)tableChartStyle {
    _tableChartStyle = tableChartStyle;

    if (_tableChartStyle != DTTableChartStyleCustom) {
        _presetCellWidths = [DTTableChart presetTableChartCellWidth:_tableChartStyle];
    }
}


- (void)setHeadViewHeight:(CGFloat)headViewHeight {
    _headViewHeight = headViewHeight;

    self.headView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), _headViewHeight);
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
    if (!cell) {
        cell = [[DTTableChartCell alloc] initWithWidths:self.presetCellWidths reuseIdentifier:DTTableChartCellReuseIdentifier];
    }

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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DTTableChartCellHeight;
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
