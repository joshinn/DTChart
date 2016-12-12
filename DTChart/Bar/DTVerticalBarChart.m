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
    NSUInteger sectionCellCount = self.xAxisCellCount / self.xAxisLabelDatas.count;

    if (sectionCellCount > 1) {
        self.barStyle = DTBarStyleTopBorder;
    } else {
        self.barStyle = DTBarStyleSidesBorder;
    }


    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];
        if (sectionCellCount == 1) {
            // 如果单个区间长度只有1的话，则所有的柱状体在坐标轴上整体居中
            // 坐标系原点在左下角
            data.axisPosition = i + (self.xAxisCellCount - self.xAxisLabelDatas.count) / 2;
        } else {
            // 单个区间长度大于1，则柱状体在区间中间位置
            // 坐标系原点在左下角
            data.axisPosition = sectionCellCount * (i + 1) - sectionCellCount / 2;
        }


        DTChartLabel *xLabel = [DTChartLabel chartLabel];
        xLabel.textColor = [UIColor blackColor];
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

    NSUInteger sectionCellCount = self.yAxisCellCount / (self.yAxisLabelDatas.count - 1);


    for (NSUInteger i = 0; i < self.yAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.yAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i;

        DTChartLabel *yLabel = [DTChartLabel chartLabel];
        yLabel.textColor = [UIColor blackColor];
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

    for (NSUInteger i = 0; i < self.values.count; ++i) {
        DTChartItemData *itemData = self.values[i];

        for (NSUInteger j = 0; j < self.xAxisLabelDatas.count; ++j) {
            DTAxisLabelData *xData = self.xAxisLabelDatas[j];

            if (xData.value == itemData.itemValue.x) {

                DTBar *bar = [DTBar bar:DTBarOrientationUp style:self.barStyle];

                CGFloat width = self.coordinateAxisCellWidth * self.barWidth;
                CGFloat height = self.coordinateAxisCellWidth * ((itemData.itemValue.y - yMinData.value) / (yMaxData.value - yMinData.value)) * yMaxData.axisPosition;
                CGFloat x = xData.axisPosition * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - width) / 2;
                CGFloat y = CGRectGetHeight(self.contentView.frame) - height;

                NSLog(@"x = %f", xData.axisPosition);

                bar.frame = CGRectMake(x, y, width, height);
                bar.hidden = YES;
                [self.contentView addSubview:bar];

                if (self.showAnimation) {
                    [bar startAnimation];
                }

                break;
            }
        }
    }
}

- (void)drawChart {
    NSLog(@"#### begin draw");

    [super drawChart];

    NSLog(@"#### end draw");
}


@end
