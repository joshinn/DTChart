//
//  PiePresentationVC.h
//  DTiseChart
//
//  Created by Jo Shin on 2017/1/19.
//  Copyright © 2017年 studio.joshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTListCommonData;

@interface PiePresentationVC : UIViewController

@property (nonatomic) NSString *chartId;
@property(nonatomic) NSMutableArray<DTListCommonData *> *listBarData;


@end
