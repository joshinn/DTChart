//
//  NSNumber+DTExternal.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/19.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "NSNumber+DTExternal.h"

@implementation NSNumber (DTExternal)

- (NSString *)formatNumberToString {

    double value = self.doubleValue;

    BOOL isMinus = value < 0;

    NSString *st = [NSString stringWithFormat:@"%@", self];
    NSArray<NSString *> *strings = [st componentsSeparatedByString:@"."];
    NSMutableString *string = [NSMutableString stringWithString:strings.firstObject];
    if (isMinus) {
        [string deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    NSString *copyString = [string copy];

    NSUInteger loc = 0;
    for (NSUInteger i = 1; i < copyString.length + 1; ++i) {
        ++loc;
        if (i % 3 != 0) {
            continue;
        }

        if (string.length >= loc) {
            [string insertString:@"," atIndex:string.length - loc];
            ++loc;
        }
    }
    if([string hasPrefix:@","]){
        [string deleteCharactersInRange:NSMakeRange(0, 1)];
    }

    if (strings.count > 1) {
        [string appendString:@"."];
        [string appendString:strings[1]];
    }
    if (isMinus) {
        [string insertString:@"-" atIndex:0];
    }

    return string;
}

@end
