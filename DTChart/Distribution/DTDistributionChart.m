//
//  DTDistributionChart.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/30.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTDistributionChart.h"

@implementation DTDistributionChart


- (void)initial {
    [super initial];

    self.coordinateAxisInsets = ChartEdgeInsetsMake(3, self.coordinateAxisInsets.top, self.coordinateAxisInsets.right, self.coordinateAxisInsets.bottom);
}




#pragma mark - override

/**
 * 清除坐标系里的轴标签和值线条
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
    if (self.yAxisLabelDatas.count < 2) {
        DTLog(@"Error: y轴标签数量小于2");
        return NO;
    }



    return YES;
}


- (void)drawValues {


}



@end
