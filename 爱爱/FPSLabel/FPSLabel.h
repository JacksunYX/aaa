//
//  FpsLabel.h
//  XinzhiNet
//
//  Created by yangyi on 16/1/9.
//  Copyright © 2016年 XZ. All rights reserved.
///用于展示当前app运行时的fps



#import <UIKit/UIKit.h>

@interface FPSLabel : UILabel

@property (nonatomic, readwrite) NSTimeInterval desiredChartUpdateInterval;

+ (void)showInWindow:(UIWindow *)window;
@end
