//
//  DTDimensionHeapBar.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/3/7.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimensionHeapBar.h"

@interface DTDimensionHeapBar ()

@property(nonatomic) NSMutableArray<DTDimensionModel *> *heapData;
@property(nonatomic) NSMutableArray<NSNumber *> *subBarLength;
@property(nonatomic) NSMutableArray<UIColor *> *subBarColors;

@property(nonatomic) NSArray<DTDimensionModel *> *itemDatas;

@end

@implementation DTDimensionHeapBar

+ (instancetype)heapBar:(DTBarOrientation)orientation {
    DTDimensionHeapBar *bar = [[DTDimensionHeapBar alloc] init];
    bar.barOrientation = orientation;
    bar.barBorderStyle = DTBarBorderStyleNone;
    return bar;
}

#pragma mark - delay init

- (NSMutableArray<DTDimensionModel *> *)heapData {
    if (!_heapData) {
        _heapData = [NSMutableArray<DTDimensionModel *> array];
    }
    return _heapData;
}

- (NSMutableArray<NSNumber *> *)subBarLength {
    if (!_subBarLength) {
        _subBarLength = [NSMutableArray<NSNumber *> array];
    }
    return _subBarLength;
}

- (NSMutableArray<UIColor *> *)subBarColors {
    if (!_subBarColors) {
        _subBarColors = [NSMutableArray<UIColor *> array];
    }
    return _subBarColors;
}

- (NSArray<DTDimensionModel *> *)itemDatas {
    if (!_itemDatas) {
        _itemDatas = self.heapData.copy;
    }
    return _itemDatas;
}


#pragma mark - private method

/**
 * 计算frame和布局子bar
 */
- (void)relayoutSubBars {
    CGRect frame = self.frame;
    __block CGFloat totalLength = 0;
    for (NSNumber *num in self.subBarLength) {
        totalLength += num.floatValue;
    }

    switch (self.barOrientation) {
        case DTBarOrientationUp: {
            frame.origin.y += CGRectGetHeight(frame) - totalLength;
            frame.size.height = totalLength;
            self.frame = frame;

            totalLength = 0;
            [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[DTBar class]]) {
                    obj.frame = CGRectMake(0, totalLength, CGRectGetWidth(self.bounds), self.subBarLength[idx].floatValue);
                    totalLength += self.subBarLength[idx].floatValue;
                }
            }];

        }
            break;
        case DTBarOrientationRight: {
            frame.size.width = totalLength;
            self.frame = frame;

            totalLength = 0;
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[DTBar class]]) {
                    obj.frame = CGRectMake(totalLength, 0, self.subBarLength[idx].floatValue, CGRectGetHeight(self.bounds));
                    totalLength += self.subBarLength[idx].floatValue;
                }
            }];

        }
            break;
        case DTBarOrientationLeft: {
            frame.size.width = totalLength;
            frame.origin.x -= totalLength;
            self.frame = frame;

            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[DTBar class]]) {
                    CGFloat width = self.subBarLength[idx].floatValue;
                    obj.frame = CGRectMake(totalLength - width, 0, width, CGRectGetHeight(self.bounds));
                    totalLength -= width;
                }
            }];

        }
            break;
    }

}

#pragma mark - public method

- (void)appendData:(DTDimensionModel *)data barLength:(CGFloat)length barColor:(UIColor *)color needLayout:(BOOL)need {
    DTBarBorderStyle style = self.subBarBorderStyle;
    self.subBarBorderStyle = DTBarBorderStyleNone;

    [self appendData:data barLength:length barColor:color barBorderColor:nil needLayout:need];

    self.subBarBorderStyle = style;
}

- (void)appendData:(DTDimensionModel *)data barLength:(CGFloat)length barColor:(UIColor *)color barBorderColor:(UIColor *)borderColor needLayout:(BOOL)need {
    [self.heapData addObject:data];
    [self.subBarLength addObject:@(length)];
    [self.subBarColors addObject:color];

    DTDimensionBar *bar = [DTDimensionBar bar:self.barOrientation style:self.subBarBorderStyle];
    bar.dimensionModels = @[data];
    bar.barColor = color;
    bar.barBorderColor = borderColor;
    [self addSubview:bar];

    if (need) {
        [self relayoutSubBars];
    }
}

- (DTDimensionBar *)touchSubBar:(CGPoint)point {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[DTDimensionBar class]] && CGRectContainsPoint(v.frame, point)) {
            return (DTDimensionBar *) v;
        }
    }

    UIView *v = self.subviews.lastObject;
    if ([v isKindOfClass:[DTDimensionBar class]]) {
        return (DTDimensionBar *) v;
    }
    
    return nil;
}


@end
