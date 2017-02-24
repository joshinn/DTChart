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

+ (instancetype)randomManager {
    DTColorManager *colorManager = [[DTColorManager alloc] initWithRandom];
    return colorManager;
}

+ (instancetype)randomManagerExistColors:(NSArray<UIColor *> *)colors {
    DTColorManager *colorManager = [[DTColorManager alloc] initWithRandomExceptExistColors:colors];
    return colorManager;
}


- (instancetype)init {
    if (self = [super init]) {
        _colors = [DTColorArray mutableCopy];
    }
    return self;
}

- (instancetype)initWithRandom {
    if (self = [super init]) {
        NSMutableArray<UIColor *> *tempColors = [DTColorArray mutableCopy];
        _colors = [NSMutableArray array];
        while (tempColors.count > 0) {
            UIColor *color = tempColors[arc4random_uniform((uint32_t) tempColors.count)];
            [_colors addObject:color];
            [tempColors removeObject:color];
        }
    }
    return self;
}

- (instancetype)initWithRandomExceptExistColors:(NSArray<UIColor *> *)colors {
    if (self = [[DTColorManager alloc] initWithRandom]) {

        for (UIColor *color in colors) {

            for (NSUInteger i = 0; i < _colors.count; ++i) {
                UIColor *c = _colors[i];
                if ([color compareRGB:c]) {
                    [_colors removeObject:c];
                    [_colors addObject:c];
                    break;
                }
            }
        }
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
        if ([c compareRGB:color]) {
            lightColor = DTLightColorArray[i];
            break;
        }
    }

    return lightColor;
}

+ (UIColor *)getLightColor:(UIColor *)color {
    UIColor *lightColor = nil;
    for (NSUInteger i = 0; i < DTColorArray.count; ++i) {
        UIColor *c = DTColorArray[i];
        if ([c compareRGB:color]) {
            lightColor = DTLightColorArray[i];
            break;
        }
    }

    return lightColor;
}

@end
