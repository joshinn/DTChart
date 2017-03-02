//
//  DTTableChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/4.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTTableChart.h"
#import "DTTableChartCell.h"
#import "DTTableChartSingleData.h"


@interface DTTableChart () <UITableViewDataSource, UITableViewDelegate, DTTableChartCellDelegate>

@property(nonatomic) UITableView *tableView;

@property(nonatomic) NSArray *presetCellWidths;

/**
 * 主表数据
 */
//@property(nonatomic) NSMutableArray<DTChartSingleData *> *listRowData;
/**
 * 副表数据
 */
//@property(nonatomic) NSMutableArray<DTChartSingleData *> *listSecondRowData;

@end

@implementation DTTableChart

static NSString *const DTTableChartCellReuseIdentifier = @"DTTableChartCellID";


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

    _collapseColumn = -1;
    _tableLeftOffset = 0;

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
        return self.yAxisLabelDatas.count > 0 ? 1 : 0;
    } else {
        return MAX(self.multiData.count, self.secondMultiData.count);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTTableChartCell *cell = [tableView dequeueReusableCellWithIdentifier:DTTableChartCellReuseIdentifier];
    cell.labelLeftOffset = self.tableLeftOffset;
    cell.delegate = self;

    [cell setStyle:self.tableChartStyle widths:self.presetCellWidths];

    if (indexPath.section == 0) {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
        [cell setCellTitle:self.yAxisLabelDatas secondTitles:self.ySecondAxisLabelDatas];
#pragma clang diagnostic pop

    } else {

        cell.collapseColumn = self.collapseColumn;

        DTTableChartSingleData *mainTableRowData = nil;
        DTTableChartSingleData *secondTableRowData = nil;

        if (self.multiData.count > indexPath.row) {
            mainTableRowData = (DTTableChartSingleData *) self.multiData[(NSUInteger) indexPath.row];
        }
        if (self.secondMultiData.count > indexPath.row) {
            secondTableRowData = (DTTableChartSingleData *) self.secondMultiData[(NSUInteger) indexPath.row];
        }
        [cell setCellData:mainTableRowData second:secondTableRowData indexPath:indexPath];
    }

    return cell;
}

#pragma mark - private method

/**
 * 有展开项时，加工 tableView 行数据
 * 找出数据的详细行和头部行
 * @param originData 原始数据
 * @return 加工过的行数据
 */
- (NSArray<DTChartSingleData *> *)processRowData:(NSArray<DTChartSingleData *> *)originData {
    NSMutableArray<DTChartSingleData *> *copyData = [originData mutableCopy];

    NSMutableArray<NSString *> *seriesIds = [NSMutableArray array];

    DTTableChartSingleData *headerSingleData = nil;
    NSMutableArray<DTTableChartSingleData *> *detailRows = [NSMutableArray array];

    for (DTChartSingleData *sData in originData) {
        DTTableChartSingleData *tableChartSingleData = (DTTableChartSingleData *) sData;

        BOOL exist = NO;
        for (NSUInteger i = seriesIds.count; i > 0; --i) {
            NSString *sId = seriesIds[i - 1];
            if ([sId isEqualToString:sData.singleId]) {

                tableChartSingleData.headerRow = NO;
                [detailRows addObject:tableChartSingleData];
                [copyData removeObject:tableChartSingleData];
                exist = YES;
                break;
            }
        }

        if (!exist) {
            headerSingleData = tableChartSingleData;
            detailRows = [NSMutableArray array];
            [seriesIds addObject:tableChartSingleData.singleId];
        } else {
            if (detailRows.count > 0) {
                headerSingleData.collapseRows = detailRows;
            } else {
                headerSingleData.collapseRows = nil;
            }
        }

    }

    return copyData;
}

#pragma mark - public method

- (void)deleteItems:(NSArray<NSString *> *)seriesIds {
    NSMutableArray *temp = [self.multiData mutableCopy];
    NSMutableArray *tempSeriesId = [seriesIds mutableCopy];

    for (NSString *sId in seriesIds) {
        [self.multiData enumerateObjectsUsingBlock:^(DTChartSingleData *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.singleId isEqualToString:sId]) {
                [temp removeObject:obj];
                [tempSeriesId removeObject:sId];
            }
        }];
    }
    self.multiData = temp;

    temp = [self.secondMultiData mutableCopy];
    for (NSString *sId in tempSeriesId) {
        [self.secondMultiData enumerateObjectsUsingBlock:^(DTChartSingleData *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.singleId isEqualToString:sId]) {
                [temp removeObject:obj];
            }
        }];
    }
    self.secondMultiData = temp;

    [self.tableView reloadData];
}

- (void)addExpandItems:(NSArray<DTTableChartSingleData *> *)mainData {

    NSString *toExpandSeriesId = mainData.firstObject.singleId;

    for (NSUInteger i = 0; i < self.multiData.count; ++i) {
        DTTableChartSingleData *rowData = (DTTableChartSingleData *) self.multiData[i];

        if ([toExpandSeriesId isEqualToString:rowData.singleId]) {

            if (rowData.collapseRows) {
                NSMutableArray *temp = [rowData.collapseRows mutableCopy];
                [temp addObjectsFromArray:mainData];
                rowData.collapseRows = temp;

            } else {
                rowData.collapseRows = mainData;
            }

            break;
        }

    }

    [self chartCellToExpandTouched:toExpandSeriesId];
}

#pragma mark - override

#pragma mark - ############主表############

/**
 * 清除坐标系里的值
 */
- (void)clearChartContent {
}

- (BOOL)drawXAxisLabels {
    return YES;
}

- (BOOL)drawYAxisLabels {
    return YES;
}

- (void)drawValues {
    if (self.collapseColumn >= 0) {
        self.multiData = [self processRowData:self.multiData];
    }
}

- (void)drawChart {
    [super drawChart];

    [self drawSecondChart];
}


#pragma mark - ############副表############


- (BOOL)drawYSecondAxisLabels {
    return YES;
}

- (void)drawSecondValues {
    if (self.collapseColumn >= 0) {
        self.secondMultiData = [self processRowData:self.secondMultiData];
    }
}

/**
 * xxx
 */
- (void)drawSecondChart {
    [super drawSecondChart];

    [self.tableView reloadData];
}


#pragma mark - DTTableChartCellDelegate

- (void)chartCellToExpandTouched:(NSString *)seriesId {

    for (NSUInteger i = 0; i < self.multiData.count; ++i) {
        DTTableChartSingleData *rowData = (DTTableChartSingleData *) self.multiData[i];
        if ([seriesId isEqualToString:rowData.singleId] && rowData.isHeaderRow) {

            if (!rowData.collapseRows) {
                rowData.expandType = DTTableChartCellExpanding;
                if (self.expandTouchBlock) {
                    self.expandTouchBlock(seriesId);
                }
                break;
            }

            rowData.expandType = DTTableChartCellDidExpand;

            NSMutableArray<DTChartSingleData *> *copyData = [self.multiData mutableCopy];
            [self.multiData enumerateObjectsUsingBlock:^(DTChartSingleData *obj, NSUInteger idx, BOOL *stop) {
                if ([obj.singleId isEqualToString:seriesId] && obj != rowData) {
                    [copyData removeObject:obj];
                }
            }];

            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            for (NSUInteger j = 0; j < rowData.collapseRows.count; ++j) {
                [indexSet addIndex:i + j + 1];
            }

            if (indexSet.count > 0) {
                [copyData insertObjects:rowData.collapseRows atIndexes:indexSet];
            }

            self.multiData = copyData;
            break;
        }
    }

    [self.tableView reloadData];
}

- (void)chartCellToCollapseTouched:(NSString *)seriesId {
    for (NSUInteger i = 0; i < self.multiData.count; ++i) {
        DTTableChartSingleData *rowData = (DTTableChartSingleData *) self.multiData[i];
        if ([seriesId isEqualToString:rowData.singleId]) {
            rowData.expandType = DTTableChartCellWillExpand;

            NSMutableArray *copyData = [self.multiData mutableCopy];

            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            for (NSUInteger j = 0; j < rowData.collapseRows.count; ++j) {
                [indexSet addIndex:i + j + 1];
            }

            if (indexSet.count > 0) {
                [copyData removeObjectsAtIndexes:indexSet];
            }

            self.multiData = copyData;
            break;
        }
    }

    [self.tableView reloadData];
}

- (void)chartCellOrderTouched:(BOOL)isMainAxis column:(NSUInteger)column {
    if (self.orderTouchBlock) {
        self.orderTouchBlock(isMainAxis, column);
    }
}

@end