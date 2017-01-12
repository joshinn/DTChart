//
//  DTDataManager.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/10.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTDataManager : NSObject

+ (instancetype)shareManager;


- (void)addChart:(NSString *)chartId object:(id)obj;

- (BOOL)checkExistByChartId:(NSString *)chartId;

- (id)queryByChartId:(NSString *)chartId;

- (void)clearCacheByChartIds:(NSArray<NSString *> *)chartIds;

- (void)clearCache;
@end
