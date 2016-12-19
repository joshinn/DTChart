//
//  DTVerticalBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/9.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTVerticalBarChart.h"
#import "DTChartLabel.h"
#import "DTChartData.h"

@interface DTVerticalBarChart ()


@end


@implementation DTVerticalBarChart

@synthesize barStyle = _barStyle;

- (void)initial {
    [super initial];

    _barStyle = DTBarStyleTopBorder;
}


#pragma mark - override

- (void)drawXAxisLabels {
    if (self.xAxisLabelDatas.count == 0) {
        DTLog(@"Error: x轴标签数量是0");
        return;
    }

    NSUInteger sectionCellCount = self.xAxisCellCount / self.xAxisLabelDatas.count;

    if (sectionCellCount > 1) {
        self.barStyle = DTBarStyleTopBorder;
    } else {
        self.barStyle = DTBarStyleSidesBorder;
    }


    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];

        // 相对于坐标轴内（contentView）位置
        // 所有的柱状体在坐标轴上整体居中
        // 坐标系原点在左下角
        data.axisPosition = sectionCellCount * i + (sectionCellCount - 1) / 2
                + (self.xAxisCellCount - self.xAxisLabelDatas.count * sectionCellCount) / 2;


        DTChartLabel *xLabel = [DTChartLabel chartLabel];
        if (self.xAxisLabelColor) {
            xLabel.textColor = self.xAxisLabelColor;
        }
        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.text = data.title;


        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: xLabel.font}];

        CGFloat x = (self.coordinateAxisInsets.left + data.axisPosition + 0.5f) * self.coordinateAxisCellWidth;
        x -= size.width / 2;
        CGFloat y = CGRectGetMaxY(self.contentView.frame);
        if (size.height < self.coordinateAxisCellWidth) {
            y += (self.coordinateAxisCellWidth - size.height) / 2;
        }

        xLabel.frame = (CGRect) {CGPointMake(x, y), size};

        [self addSubview:xLabel];
    }

}

- (void)drawYAxisLabels {
    if (self.yAxisLabelDatas.count <= 1) {
        DTLog(@"Error: y轴标签数量小于2个");
        return;
    }


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


    DTAxisLabelData *yMaxData = self.yAxisLabelDatas.lastObject;
    DTAxisLabelData *yMinData = self.yAxisLabelDatas.firstObject;

    for (NSUInteger i = 0; i < self.singleData.itemValues.count; ++i) {
        DTChartItemData *itemData = self.singleData.itemValues[i];

        for (NSUInteger j = 0; j < self.xAxisLabelDatas.count; ++j) {
            DTAxisLabelData *xData = self.xAxisLabelDatas[j];

            if (xData.value == itemData.itemValue.x) {

                DTBar *bar = [DTBar bar:DTBarOrientationUp style:self.barStyle];
                bar.barData = itemData;
                bar.delegate = self;
                bar.userInteractionEnabled = self.isBarSelectable;
                if (self.barColor) {
                    bar.barColor = self.barColor;
                }
                if (self.barBorderColor) {
                    bar.barBorderColor = self.barBorderColor;
                }

                CGFloat width = self.coordinateAxisCellWidth * self.barWidth;
                CGFloat height = self.coordinateAxisCellWidth * ((itemData.itemValue.y - yMinData.value) / (yMaxData.value - yMinData.value)) * yMaxData.axisPosition;
                CGFloat x = xData.axisPosition * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - width) / 2;
                CGFloat y = CGRectGetHeight(self.contentView.frame) - height;

                DTLog(@"x = %f", xData.axisPosition);

                bar.frame = CGRectMake(x, y, width, height);
                [self.contentView addSubview:bar];

                if (self.isShowAnimation) {
                    [bar startAppearAnimation];
                }

                break;
            }
        }
    }
}

- (void)drawChart {
    DTLog(@"#### begin draw");

    [super drawChart];

    DTLog(@"#### end draw");
}


#pragma mark - DTBarDelegate

- (void)dTBarSelected:(DTBar *)bar {
    DTLog(@"%@", NSStringFromChartItemValue(bar.barData.itemValue));
}

@end
