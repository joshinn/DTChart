//
//  DTHorizontalBarChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/9.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTHorizontalBarChart.h"
#import "DTChartLabel.h"
#import "DTChartData.h"


@implementation DTHorizontalBarChart

@synthesize barStyle = _barStyle;


- (void)initial {
    [super initial];

    _barStyle = DTBarStyleTopBorder;
}


#pragma mark - override

- (void)drawXAxisLabels {
    if(self.xAxisLabelDatas.count <= 1){
        DTLog(@"Error: x轴标签数量小于2个");
        return;
    }

    NSUInteger sectionCellCount = self.xAxisCellCount / (self.xAxisLabelDatas.count - 1);


    for (NSUInteger i = 0; i < self.xAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.xAxisLabelDatas[i];
        data.axisPosition = sectionCellCount * i;

        DTChartLabel *xLabel = [DTChartLabel chartLabel];
        if (self.xAxisLabelColor) {
            xLabel.textColor = self.xAxisLabelColor;
        }
        xLabel.textAlignment = NSTextAlignmentCenter;
        xLabel.text = data.title;

        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: xLabel.font}];

        CGFloat x = (self.coordinateAxisInsets.left + data.axisPosition) * self.coordinateAxisCellWidth - size.height / 2;
        CGFloat y = CGRectGetMaxY(self.contentView.frame);
        if (size.height < self.coordinateAxisCellWidth) {
            y += (self.coordinateAxisCellWidth - size.height) / 2;
        }


        xLabel.frame = (CGRect) {CGPointMake(x, y), size};


        [self addSubview:xLabel];
    }


}

- (void)drawYAxisLabels {
    if(self.yAxisLabelDatas.count == 0){
        DTLog(@"Error: y轴标签数量是0");
        return;
    }

    NSUInteger sectionCellCount = self.yAxisCellCount / self.yAxisLabelDatas.count;

    if (sectionCellCount > 1) {
        self.barStyle = DTBarStyleTopBorder;
    } else {
        self.barStyle = DTBarStyleSidesBorder;
    }

    for (NSUInteger i = 0; i < self.yAxisLabelDatas.count; ++i) {
        DTAxisLabelData *data = self.yAxisLabelDatas[i];
        if (sectionCellCount == 1) {
            // 如果单个区间长度只有1的话，则所有的柱状体在坐标轴上整体居中
            // 坐标系原点在左下角
            data.axisPosition = self.yAxisCellCount - 1 - i * sectionCellCount - (self.yAxisCellCount - self.yAxisLabelDatas.count) / 2;
        } else {
            // 单个区间长度大于1，则柱状体在区间中间位置
            // 坐标系原点在左下角
            data.axisPosition = self.yAxisCellCount - 1 - sectionCellCount * (i + 1) + sectionCellCount / 2 - (self.yAxisCellCount - self.yAxisLabelDatas.count * sectionCellCount) / 2;
        }

        DTChartLabel *yLabel = [DTChartLabel chartLabel];
        if (self.yAxisLabelColor) {
            yLabel.textColor = self.yAxisLabelColor;
        }
        yLabel.textAlignment = NSTextAlignmentRight;
        yLabel.text = data.title;

        CGSize size = [data.title sizeWithAttributes:@{NSFontAttributeName: yLabel.font}];

        CGFloat x = CGRectGetMinX(self.contentView.frame) - size.width;

        CGFloat y = (self.coordinateAxisInsets.top + data.axisPosition + 0.5f) * self.coordinateAxisCellWidth;
        y -= size.height / 2;

        yLabel.frame = (CGRect) {CGPointMake(x, y), size};


        [self addSubview:yLabel];
    }

}


- (void)drawValues {


    DTAxisLabelData *xMaxData = self.xAxisLabelDatas.lastObject;
    DTAxisLabelData *xMinData = self.xAxisLabelDatas.firstObject;

    for (NSUInteger i = 0; i < self.values.count; ++i) {
        DTChartItemData *itemData = self.values[i];

        for (NSUInteger j = 0; j < self.yAxisLabelDatas.count; ++j) {
            DTAxisLabelData *yData = self.yAxisLabelDatas[j];

            if (yData.value == itemData.itemValue.y) {

                DTBar *bar = [DTBar bar:DTBarOrientationRight style:self.barStyle];
                bar.barData = itemData;
                bar.delegate = self;
                bar.userInteractionEnabled = self.isBarSelectable;
                if (self.barColor) {
                    bar.barColor = self.barColor;
                }
                if (self.barBorderColor) {
                    bar.barBorderColor = self.barBorderColor;
                }

                CGFloat height = self.coordinateAxisCellWidth * self.barWidth;
                CGFloat width = self.coordinateAxisCellWidth * ((itemData.itemValue.x - xMinData.value) / (xMaxData.value - xMinData.value)) * xMaxData.axisPosition;
                CGFloat x = 0;
                CGFloat y = yData.axisPosition * self.coordinateAxisCellWidth + (self.coordinateAxisCellWidth - height) / 2;

                DTLog(@"y = %f title = %@, width = %.2f", yData.axisPosition, yData.title, width);

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

}


@end
