//
//  DTDimensionBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/18.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionBarChart.h"
#import "DTChartLabel.h"
#import "DTChartToastView.h"
#import "DTDimensionBarChartCell.h"
#import "DTDimensionBarModel.h"

CGFloat const DimensionLabelWidth = 70;
CGFloat const DimensionLabelGap = 5;

@interface DTDimensionBarChart () <UITableViewDataSource, UITableViewDelegate, DTDimensionBarChartCellDelegate>

@property(nonatomic) UITableView *tableView;

@property(nonatomic, getter=isPrepare) BOOL prepare;

@property(nonatomic) NSMutableArray<NSNumber *> *titleWidths;   ///< 计算出的每个维度标题应该显示的宽度

#pragma mark - ##############第一度量##############

@property(nonatomic) UILabel *mainTitleLabel;                ///< 第一度量标题
@property(nonatomic) CGFloat mainZeroX; ///< 第一度量0的x值
@property(nonatomic) CGFloat mainPositiveLimitValue;    ///< 第一度量正值的最大值
@property(nonatomic) CGFloat mainPositiveLimitX;        ///< 第一度量正值的最大值的x
@property(nonatomic) CGFloat mainNegativeLimitValue;    ///< 第一度量负值的最小值
@property(nonatomic) CGFloat mainNegativeLimitX;        ///< 第一度量负值的最小值的x

#pragma mark - ##############第二度量##############

@property(nonatomic) UILabel *secondTitleLabel;
@property(nonatomic) CGFloat secondZeroX;
@property(nonatomic) CGFloat secondPositiveLimitValue;
@property(nonatomic) CGFloat secondPositiveLimitX;
@property(nonatomic) CGFloat secondNegativeLimitValue;
@property(nonatomic) CGFloat secondNegativeLimitX;


@property(nonatomic) NSMutableArray<DTDimensionBarModel *> *levelBarModels;

@property(nonatomic) UIImageView *fakeView;

@property(nonatomic) CGPoint panTranslate;
@property(nonatomic) CGPoint originCenter;

@property(nonatomic) CGPoint canSwipe;

@end

@implementation DTDimensionBarChart

static NSString *const DTDimensionBarChartCellId = @"DTDimensionBarChartCellId";

@synthesize valueSelectable = _valueSelectable;


- (void)initial {
    [super initial];
    _fontSize = 10;
    
    _fakeView = [[UIImageView alloc] init];
    _fakeView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
    _fakeView.layer.shadowOffset = CGSizeMake(2, 2);
    _fakeView.layer.shadowRadius = 4;
    
    self.userInteractionEnabled = YES;
    _prepare = NO;
    
    self.coordinateAxisInsets = ChartEdgeInsetsMake(0, 0, 0, 2);
    
    self.tableView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.tableView];
    
    [self addSubview:self.mainTitleLabel];
    [self addSubview:self.secondTitleLabel];
    
    self.colorManager = [DTColorManager randomManager];
}

- (void)setCoordinateAxisInsets:(ChartEdgeInsets)coordinateAxisInsets {
    [super setCoordinateAxisInsets:coordinateAxisInsets];
    
    self.tableView.frame = self.contentView.bounds;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 30;
        
        [_tableView registerClass:[DTDimensionBarChartCell class] forCellReuseIdentifier:DTDimensionBarChartCellId];
    }
    return _tableView;
}

- (UILabel *)mainTitleLabel {
    if (!_mainTitleLabel) {
        _mainTitleLabel = [[UILabel alloc] init];
        _mainTitleLabel.font = [UIFont systemFontOfSize:_fontSize];
        _mainTitleLabel.textAlignment = NSTextAlignmentCenter;
        _mainTitleLabel.textColor = MainBarColor;
    }
    return _mainTitleLabel;
}

- (UILabel *)secondTitleLabel {
    if (!_secondTitleLabel) {
        _secondTitleLabel = [[UILabel alloc] init];
        _secondTitleLabel.font = [UIFont systemFontOfSize:_fontSize];
        _secondTitleLabel.textAlignment = NSTextAlignmentCenter;
        _secondTitleLabel.textColor = SecondBarColor;
    }
    return _secondTitleLabel;
}

- (NSMutableArray<DTDimensionBarModel *> *)levelBarModels {
    if (!_levelBarModels) {
        _levelBarModels = [NSMutableArray array];
    }
    return _levelBarModels;
}

- (void)setValueSelectable:(BOOL)valueSelectable {
    _valueSelectable = valueSelectable;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    
    if (_mainTitleLabel) {
        _mainTitleLabel.font = [UIFont systemFontOfSize:_fontSize];
    }
    if (_secondTitleLabel) {
        _secondTitleLabel.font = [UIFont systemFontOfSize:_fontSize];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isPrepare) {
        return self.mainData.listDimensions.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTDimensionBarChartCell *barChartCell = [tableView dequeueReusableCellWithIdentifier:DTDimensionBarChartCellId];
    
    barChartCell.delegate = self;
    barChartCell.chartStyle = self.chartStyle;
    barChartCell.fontSize = _fontSize;
    barChartCell.cellSize = CGSizeMake(CGRectGetWidth(tableView.bounds), tableView.rowHeight);
    barChartCell.titleWidths = self.titleWidths;
    barChartCell.titleGap = DimensionLabelGap;
    barChartCell.selectable = self.valueSelectable;
    
    barChartCell.mainZeroX = self.mainZeroX;
    barChartCell.mainPositiveLimitValue = self.mainPositiveLimitValue;
    barChartCell.mainPositiveLimitX = self.mainPositiveLimitX;
    barChartCell.mainNegativeLimitValue = self.mainNegativeLimitValue;
    barChartCell.mainNegativeLimitX = self.mainNegativeLimitX;
    
    barChartCell.secondZeroX = self.secondZeroX;
    barChartCell.secondPositiveLimitValue = self.secondPositiveLimitValue;
    barChartCell.secondPositiveLimitX = self.secondPositiveLimitX;
    barChartCell.secondNegativeLimitValue = self.secondNegativeLimitValue;
    barChartCell.secondNegativeLimitX = self.secondNegativeLimitX;
    
    barChartCell.highlightTitle = self.highlightTitle;
    barChartCell.enableSwipe = self.chartCellCanSwipe;
    
    NSUInteger index = (NSUInteger) indexPath.row;
    DTDimension2Model *data = self.mainData.listDimensions[index];
    DTDimension2Model *secondData = self.secondData.listDimensions[index];
    DTDimension2Model *prev = nil;
    if (index > 0) {
        prev = self.mainData.listDimensions[index - 1];
    }
    
    DTDimension2Model *next = nil;
    if (index < self.mainData.listDimensions.count - 1) {
        next = self.mainData.listDimensions[index + 1];
    }
    
    [barChartCell setCellData:data second:secondData prev:prev next:next];
    
    
    return barChartCell;
}


#pragma mark - private method

- (void)showTouchMessage:(NSString *)message touchPoint:(CGPoint)point {
    
    [self.touchSelectedLine removeFromSuperlayer];
    [self.contentView.layer addSublayer:self.touchSelectedLine];
    self.touchSelectedLine.hidden = NO;
    
    CGFloat x = 0;
    CGFloat width = 0;
    if (self.mainNegativeLimitValue < 0 && point.x <= self.mainPositiveLimitX && point.x >= self.mainNegativeLimitX) {
        x = self.mainNegativeLimitX;
        width = self.mainPositiveLimitX - self.mainNegativeLimitX;
    } else if (self.mainNegativeLimitValue >= 0 && point.x <= self.mainPositiveLimitX && point.x >= self.mainZeroX) {
        x = self.mainZeroX;
        width = self.mainPositiveLimitX - self.mainZeroX;
    } else if (self.secondNegativeLimitValue < 0 && point.x <= self.secondPositiveLimitX && point.x >= self.secondNegativeLimitX) {
        x = self.secondNegativeLimitX;
        width = self.secondPositiveLimitX - self.secondNegativeLimitX;
    } else if (self.secondNegativeLimitValue >= 0 && point.x <= self.secondPositiveLimitX && point.x >= self.secondZeroX) {
        x = self.secondZeroX;
        width = self.secondPositiveLimitX - self.secondZeroX;
    }
    
    [CATransaction begin];
    
    [CATransaction setDisableActions:YES];
    self.touchSelectedLine.frame = CGRectMake(x, point.y, width, 1);
    [CATransaction commit];
    
    [self.toastView show:message location:point];
}

- (void)hideTouchMessage {
    [self.toastView hide];
    
    self.touchSelectedLine.hidden = YES;
}


#pragma mark - override

- (void)clearChartContent {
    [super clearChartContent];
    
    [self.levelBarModels removeAllObjects];
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            [obj removeFromSuperview];
        }
    }];
}

- (BOOL)drawXAxisLabels {
    if (self.xAxisLabelDatas.count < 2) {
        DTLog(@"Error: x轴标签数量小于2");
        return NO;
    }
    
    CGFloat titleTotalWidth = 0;
    for (NSNumber *width in self.titleWidths) {
        titleTotalWidth += width.floatValue + DimensionLabelGap;
    }
    
    NSUInteger yLabelContentCellCount = (NSUInteger) (titleTotalWidth / self.coordinateAxisCellWidth);
    NSUInteger barContentCellCount = self.xAxisCellCount - yLabelContentCellCount;   ///< 柱状体最大的空间
    
    if (self.secondData) {
        barContentCellCount /= 2;
    }
    if (self.mainNotation.length > 0) {
        self.mainTitleLabel.text = [NSString stringWithFormat:@"%@(%@)", self.mainData.title, self.mainNotation];
    } else {
        self.mainTitleLabel.text = self.mainData.title;
    }
    
    self.mainTitleLabel.frame = CGRectMake((self.coordinateAxisInsets.left + yLabelContentCellCount) * self.coordinateAxisCellWidth,
                                           CGRectGetMaxY(self.bounds) - self.coordinateAxisCellWidth, barContentCellCount * self.coordinateAxisCellWidth, self.coordinateAxisCellWidth);
    
    NSUInteger sectionCellCount = barContentCellCount / (self.xAxisLabelDatas.count - 1);
    
    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i;
        
        DTChartLabel *xLabel = [DTChartLabel chartLabel];
        xLabel.font = [UIFont systemFontOfSize:_fontSize];
        if (self.secondData) {
            xLabel.textColor = MainBarColor;
        }
        
        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.text = data.title;
        
        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: xLabel.font}];
        
        CGFloat x = (yLabelContentCellCount + self.coordinateAxisInsets.left + data.axisPosition) * self.coordinateAxisCellWidth;
        CGFloat y = CGRectGetMaxY(self.bounds) - self.coordinateAxisInsets.bottom * self.coordinateAxisCellWidth;
        
        y += (self.coordinateAxisCellWidth - size.height) / 2;
        
        if (i == 0) {
            if (data.value < 0) {
                self.mainNegativeLimitX = x;
                self.mainNegativeLimitValue = data.value;
            } else {
                self.mainNegativeLimitX = 0;
                self.mainNegativeLimitValue = 0;
            }
        }
        
        if (data.value == 0) {
            self.mainZeroX = x;
            if (self.mainNegativeLimitValue == 0) {
                self.mainNegativeLimitX = self.mainZeroX;
            }
        }
        
        if (i == self.xAxisLabelDatas.count - 1) {
            self.mainPositiveLimitX = x;
            self.mainPositiveLimitValue = data.value;
        }
        
        if (i == self.xAxisLabelDatas.count - 1) {
            x -= (size.width + 5);
        } else {
            x -= size.width / 2;
        }
        
        if (self.isThumbMode) {
            if (x < 0) {
                xLabel.frame = (CGRect) {CGPointMake(0, y), size};
            } else if (x + size.width > CGRectGetMaxX(self.bounds)) {
                xLabel.frame = (CGRect) {CGPointMake(CGRectGetMaxX(self.bounds) - size.width, y), size};
            } else {
                xLabel.frame = (CGRect) {CGPointMake(x, y), size};
            }
        } else {
            xLabel.frame = (CGRect) {CGPointMake(x, y), size};
        }
        
        xLabel.hidden = data.hidden;
        
        [self addSubview:xLabel];
    }
    
    return YES;
}

- (BOOL)drawYAxisLabels {
    return YES;
}

- (void)drawValues {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGFloat delta = (CGRectGetHeight(self.contentView.bounds) - self.mainData.listDimensions.count * self.tableView.rowHeight) / 2;
        if (delta > 0) {
            NSUInteger cellNum = (NSUInteger) (delta / self.coordinateAxisCellWidth);
            delta = self.coordinateAxisCellWidth * cellNum;
            self.tableView.frame = CGRectMake(0, delta, CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds) - delta);
            self.tableView.scrollEnabled = NO;
        } else {
            self.tableView.frame = self.contentView.bounds;
            self.tableView.scrollEnabled = YES;
        }
        [self.tableView reloadData];
    });
    
}

- (void)drawChart {
    
}

- (void)drawChart:(NSArray<DTDimensionBarModel *> *)itemBarInfos {
    
    [self clearChartContent];
    
    if (itemBarInfos.count > 0) {
        [self.levelBarModels addObjectsFromArray:itemBarInfos];
    }
    
    if (self.preProcessBarInfo) {
        
        [self.levelBarModels enumerateObjectsUsingBlock:^(DTDimensionBarModel *obj, NSUInteger idx, BOOL *stop) {
            obj.selected = NO;
        }];
        
        if (self.mainData) {
            NSArray *roots = self.mainData.listDimensions.firstObject.roots;
            self.titleWidths = [NSMutableArray arrayWithCapacity:roots.count];
            for (NSUInteger idx = 0; idx < roots.count; ++idx) {
                [self.titleWidths addObject:@0];
            }
            
            for (DTDimension2Model *items in self.mainData.listDimensions) {
                for (NSUInteger idx = 0; idx < items.roots.count; ++idx) {
                    DTDimension2Item *rootItem = items.roots[idx];
                    
                    CGRect bounding = [rootItem.name boundingRectWithSize:CGSizeMake(0, self.coordinateAxisCellWidth)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_fontSize]}
                                                                  context:nil];
                    
                    if (CGRectGetWidth(bounding) > self.titleWidths[idx].floatValue) {
                        self.titleWidths[idx] = @(MIN(DimensionLabelWidth, CGRectGetWidth(bounding)));  // 和上限值比较
                    }
                }
                
                if (self.chartStyle == DTDimensionBarStyleHeap) {
                    for (DTDimension2Item *item in items.items) {
                        [self chartCellRequestItemColor:item isMainAxis:YES];
                    }
                }
            }
        }
        if (self.secondData) {
            for (DTDimension2Model *items in self.secondData.listDimensions) {
                
                if (self.chartStyle == DTDimensionBarStyleHeap) {
                    for (DTDimension2Item *item in items.items) {
                        [self chartCellRequestItemColor:item isMainAxis:NO];
                    }
                }
            }
        }
        
        // 修正titleWidth
        for (NSUInteger idx = 0; idx < self.titleWidths.count; ++idx) {
            CGFloat width = self.titleWidths[idx].floatValue + DimensionLabelGap;
            NSInteger mod = (NSInteger) (width / self.coordinateAxisCellWidth);
            if (mod * self.coordinateAxisCellWidth < width) {
                mod++;
            }
            
            self.titleWidths[idx] = @(mod * self.coordinateAxisCellWidth - DimensionLabelGap);
        }
        
        
        if (self.chartStyle == DTDimensionBarStyleHeap) {
            // 移除当前数据没有的item
            for (NSInteger i = self.levelBarModels.count - 1; i >= 0; --i) {
                DTDimensionBarModel *barModel = self.levelBarModels[(NSUInteger) i];
                if (!barModel.selected) {
                    [self.levelBarModels removeObject:barModel];
                }
            }
            
            if (self.itemColorBlock) {
                self.itemColorBlock(self.levelBarModels.copy);
            }
        }
        
    } else {
        NSArray *roots = self.mainData.listDimensions.firstObject.roots;
        if (self.titleWidths.count < roots.count) {
            self.titleWidths = [NSMutableArray arrayWithCapacity:roots.count];
            for (NSUInteger idx = 0; idx < roots.count; ++idx) {
                [self.titleWidths addObject:@(DimensionLabelWidth)];
            }
        }
    }
    
    
    self.prepare = YES;
    
    if (self.secondData) {
        self.mainTitleLabel.hidden = NO;
        self.mainTitleLabel.textColor = MainBarColor;
        
        self.secondTitleLabel.hidden = NO;
        [self drawSecondChart];
    } else {
        self.mainTitleLabel.hidden = NO;
        self.mainTitleLabel.textColor = [UIColor whiteColor];
        
        self.secondTitleLabel.hidden = YES;
    }
    
    if ([self drawXAxisLabels] && [self drawYAxisLabels]) {
        [self drawValues];
    }
}

- (BOOL)drawXSecondAxisLabels {
    if (self.xSecondAxisLabelDatas.count < 2) {
        DTLog(@"Error: x轴标签数量小于2");
        return NO;
    }
    
    CGFloat titleTotalWidth = 0;
    for (NSNumber *width in self.titleWidths) {
        titleTotalWidth += width.floatValue + DimensionLabelGap;
    }
    
    NSUInteger yLabelContentCellCount = (NSUInteger) (titleTotalWidth / self.coordinateAxisCellWidth);
    NSUInteger barContentCellCount = self.xAxisCellCount - yLabelContentCellCount;   ///< 柱状体最大的空间
    
    barContentCellCount /= 2;
    
    self.secondTitleLabel.frame = CGRectMake((self.coordinateAxisInsets.left + yLabelContentCellCount + barContentCellCount) * self.coordinateAxisCellWidth,
                                             CGRectGetMaxY(self.bounds) - self.coordinateAxisCellWidth, barContentCellCount * self.coordinateAxisCellWidth, self.coordinateAxisCellWidth);
    
    if (self.secondNotation.length > 0) {
        self.secondTitleLabel.text = [NSString stringWithFormat:@"%@(%@)", self.secondData.title, self.secondNotation];
    } else {
        self.secondTitleLabel.text = self.secondData.title;
    }
    
    NSUInteger sectionCellCount = barContentCellCount / (self.xSecondAxisLabelDatas.count - 1);
    
    for (NSUInteger i = 0; i < self.xSecondAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xSecondAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i;
        
        DTChartLabel *xLabel = [DTChartLabel chartLabel];
        xLabel.font = [UIFont systemFontOfSize:_fontSize];
        xLabel.textColor = SecondBarColor;
        
        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.text = data.title;
        
        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: xLabel.font}];
        
        CGFloat x = (yLabelContentCellCount + barContentCellCount + self.coordinateAxisInsets.left + data.axisPosition) * self.coordinateAxisCellWidth;
        CGFloat y = CGRectGetMaxY(self.bounds) - self.coordinateAxisInsets.bottom * self.coordinateAxisCellWidth;
        
        y += (self.coordinateAxisCellWidth - size.height) / 2;
        
        if (i == 0) {
            if (data.value < 0) {
                self.secondNegativeLimitX = x;
                self.secondNegativeLimitValue = data.value;
            } else {
                self.secondNegativeLimitX = 0;
                self.secondNegativeLimitValue = 0;
            }
        }
        
        if (data.value == 0) {
            self.secondZeroX = x;
            if (self.secondNegativeLimitValue == 0) {
                self.secondNegativeLimitX = self.secondZeroX;
            }
        }
        
        if (i == self.xSecondAxisLabelDatas.count - 1) {
            self.secondPositiveLimitX = x;
            self.secondPositiveLimitValue = data.value;
        }
        
        if (i == 0) {
            x += 5;
        } else {
            x -= size.width / 2;
        }
        
        if (self.isThumbMode) {
            if (x < 0) {
                xLabel.frame = (CGRect) {CGPointMake(0, y), size};
            } else if (x + size.width > CGRectGetMaxX(self.bounds)) {
                xLabel.frame = (CGRect) {CGPointMake(CGRectGetMaxX(self.bounds) - size.width, y), size};
            } else {
                xLabel.frame = (CGRect) {CGPointMake(x, y), size};
            }
        } else {
            xLabel.frame = (CGRect) {CGPointMake(x, y), size};
        }
        
        xLabel.hidden = data.hidden;
        
        [self addSubview:xLabel];
    }
    
    return YES;
}

- (BOOL)drawYSecondAxisLabels {
    return YES;
}

- (void)drawSecondValues {
}

- (void)drawSecondChart {
    [self drawXSecondAxisLabels];
}


#pragma mark - DTDimensionBarChartCellDelegate

- (void)chartCellHintTouchBegin:(DTDimensionBarChartCell *)cell labelIndex:(NSUInteger)index touch:(UITouch *)touch {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *message = nil;
    if (self.touchLabelBlock) {
        DTDimension2Model *data = self.mainData.listDimensions[(NSUInteger) indexPath.row];
        message = self.touchLabelBlock(self.chartStyle, (NSUInteger) indexPath.row, data, index);
    }
    
    if (message.length == 0) {
        message = self.mainData.listDimensions[(NSUInteger) indexPath.row].roots[index].name;
    }
    
    CGPoint cellTouchPoint = [touch locationInView:cell];
    CGFloat deltaY = CGRectGetMidY(cell.bounds) / 2 - cellTouchPoint.y;
    CGPoint location = [touch locationInView:self.tableView];
    location.y = location.y + self.tableView.frame.origin.y - self.tableView.contentOffset.y + deltaY;
    
    [self showTouchMessage:message touchPoint:location];
}

- (void)chartCellHintTouchBegin:(DTDimensionBarChartCell *)cell isMainAxisBar:(BOOL)isMain data:(DTDimension2Item *)touchData touch:(UITouch *)touch {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableString *message = [NSMutableString string];
    
    if (self.touchBarBlock) {
        
        if (self.chartStyle == DTDimensionBarStyleStartLine && !touchData) {    // 该模式下，不需要准确的触摸到Bar的frame里，返回该bar对应的数据
            if (isMain) {
                touchData = self.mainData.listDimensions[(NSUInteger) indexPath.row].items.firstObject;
            } else {
                touchData = self.secondData.listDimensions[(NSUInteger) indexPath.row].items.firstObject;
            }
        }
        
        
        NSArray<DTDimension2Item *> *allSubData = nil;
        if (isMain) {
            allSubData = self.mainData.listDimensions[(NSUInteger) indexPath.row].items;
        } else {
            allSubData = self.secondData.listDimensions[(NSUInteger) indexPath.row].items;
        }
        
        NSString *string = self.touchBarBlock(self.chartStyle, (NSUInteger) indexPath.row, touchData, allSubData, isMain);
        
        if (string.length > 0) {
            [message appendString:string];
        }
    }
    
    if (message.length == 0) {
        if (self.chartStyle == DTDimensionBarStyleStartLine) {  // 该模式下，不需要准确的触摸到Bar的frame里
            NSArray<DTDimension2Item *> *items = nil;
            if (isMain) {
                items = self.mainData.listDimensions[(NSUInteger) indexPath.row].items;
            } else {
                items = self.secondData.listDimensions[(NSUInteger) indexPath.row].items;
            }
            
            for (DTDimension2Item *item in items) {
                [message appendString:[NSString stringWithFormat:@"%@: %@", item.name, @(item.value)]];
                if (item != items.lastObject) {
                    [message appendString:@"\n"];
                }
            }
            
        } else if (touchData) {
            [message appendString:[NSString stringWithFormat:@"%@: %@", touchData.name, @(touchData.value)]];
        }
    }
    
    CGPoint cellTouchPoint = [touch locationInView:cell];
    CGFloat deltaY = CGRectGetMidY(cell.bounds) / 2 - cellTouchPoint.y;
    CGPoint location = [touch locationInView:self.tableView];
    location.y = location.y + self.tableView.frame.origin.y - self.tableView.contentOffset.y + deltaY;
    
    if (message.length > 0) {
        [self showTouchMessage:message touchPoint:location];
    }
}

- (void)chartCellHintTouchEnd {
    
    [self hideTouchMessage];
}

- (void)chartCellLongPress:(DTDimensionBarChartCell *)cell data:(DTDimension2Model *)data gesture:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan: {
            
            UIView *v = longPress.view;
            NSUInteger dimensionIndex = v.tag - LabelIndexTagPrefix;
            NSString *title = data.roots[dimensionIndex].name;
            
            CGPoint touchPoint = [longPress locationInView:self];
            
            CGPoint origin = [cell convertPoint:v.frame.origin toView:nil];
            CGRect frame = (CGRect) {origin, v.frame.size};
            _fakeView.frame = frame;
            
            _canSwipe = CGPointZero;
            if (self.chartCellLongPressBeginBlock) {
                _canSwipe = self.chartCellLongPressBeginBlock(_fakeView, title, dimensionIndex);
            }
            
            if (CGPointEqualToPoint(_canSwipe, CGPointZero)) {
                return;
            }
            
            
            UIGraphicsBeginImageContextWithOptions(v.bounds.size, NO, [UIScreen mainScreen].scale + 1);
            [v drawViewHierarchyInRect:v.bounds afterScreenUpdates:YES];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            _fakeView.image = image;
            
            
            v.hidden = YES;
            _originCenter = _fakeView.center;
            _panTranslate = touchPoint;
            
            CGSize size = v.frame.size;
            size.width *= 1.5f;
            size.height *= 1.5f;
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _fakeView.frame = CGRectMake(CGRectGetMinX(frame) - (size.width - CGRectGetWidth(v.frame)) / 2, CGRectGetMinY(frame) - (size.height - CGRectGetHeight(v.frame)) / 2, size.width, size.height);
                _fakeView.layer.shadowOpacity = 1;
            }                completion:nil];
            
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            if (CGPointEqualToPoint(_canSwipe, CGPointZero)) {
                return;
            }
            CGPoint touchPoint = [longPress locationInView:self];
            
            CGFloat deltaX = (CGFloat) (30.f * atan((touchPoint.x - _panTranslate.x) / 15));
            if (_canSwipe.x == 0 && deltaX < 0) {   ///< 无法左滑
                return;
            }
            if (_canSwipe.y == 0 && deltaX > 0) {   ///< 无法右滑
                return;
            }
            _fakeView.center = CGPointMake(_originCenter.x + deltaX, _originCenter.y);
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (CGPointEqualToPoint(_canSwipe, CGPointZero)) {
                return;
            }
            
            _canSwipe = CGPointZero;
            
            // 返回指定位置
            UIView *v = longPress.view;
            NSUInteger dimensionIndex = v.tag - LabelIndexTagPrefix;
            NSString *title = data.roots[dimensionIndex].name;
            
            CGPoint origin = [cell convertPoint:v.frame.origin toView:nil];
            
            CGFloat deltaX = _fakeView.center.x - _originCenter.x;
            BOOL isSwipe = fabs(deltaX) >= 30;
            BOOL isLeft = deltaX < 0;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _fakeView.frame = (CGRect) {origin, v.frame.size};
                _fakeView.layer.shadowOpacity = 0;
            }                completion:^(BOOL finish) {
                v.hidden = NO;
                
                if (self.chartCellLongPressEndBlock) {
                    self.chartCellLongPressEndBlock(_fakeView, isSwipe, isLeft, title, dimensionIndex);
                }
            }];
        }
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}

- (UIColor *)chartCellRequestItemColor:(id)data isMainAxis:(BOOL)isMain {
    UIColor *color = nil;
    if (self.chartStyle == DTDimensionBarStyleStartLine) {  ///< 模式1
        if (isMain) {
            color = MainBarColor;
        } else {
            color = SecondBarColor;
        }
        return color;
    }
    
    // 模式2
    
    if ([data isKindOfClass:[DTDimension2Item class]]) {
        DTDimension2Item *item = data;
        
        BOOL exist = NO;
        
        for (DTDimensionBarModel *model in self.levelBarModels) {
            if ([model.title isEqualToString:item.name]) {
                
                color = model.color;
                exist = YES;
                model.selected = YES;
                break;
            }
        }
        
        if (!exist) {
            color = [self.colorManager getColor];
            DTDimensionBarModel *model = [[DTDimensionBarModel alloc] init];
            model.color = color;
            model.title = item.name;
            model.selected = YES;
            [self.levelBarModels addObject:model];
            
            if (!self.preProcessBarInfo && self.itemColorBlock) {
                self.itemColorBlock(@[model]);
            }
        }
    }
    return color;
}

@end

