//
//  DTChartController.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTChartController.h"
#import "DTCommonData.h"

@interface DTChartController ()


@end

@implementation DTChartController

- (instancetype)initWithOrigin:(CGPoint)origin xAxis:(NSUInteger)xCount yAxis:(NSUInteger)yCount {
    if (self = [super init]) {
        _chartMode = DTChartModeThumb;
    }
    return self;
}

- (void)initial {

}

#pragma mark - public method

- (void)addItem:(NSString *)itemId seriesName:(NSString *)seriesName values:(NSArray<DTCommonData *> *)values {

}

-(void)drawChart{

}

@end
