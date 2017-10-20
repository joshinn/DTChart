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
#import "DTChartToastView.h"

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
static CGFloat const DTTableChartCellHeight = 35;

+ (NSArray *)presetTableChartCellWidth:(DTTableChartStyle)chartStyle {
    DTLog(@"presetTableChartCellWidth");
    NSArray *widths;
    switch (chartStyle) {
        case DTTableChartStyleC1C1: {
            widths = @[@{@"label": @105}, @{@"gap": @10}, @{@"label": @950}];
        }
            break;
        case DTTableChartStyleC1C2: {
            widths = @[@{@"label": @90}, @{@"gap": @10}, @{@"label": @480}, @{@"gap": @5}, @{@"label": @480}];
        }
            break;

        case DTTableChartStyleC1C2B1: {
            widths = @[@{@"label": @120}, @{@"gap": @10}, @{@"label": @465}, @{@"gap": @5}, @{@"label": @465}];
        }
            break;
        case DTTableChartStyleC1C2B2: {
            widths = @[@{@"label": @95}, @{@"gap": @15}, @{@"label": @475}, @{@"gap": @5}, @{@"label": @475}];
        }
            break;
        case DTTableChartStyleC1C2B3: {
            widths = @[@{@"label": @135}, @{@"gap": @10}, @{@"label": @450}, @{@"gap": @10}, @{@"label": @450}];
        }
            break;
        case DTTableChartStyleC1C3: {
            widths = @[@{@"label": @90}, @{@"gap": @20}, @{@"label": @315}, @{@"gap": @5}, @{@"label": @315}, @{@"gap": @5}, @{@"label": @315}];
        }
            break;
        case DTTableChartStyleC1C3B1: {
            widths = @[@{@"label": @105}, @{@"gap": @5}, @{@"label": @315}, @{@"gap": @5}, @{@"label": @315}, @{@"gap": @5}, @{@"label": @315}];
        }
            break;
        case DTTableChartStyleC1C3B2: {
            widths = @[@{@"label": @120}, @{@"gap": @10}, @{@"label": @305}, @{@"gap": @10}, @{@"label": @305}, @{@"gap": @10}, @{@"label": @305}];
        }
            break;
        case DTTableChartStyleC1C3B3: {
            widths = @[@{@"label": @135}, @{@"gap": @5}, @{@"label": @305}, @{@"gap": @5}, @{@"label": @305}, @{@"gap": @5}, @{@"label": @305}];
        }
            break;
        case DTTableChartStyleC1C3B4: {
            widths = @[@{@"label": @495}, @{@"gap": @10}, @{@"label": @180}, @{@"gap": @10}, @{@"label": @180}, @{@"gap": @10}, @{@"label": @180}];
        }
            break;
        case DTTableChartStyleC1C4: {
            widths = @[
                    @{@"label": @190}, @{@"gap": @5},
                    @{@"label": @210}, @{@"gap": @5}, @{@"label": @210}, @{@"gap": @5},
                    @{@"label": @210}, @{@"gap": @5}, @{@"label": @210}];
        }
            break;
        case DTTableChartStyleC1C4B1: {
            widths = @[
                    @{@"label": @105}, @{@"gap": @5},
                    @{@"label": @235}, @{@"gap": @5}, @{@"label": @235}, @{@"gap": @5},
                    @{@"label": @235}, @{@"gap": @5}, @{@"label": @235}];
        }
            break;
        case DTTableChartStyleC1C5: {
            widths = @[
                    @{@"label": @85}, @{@"gap": @5},
                    @{@"label": @190}, @{@"gap": @5}, @{@"label": @190}, @{@"gap": @5}, @{@"label": @190}, @{@"gap": @5},
                    @{@"label": @190}, @{@"gap": @5}, @{@"label": @190}];
        }
            break;
        case DTTableChartStyleC1C5B1: {
            widths = @[
                    @{@"label": @495}, @{@"gap": @5},
                    @{@"label": @109}, @{@"gap": @5}, @{@"label": @109}, @{@"gap": @5}, @{@"label": @109}, @{@"gap": @5},
                    @{@"label": @109}, @{@"gap": @5}, @{@"label": @109}];
        }
            break;
        case DTTableChartStyleC1C5B2: {
            widths = @[
                    @{@"label": @120}, @{@"gap": @10},
                    @{@"label": @183}, @{@"gap": @5}, @{@"label": @183}, @{@"gap": @5}, @{@"label": @183}, @{@"gap": @5},
                    @{@"label": @183}, @{@"gap": @5}, @{@"label": @183}];
        }
            break;
        case DTTableChartStyleC1C5B3: {
            widths = @[
                    @{@"label": @180}, @{@"gap": @5},
                    @{@"label": @172}, @{@"gap": @5}, @{@"label": @172}, @{@"gap": @5}, @{@"label": @172}, @{@"gap": @5},
                    @{@"label": @172}, @{@"gap": @5}, @{@"label": @172}];
        }
            break;
        case DTTableChartStyleC1C5B4: {
            widths = @[
                    @{@"label": @495}, @{@"gap": @5},
                    @{@"label": @109}, @{@"gap": @5}, @{@"label": @109}, @{@"gap": @5}, @{@"label": @109}, @{@"gap": @5},
                    @{@"label": @109}, @{@"gap": @5}, @{@"label": @109}];
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
                    @{@"label": @85}, @{@"gap": @5},
                    @{@"label": @135}, @{@"gap": @5}, @{@"label": @135}, @{@"gap": @5}, @{@"label": @135}, @{@"gap": @5},
                    @{@"label": @135}, @{@"gap": @5}, @{@"label": @135}, @{@"gap": @5}, @{@"label": @135}, @{@"gap": @5},
                    @{@"label": @135}];
        }
            break;

        case DTTableChartStyleC1C8: {
            widths = @[
                    @{@"label": @85}, @{@"gap": @5},
                    @{@"label": @115}, @{@"gap": @5}, @{@"label": @115}, @{@"gap": @5}, @{@"label": @115}, @{@"gap": @5},
                    @{@"label": @115}, @{@"gap": @5}, @{@"label": @115}, @{@"gap": @5}, @{@"label": @115}, @{@"gap": @5},
                    @{@"label": @115}, @{@"gap": @5}, @{@"label": @115}];
        }
            break;
        case DTTableChartStyleC1C9: {
            widths = @[@{@"label": @85}, @{@"gap": @5},
                    @{@"label": @100}, @{@"gap": @5}, @{@"label": @100}, @{@"gap": @5}, @{@"label": @100}, @{@"gap": @5},
                    @{@"label": @100}, @{@"gap": @5}, @{@"label": @100}, @{@"gap": @5}, @{@"label": @100}, @{@"gap": @5},
                    @{@"label": @100}, @{@"gap": @5}, @{@"label": @100}, @{@"gap": @5}, @{@"label": @100}];
        }
            break;
        case DTTableChartStyleC1C1C5: {
            widths = @[
                    @{@"label": @70}, @{@"gap": @5},
                    @{@"label": @465}, @{@"gap": @5},
                    @{@"label": @124}, @{@"gap": @5}, @{@"label": @94}, @{@"gap": @5}, @{@"label": @94}, @{@"gap": @5},
                    @{@"label": @94}, @{@"gap": @5}, @{@"label": @94}];
        }
            break;
        case DTTableChartStyleC1C1C6: {
            widths = @[
                    @{@"label": @215}, @{@"gap": @5},
                    @{@"label": @215}, @{@"gap": @5},
                    @{@"label": @100}, @{@"gap": @5}, @{@"label": @100}, @{@"gap": @5}, @{@"label": @100}, @{@"gap": @5},
                    @{@"label": @100}, @{@"gap": @5}, @{@"label": @100}, @{@"gap": @5}, @{@"label": @100}];
        }
            break;
        case DTTableChartStyleC1C1C8: {
            widths = @[
                    @{@"label": @190}, @{@"gap": @5},
                    @{@"label": @190}, @{@"gap": @5},
                    @{@"label": @80}, @{@"gap": @5}, @{@"label": @80}, @{@"gap": @5}, @{@"label": @80}, @{@"gap": @5}, @{@"label": @80}, @{@"gap": @5},
                    @{@"label": @80}, @{@"gap": @5}, @{@"label": @80}, @{@"gap": @5}, @{@"label": @80}, @{@"gap": @5}, @{@"label": @80}];
        }
            break;
        case DTTableChartStyleC1C1C9: {
            widths = @[
                    @{@"label": @190}, @{@"gap": @5},
                    @{@"label": @135}, @{@"gap": @5},
                    @{@"label": @75}, @{@"gap": @5},
                    @{@"label": @75}, @{@"gap": @5}, @{@"label": @75}, @{@"gap": @5}, @{@"label": @75}, @{@"gap": @5}, @{@"label": @75}, @{@"gap": @5},
                    @{@"label": @75}, @{@"gap": @5}, @{@"label": @75}, @{@"gap": @5}, @{@"label": @75}, @{@"gap": @5}, @{@"label": @75}];
        }
            break;
        case DTTableChartStyleC1C1C14: {
            widths = @[
                    @{@"label": @105}, @{@"gap": @5},
                    @{@"label": @105}, @{@"gap": @5},
                    @{@"label": @50}, @{@"gap": @5}, @{@"label": @50}, @{@"gap": @5}, @{@"label": @50}, @{@"gap": @5}, @{@"label": @50}, @{@"gap": @5},
                    @{@"label": @50}, @{@"gap": @5}, @{@"label": @50}, @{@"gap": @5}, @{@"label": @50}, @{@"gap": @5}, @{@"label": @50}, @{@"gap": @5},
                    @{@"label": @50}, @{@"gap": @5}, @{@"label": @50}, @{@"gap": @5}, @{@"label": @50}, @{@"gap": @5}, @{@"label": @50}, @{@"gap": @5},
                    @{@"label": @50}, @{@"gap": @5}, @{@"label": @50}];
        }
            break;
        case DTTableChartStyleC1C1C31: {
            widths = @[
                    @{@"label": @35}, @{@"gap": @2},
                    @{@"label": @39}, @{@"gap": @2},
                    @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1},
                    @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1},
                    @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1},
                    @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1},
                    @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1},
                    @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1},
                    @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1},
                    @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1},
                    @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1},
                    @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1}, @{@"label": @31}, @{@"gap": @1},
                    @{@"label": @31}];
        }
            break;
        case DTTableChartStyleT2C1C1: {
            widths = @[@{@"label": @105}, @{@"gap": @5}, @{@"label": @415}, @{@"gap": @15},
                    @{@"label": @105}, @{@"gap": @5}, @{@"label": @415}];
        }
            break;
        case DTTableChartStyleT2C1C2: {
            widths = @[
                    @{@"label": @90}, @{@"gap": @20}, @{@"label": @205}, @{@"gap": @5}, @{@"label": @205},
                    @{@"gap": @15},
                    @{@"label": @90}, @{@"gap": @20}, @{@"label": @205}, @{@"gap": @5}, @{@"label": @205}];
        }
            break;
        case DTTableChartStyleT2C1C2B1: {
            widths = @[
                    @{@"label": @120}, @{@"gap": @5}, @{@"label": @205}, @{@"gap": @5}, @{@"label": @205},
                    @{@"gap": @15},
                    @{@"label": @120}, @{@"gap": @5}, @{@"label": @205}, @{@"gap": @5}, @{@"label": @205}];
        }
            break;
        case DTTableChartStyleT2C1C3: {
            widths = @[
                    @{@"label": @90}, @{@"gap": @5}, @{@"label": @135}, @{@"gap": @10}, @{@"label": @135}, @{@"gap": @10}, @{@"label": @135},
                    @{@"gap": @20},
                    @{@"label": @90}, @{@"gap": @5}, @{@"label": @135}, @{@"gap": @10}, @{@"label": @135}, @{@"gap": @10}, @{@"label": @135}];
        }
            break;
        case DTTableChartStyleT2C1C3B1: {
            widths = @[
                    @{@"label": @105}, @{@"gap": @5}, @{@"label": @135}, @{@"gap": @5}, @{@"label": @135}, @{@"gap": @5}, @{@"label": @135},
                    @{@"gap": @30},
                    @{@"label": @105}, @{@"gap": @5}, @{@"label": @135}, @{@"gap": @5}, @{@"label": @135}, @{@"gap": @5}, @{@"label": @135}];
        }
            break;
        case DTTableChartStyleT2C1C4: {
            widths = @[
                    @{@"label": @85}, @{@"gap": @5}, @{@"label": @105}, @{@"gap": @5}, @{@"label": @105}, @{@"gap": @5}, @{@"label": @105}, @{@"gap": @5}, @{@"label": @105},
                    @{@"gap": @15},
                    @{@"label": @85}, @{@"gap": @5}, @{@"label": @105}, @{@"gap": @5}, @{@"label": @105}, @{@"gap": @5}, @{@"label": @105}, @{@"gap": @5}, @{@"label": @105}];
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
    _titleCellHeight = DTTableChartCellHeight;

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
    cell.selectable = self.valueSelectable;
    cell.labelLeftOffset = self.tableLeftOffset;
    cell.delegate = self;


    if (indexPath.section == 0) {
        cell.rowHeight = self.titleCellHeight;
    } else {
        cell.rowHeight = DTTableChartCellHeight;
    }
    [cell setStyle:self.tableChartStyle widths:self.presetCellWidths];

    cell.mainColor = self.mainColor;
    cell.secondColor = self.secondColor;

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.titleCellHeight;
    } else {
        return DTTableChartCellHeight;
    }
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

- (void)showTouchMessage:(NSString *)message touchPoint:(CGPoint)point {
    [self.toastView show:message location:point];
}

- (void)hideTouchMessage {
    [self.toastView hide];
}

#pragma mark - public method

- (void)setCustomCellWidths:(NSArray *)widths {
    _presetCellWidths = widths;
    _tableChartStyle = DTTableChartStyleCustom;
}

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

- (void)chartCellHintTouchBegin:(DTTableChartCell *)cell text:(NSString *)text index:(NSUInteger)index isMainAxis:(BOOL)isMainAxis touch:(UITouch *)touch {
    CGPoint p = [touch locationInView:self.contentView];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    NSString *title;
    if (isMainAxis) {
        title = self.yAxisLabelDatas[index].title;
    } else {
        title = self.ySecondAxisLabelDatas[index].title;
    }

    NSString *message = nil;
    if (self.chartCellHintTouchBlock) {
        message = self.chartCellHintTouchBlock(indexPath.row, index);
        if (message) {
            [self showTouchMessage:message touchPoint:p];
        }
    } else {
        message = [NSString stringWithFormat:@"%@\n%@", title, text];
        [self showTouchMessage:message touchPoint:p];
    }
}

- (void)chartCellHintTouchEnd {
    [self hideTouchMessage];
}

@end
