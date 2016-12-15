//
//  DTLineChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTLineChart.h"
#import "DTChartLabel.h"
#import "DTChartData.h"
#import "DTLine.h"

@interface DTLineChart ()

@property(nonatomic) NSMutableArray<DTLine *> *valueLines;

@property(nonatomic) NSArray<UIColor *> *colors;

@end

@implementation DTLineChart

- (void)initial {
    [super initial];

    _colors = @[[UIColor orangeColor], [UIColor lightGrayColor], [UIColor grayColor], [UIColor yellowColor], [UIColor redColor], [UIColor magentaColor]];
}

- (NSMutableArray<DTLine *> *)valueLines {
    if (!_valueLines) {
        _valueLines = [[NSMutableArray<DTLine *> alloc] init];
    }
    return _valueLines;
}

#pragma mark - method

/**
 * 清除坐标系里的轴标签和值线条
 */
- (void)clearChartContent {

    NSArray<CALayer *> *layers = [self.contentView.layer.sublayers copy];
    [layers enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTLine class]]) {
            DTLine *line = (DTLine *) obj;
            [line removeEdgePoint];
            [line removeFromSuperlayer];
        }
    }];

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DTChartLabel class]]) {
            [obj removeFromSuperview];
        }
    }];
}

/**
 * 绘制坐标轴线
 */
- (void)drawAxisLine {

}

- (void)drawXAxisLabels {
    // 第一个单元格空余出来
    NSUInteger sectionCellCount = (self.xAxisCellCount - 1) / (self.xAxisLabelDatas.count + 1);


    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];

        // 每个label位于section内最后一个单元格线上，所有label在x轴上整体居中
        data.axisPosition = sectionCellCount * i + sectionCellCount + 1 + (self.xAxisCellCount - 1 - (self.xAxisLabelDatas.count + 1) * sectionCellCount) / 2;


        DTChartLabel *xLabel = [DTChartLabel chartLabel];
        if (self.xAxisLabelColor) {
            xLabel.textColor = self.xAxisLabelColor;
        }
        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.text = data.title;

        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: xLabel.font}];

        CGFloat x = (self.coordinateAxisInsets.left + data.axisPosition) * self.coordinateAxisCellWidth - size.width / 2;
        CGFloat y = CGRectGetMaxY(self.contentView.frame);
        if (size.height < self.coordinateAxisCellWidth) {
            y += (self.coordinateAxisCellWidth - size.height) / 2;
        }


        xLabel.frame = (CGRect) {CGPointMake(x, y), size};


        [self addSubview:xLabel];
    }

}

- (void)drawYAxisLabels {

    NSUInteger sectionCellCount = self.yAxisCellCount / (self.yAxisLabelDatas.count - 1);


    for (NSUInteger i = 0; i < self.yAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.yAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i;

        DTChartLabel *yLabel = [DTChartLabel chartLabel];
        if (self.yAxisLabelColor) {
            yLabel.textColor = self.yAxisLabelColor;
        }

        yLabel.textAlignment = NSTextAlignmentRight;
        yLabel.text = data.title;

        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: yLabel.font}];

        CGFloat x = CGRectGetMinX(self.contentView.frame) - size.width;
        CGFloat y = (self.coordinateAxisInsets.top + self.yAxisCellCount - data.axisPosition) * self.coordinateAxisCellWidth - size.height / 2;


        yLabel.frame = (CGRect) {CGPointMake(x, y), size};


        [self addSubview:yLabel];
    }

}

- (void)drawValues {

    [self.valueLines removeAllObjects];

    if (!self.multiValues && self.values) {
        self.multiValues = @[self.values];
    }

    DTAxisLabelData *yMaxData = self.yAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.yAxisLabelDatas.firstObject;

    for (NSUInteger n = 0; n < self.multiValues.count; ++n) {
        NSArray<DTChartItemData *> *itemValues = self.multiValues[n];


        UIBezierPath *path = nil;

        for (NSUInteger i = 0; i < itemValues.count; ++i) {
            DTChartItemData *itemData = itemValues[i];

            for (NSUInteger j = 0; j < self.xAxisLabelDatas.count; ++j) {
                DTAxisLabelData *xData = self.xAxisLabelDatas[j];

                if (xData.value == itemData.itemValue.x) {

                    NSLog(@"item = %@", NSStringFromChartItemValue(itemData.itemValue));


                    CGFloat x = xData.axisPosition * self.coordinateAxisCellWidth;
                    CGFloat y = self.coordinateAxisCellWidth * (self.yAxisCellCount - ((itemData.itemValue.y - yMinData.value) / (yMaxData.value - yMinData.value)) * yMaxData.axisPosition);
                    itemData.position = CGPointMake(x, y);

                    if (path) {
                        [path addLineToPoint:itemData.position];
                    } else {
                        path = [UIBezierPath bezierPath];
                        [path moveToPoint:itemData.position];
                    }


                    break;
                }
            }
        }

        if (path) {
            UIColor *color = self.colors[n % self.colors.count];
            DTLine *line = [DTLine line:DTLinePointTypeCircle];
            line.lineColor = color;
            line.values = itemValues;
            line.linePath = path;
            [self.valueLines addObject:line];
            [self.contentView.layer addSublayer:line];
            [line drawEdgePoint];
        }


        if (self.isShowAnimation) {
            [self startAppearAnimation];
        }

    }
}

- (void)startAppearAnimation {
    for (NSUInteger i = 0; i < self.valueLines.count; ++i) {
        DTLine *line = self.valueLines[i];
        [line startAppearAnimation];
    }
}

- (void)drawChart {

    [super drawChart];

    [self clearChartContent];

    [self drawAxisLine];

    [self drawXAxisLabels];
    [self drawYAxisLabels];

    [self drawValues];
}


@end
