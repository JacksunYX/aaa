//
//  XZMStatusBarHUD.h
//  0731-XZMStatusBarHUD
//
//  Created by 谢忠敏 on 15/7/31.
//  Copyright (c) 2015年 谢忠敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZMSingleton.h"
@interface XZMStatusBarHUD : NSObject
XZMSingletonH(XZMStatusBarHUD)

/**
 *  @param message 加载显示的文字
 *  @param image   加载显示的图片
 */
- (void)showMessage:(NSString *)message image:(UIImage *)image position:(CGFloat)position animaDelay:(CGFloat)animaDelay configuration:(void(^)())configurationBlock;

/**
 *  @param success 加载成功
 */
- (void)showSuccess:(NSString *)success position:(CGFloat)position animaDelay:(CGFloat)animaDelay configuration:(void(^)())configurationBlock;

- (void)showSuccess:(NSString *)success position:(CGFloat)position;

/**
 *  @param loading 正在加载中
 */
- (void)showLoading:(NSString *)loading position:(CGFloat)position animaDelay:(CGFloat)animaDelay configuration:(void(^)())configurationBlock;
- (void)showLoading:(NSString *)loading position:(CGFloat)position;

/**
 *  @param hidden 隐藏HUD
 */
- (void)hidden;

/**
 *  @param error 加载加载失败
 */
- (void)showError:(NSString *)error position:(CGFloat)position animaDelay:(CGFloat)animaDelay configuration:(void(^)())configurationBlock;
- (void)showError:(NSString *)error position:(CGFloat)position;

/**
 *  @param normal 普通文字
 */
- (void)showNormal:(NSString *)normal position:(CGFloat)position animaDelay:(CGFloat)animaDelay configuration:(void(^)())configurationBlock;
- (void)showNormal:(NSString *)normal position:(CGFloat)position;

/**
 *  状态栏的高度
 */
@property (nonatomic, assign)CGFloat statusH;
/**
 *  状态栏的透明度
 */
@property (nonatomic, assign)CGFloat statusAlpha;
/**
 *  状态栏的背景颜色
 */
@property (nonatomic, strong)UIColor *statusColor;
/**
 *  状态栏的背景图片
 */
@property (nonatomic, strong)UIView *statusbackgroundView;
/**
 *  状态栏的文字属性
 */
@property(nonatomic,copy)NSMutableDictionary *attributedText;
/**
 *  窗口的优先级
 */
@property (nonatomic, assign)UIWindowLevel windowLevel;
/**
 *  添加到哪个view上面
 */
@property (nonatomic, strong)UIView *formView;
@end
