//
//  CZCountDownView.h
//  countDownDemo
//
//  Created by 孔凡列 on 15/12/9.
//  Copyright © 2015年 czebd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TimerStopBlock)();

@interface CZCountDownView : UIView
// 时间戳
@property (nonatomic,assign)NSInteger timestamp;
// 背景
@property (nonatomic,copy)NSString *backgroundImageName;
// 时间停止后回调
@property (nonatomic,copy)TimerStopBlock timerStopBlock;

@property (nonatomic,strong) UIColor *dayTextColor;     //天的字体颜色
@property (nonatomic,strong) UIColor *hourTextColor;    //时的字体颜色
@property (nonatomic,strong) UIColor *minuteTextColor;  //分的字体颜色
@property (nonatomic,strong) UIColor *secondsTextColor; //秒的字体颜色
@property (nonatomic,strong) UIColor *separateLabelColor;   //分隔符号的颜色


/**
 *  创建单例对象
 */
+ (instancetype)cz_shareCountDown;// 工程中使用的倒计时是唯一的

/**
 *  创建非单例对象
 */
+ (instancetype)cz_countDown; // 工程中倒计时不是唯一的

@end
