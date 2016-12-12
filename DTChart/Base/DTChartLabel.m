//
//  DTChartLabel.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/8.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTChartLabel.h"

@implementation DTChartLabel

+ (instancetype)chartLabel {
    DTChartLabel *label = [[DTChartLabel alloc] init];
    return label;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initial];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont systemFontOfSize:9];
    self.textColor = [UIColor whiteColor];
    self.numberOfLines = 0;
    self.userInteractionEnabled = YES;
    self.adjustsFontSizeToFitWidth = YES;
}

@end
