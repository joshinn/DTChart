//
//  DTDataManager.m
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import "DTDataManager.h"

@interface DTDataManager ()

@property(nonatomic) NSMutableDictionary *manager;

@end

@implementation DTDataManager

+ (instancetype)shareManager {

    static DTDataManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _manager = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - private method


#pragma mark - public method

- (void)addChart:(NSString *)chartId object:(id)obj {
    self.manager[chartId] = obj;
}

- (BOOL)checkExistByChartId:(NSString *)chartId {
    id someChart = self.manager[chartId];
    return someChart != nil;
}

- (id)queryByChartId:(NSString *)chartId {
    id someChart = self.manager[chartId];
    return someChart;
}

- (void)clearCacheByChartIds:(NSArray<NSString *> *)chartIds {
    for (NSString *chartId in chartIds) {
        [self.manager removeObjectForKey:chartId];
    }
}

- (void)clearCache {
    [self.manager removeAllObjects];
}


@end
