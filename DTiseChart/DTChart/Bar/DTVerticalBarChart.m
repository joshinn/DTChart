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
#import "DTBar.h"

NSUInteger const DefaultVerticalBarMaxCount = 10;


@implementation DTVerticalBarChart

@synthesize barMaxCount = _barMaxCount;

- (void)initial {
    [super initial];

    _barMaxCount = DefaultVerticalBarMaxCount;
}

- (void)setBarMaxCount:(NSUInteger)barMaxCount {
    _barMaxCount = barMaxCount;
}


#pragma mark - override

- (void)drawXAxisLabels {
    NSUInteger sectionCellCount = self.xAxisCellCount / self.xAxisLabelDatas.count;


    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * (i + 1) - 1;

        DTChartLabel *xLabel = [DTChartLabel chartLabel];
        xLabel.textColor = [UIColor blackColor];
        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.text = data.title;


        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: xLabel.font}];

        CGFloat x = (self.coordinateAxisInsets.left + sectionCellCount * (i + 1) - 0.5f) * self.coordinateAxisCellWidth;
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
        data.axisPosition = sectionCellCount * i + 1;

        DTChartLabel *yLabel = [DTChartLabel chartLabel];
        yLabel.textColor = [UIColor blackColor];
        yLabel.textAlignment = NSTextAlignmentRight;
        yLabel.text = data.title;

        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: yLabel.font}];

        CGFloat x = CGRectGetMinX(self.contentView.frame) - size.width;
        CGFloat y = (self.coordinateAxisInsets.top + self.yAxisCellCount - sectionCellCount * i) * self.coordinateAxisCellWidth - size.height / 2;


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


                DTBar *bar = [DTBar bar];
                bar.backgroundColor = [UIColor orangeColor];

                CGFloat width = self.coordinateAxisCellWidth * self.barWidth;
                CGFloat height = self.coordinateAxisCellWidth * ((itemData.itemValue.y - yMinData.value) / (yMaxData.value - yMinData.value)) * (yMaxData.axisPosition - 1);
                CGFloat x = xData.axisPosition * self.coordinateAxisCellWidth;
                CGFloat y = CGRectGetHeight(self.contentView.frame) - height;


                bar.frame = CGRectMake(x, y, width, height);
                [self.contentView addSubview:bar];

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
