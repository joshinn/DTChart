//
//  DTColorManager.m
//  DTiseChart
//
//  Created by Jo Shin on 2016/12/23.
//  Copyright © 2016年 studio.joshin. All rights reserved.
//

#import "DTColorManager.h"
#import "DTColor.h"
#import "UIColor+DTExternal.h"

@interface DTColorManager ()

@property(nonatomic) NSMutableArray<UIColor *> *colors;

@end


@implementation DTColorManager

+ (instancetype)manager {
    DTColorManager *colorManager = [[DTColorManager alloc] init];
    return colorManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _colors = [DTColorArray mutableCopy];
    }
    return self;
}


- (UIColor *)getColor {
    UIColor *color = self.colors.firstObject;
    [self.colors removeObjectAtIndex:0];
    [self.colors addObject:color];
    return color;
}

- (UIColor *)getLightColor:(UIColor *)color {
    UIColor *lightColor = nil;
    for (NSUInteger i = 0; i < DTColorArray.count; ++i) {
        UIColor *c = DTColorArray[i];
        if ([c compare:color]) {
            lightColor = DTLightColorArray[i];
            break;
        }
    }

    return lightColor;
}

@end