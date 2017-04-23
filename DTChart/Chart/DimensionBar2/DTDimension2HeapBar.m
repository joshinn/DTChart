//
//  DTDimension2HeapBar.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/4/21.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDimension2HeapBar.h"
#import "DTDimension2Bar.h"

@interface DTDimension2HeapBar ()

@property(nonatomic) NSMutableArray<DTDimension2Bar *> *subBars;
@property(nonatomic) NSMutableArray *heapData;
@property(nonatomic) NSMutableArray<NSNumber *> *subBarLength;

@end

@implementation DTDimension2HeapBar

- (NSMutableArray *)heapData {
    if (!_heapData) {
        _heapData = [NSMutableArray array];
    }
    return _heapData;
}

- (NSMutableArray<NSNumber *> *)subBarLength {
    if (!_subBarLength) {
        _subBarLength = [NSMutableArray<NSNumber *> array];
    }
    return _subBarLength;
}

- (NSMutableArray<DTDimension2Bar *> *)subBars {
    if (!_subBars) {
        _subBars = [NSMutableArray array];
    }
    return _subBars;
}


#pragma mark - private method

/**
 * 计算frame和布局子bar
 */
- (void)relayoutSubBars {
    CGRect frame = self.frame;
    CGFloat positiveLengthSum = 0;
    CGFloat negativeLengthSum = 0;
    for (NSNumber *num in self.subBarLength) {
        CGFloat length = (CGFloat) num.doubleValue;
        if (length >= 0) {
            positiveLengthSum += length;
        } else {
            negativeLengthSum += length;
        }
    }

    switch (self.barOrientation) {
        case DTBarOrientationUp: {
            frame.origin.y -= positiveLengthSum;
            frame.size.height = positiveLengthSum - negativeLengthSum;
            self.frame = frame;

            positiveLengthSum = 0;
            negativeLengthSum = 0;
            for (NSInteger i = self.subBarLength.count - 1; i >= 0; --i) {
                CGFloat length = (CGFloat) self.subBarLength[i].doubleValue;

                if (length >= 0) {
                    DTDimension2Bar *bar = self.subBars[i];
                    bar.frame = CGRectMake(0, positiveLengthSum, CGRectGetWidth(self.bounds), length);
                    positiveLengthSum += length;
                } else {
                    DTDimension2Bar *bar = self.subBars[i];
                    bar.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) + negativeLengthSum + length, CGRectGetWidth(self.bounds), -length);
                    negativeLengthSum += length;
                }
            }

        }
            break;
        case DTBarOrientationRight: {
            frame.size.width = positiveLengthSum - negativeLengthSum;
            frame.origin.x += negativeLengthSum;
            self.frame = frame;

            positiveLengthSum = 0;
            negativeLengthSum = 0;

            for (NSInteger i = self.subBarLength.count - 1; i >= 0; --i) {
                CGFloat length = (CGFloat) self.subBarLength[i].doubleValue;

                if (length >= 0) {
                    DTDimension2Bar *bar = self.subBars[i];
                    bar.frame = CGRectMake(CGRectGetMaxX(self.bounds) - length - positiveLengthSum, 0, length, CGRectGetHeight(self.bounds));
                    positiveLengthSum += length;
                } else {
                    DTDimension2Bar *bar = self.subBars[i];
                    bar.frame = CGRectMake(0 - negativeLengthSum, 0, -length, CGRectGetHeight(self.bounds));
                    negativeLengthSum += length;
                }
            }

        }
            break;
        case DTBarOrientationLeft: {
            frame.size.width = positiveLengthSum - negativeLengthSum;
            frame.origin.x -= positiveLengthSum;
            self.frame = frame;


            positiveLengthSum = 0;
            negativeLengthSum = 0;

            for (NSInteger i = self.subBarLength.count - 1; i >= 0; --i) {
                CGFloat length = (CGFloat) self.subBarLength[i].doubleValue;

                if (length >= 0) {
                    DTDimension2Bar *bar = self.subBars[i];
                    bar.frame = CGRectMake(positiveLengthSum, 0, length, CGRectGetHeight(self.bounds));
                    positiveLengthSum += length;
                } else {
                    DTDimension2Bar *bar = self.subBars[i];
                    bar.frame = CGRectMake(CGRectGetMaxX(self.bounds) + negativeLengthSum + length, 0, -length, CGRectGetHeight(self.bounds));
                    negativeLengthSum += length;
                }
            }

        }
            break;
        case DTBarOrientationDown: {
            frame.origin.y += negativeLengthSum;
            frame.size.height = positiveLengthSum - negativeLengthSum;
            self.frame = frame;


            positiveLengthSum = 0;
            negativeLengthSum = 0;
            for (NSInteger i = self.subBarLength.count - 1; i >= 0; --i) {
                CGFloat length = (CGFloat) self.subBarLength[i].doubleValue;

                if (length >= 0) {
                    DTDimension2Bar *bar = self.subBars[i];
                    bar.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - positiveLengthSum - length, CGRectGetWidth(self.bounds), length);
                    positiveLengthSum += length;
                } else {
                    DTDimension2Bar *bar = self.subBars[i];
                    bar.frame = CGRectMake(0, 0 - negativeLengthSum, CGRectGetWidth(self.bounds), -length);
                    negativeLengthSum += length;
                }
            }

        }
            break;
    }

}


#pragma mark - public method

- (void)resetBar {
    [self.heapData removeAllObjects];
    [self.subBarLength removeAllObjects];

    [self.subBars enumerateObjectsUsingBlock:^(DTDimension2Bar *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self.subBars removeAllObjects];
}

- (void)appendData:(id)data barLength:(CGFloat)length barColor:(UIColor *)color needLayout:(BOOL)need {

    [self.heapData addObject:data];
    [self.subBarLength addObject:@(length)];

    DTBarOrientation subBarOrientation = self.barOrientation;
    if (length < 0) {
        subBarOrientation = NegativeOrientation(self.barOrientation);
    }

    DTDimension2Bar *bar = [DTDimension2Bar bar:subBarOrientation style:self.barBorderStyle];
    bar.data = data;
    bar.barColor = color;
    [self.subBars addObject:bar];
    [self addSubview:bar];


    if (need) {
        [self relayoutSubBars];
    }
    NSLog(@"");
}

@end
