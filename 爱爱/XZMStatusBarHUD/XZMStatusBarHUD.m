//
//  XZMStatusBarHUD.m
//  0731-XZMStatusBarHUD
//
//  Created by 谢忠敏 on 15/7/31.
//  Copyright (c) 2015年 谢忠敏. All rights reserved.
//

#import "XZMStatusBarHUD.h"

#define XZMScreenW [UIScreen mainScreen].bounds.size.width

static UIWindow *window_;
static NSTimer *timer_;

/** 消息显示\隐藏的动画时间 */
static CGFloat animaDelay_ = 0.7;
static UIActivityIndicatorView *indicatorView_;
static CGFloat position_;
static UIButton *btn_;
@implementation XZMStatusBarHUD
XZMSingletonM(XZMStatusBarHUD)
- (void)showWindow
{
    window_.hidden = YES;
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(0, position_-self.statusH, XZMScreenW, self.statusH);
    /** window的显示级别 */
    window_.windowLevel = self.windowLevel;
    window_.hidden = NO;
    
    /** 添加动画 */
    [UIView animateWithDuration:animaDelay_ animations:^{
        CGRect windowF = window_.frame;
        windowF.origin.y = position_;
        window_.frame = windowF;
    }];
}

- (void)showMessage:(NSString *)message image:(UIImage *)image position:(CGFloat)position animaDelay:(CGFloat)animaDelay configuration:(void (^)())configurationBlock
{
    position_ = position;
    if (animaDelay) animaDelay_ = animaDelay;
    
    /** 停止定时器 */
    [timer_ invalidate];
    
    /** 清空属性 */
    [self clearStatus];
    
    /** 执行配置数据 */
    configurationBlock();
    
    /** 显示窗口 */
    [self showWindow];
    [window_ setBackgroundColor:self.statusColor];
    [self.formView addSubview:window_];
    /** 添加容器View */
    [window_ addSubview:self.statusbackgroundView];
    
    /** 添加buttom */
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    btn.titleLabel.font = self.attributedText[NSFontAttributeName];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    /** 设置文字的内边距 */
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    /** 字体的颜色 */
    [btn setTitleColor:self.attributedText[NSForegroundColorAttributeName] forState:UIControlStateNormal];
        [btn setTitle:message forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame = _statusbackgroundView.bounds;
    [self.statusbackgroundView addSubview:btn];
     btn_ = btn;
    
    /** 添加UIActivityIndicatorView */
    indicatorView_ = [[UIActivityIndicatorView alloc] init];
    [indicatorView_ startAnimating];
    [self.statusbackgroundView addSubview:indicatorView_];
    CGFloat indicatorViewW = indicatorView_.frame.size.width;
    CGSize maxSize = CGSizeMake(XZMScreenW, MAXFLOAT);
    CGFloat textW = [message boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributedText context:nil].size.width;
    CGFloat indicatorCenterX = (XZMScreenW - textW) * 0.5 - indicatorViewW - 15;
    CGFloat indicatorCenterY = window_.frame.size.height * 0.5;
    indicatorView_.center = CGPointMake(indicatorCenterX, indicatorCenterY);
    indicatorView_.hidden = YES;
    
    /** 创建定时器 */
    timer_ = [NSTimer scheduledTimerWithTimeInterval:animaDelay_ target:self selector:@selector(hidden) userInfo:nil repeats:YES];

}


- (void)showSuccess:(NSString *)success position:(CGFloat)position animaDelay:(CGFloat)animaDelay configuration:(void (^)())configurationBlock
{
    [self showMessage:success image:[UIImage imageNamed:@"XZMStatusBarHUD.bundle/success"] position:position animaDelay:animaDelay configuration:configurationBlock];
}

- (void)showError:(NSString *)error position:(CGFloat)position animaDelay:(CGFloat)animaDelay configuration:(void (^)())configurationBlock
{
    [self showMessage:error image:[UIImage imageNamed:@"XZMStatusBarHUD.bundle/error"] position:position animaDelay:animaDelay configuration:configurationBlock];
}


- (void)showNormal:(NSString *)normal position:(CGFloat)position animaDelay:(CGFloat)animaDelay configuration:(void (^)())configurationBlock
{
    [self showMessage:normal image:nil position:position animaDelay:animaDelay configuration:configurationBlock];
}

- (void)showLoading:(NSString *)loading position:(CGFloat)position animaDelay:(CGFloat)animaDelay configuration:(void(^)())configurationBlock
{
    
    [self showMessage:loading image:nil position:position animaDelay:animaDelay configuration:configurationBlock];
    [timer_ invalidate];
    timer_ = nil;
    indicatorView_.hidden = NO;
}

- (void)hidden
{
    [UIView animateWithDuration:animaDelay_ animations:^{
        CGRect windowF = window_.frame;
        windowF.origin.y = position_ - self.statusH;
        window_.frame = windowF;
    } completion:^(BOOL finished) { //完成后隐藏
        
        [window_ setHidden:YES];
      
    }];
}

- (void)showSuccess:(NSString *)success position:(CGFloat)position
{
    [self showSuccess:success position:position animaDelay:0 configuration:nil];
}

- (void)showLoading:(NSString *)loading position:(CGFloat)position
{
    [self showLoading:loading position:position animaDelay:0 configuration:nil];
    indicatorView_.hidden = NO;
}

- (void)showError:(NSString *)error position:(CGFloat)position
{
    [self showError:error position:position animaDelay:0 configuration:nil];
}


- (void)showNormal:(NSString *)normal position:(CGFloat)position
{
    [self showNormal:normal position:position animaDelay:0 configuration:nil];
}

- (CGFloat)statusAlpha
{
    if (_statusAlpha == 0 && _statusAlpha != 1.0) {
        
       _statusAlpha = 1.0;
    }
    return _statusAlpha;
}

- (UIColor *)statusColor
{
    if (_statusColor == nil) {
        
        _statusColor = [UIColor orangeColor];
    }
   return _statusColor;
}

- (CGFloat)statusH
{
    if (_statusH <= 0 && _statusH != 30) {
        _statusH = 30;
    }
    return _statusH;
    
}

- (NSMutableDictionary *)attributedText
{
    if (_attributedText == nil) {
        
        _attributedText = @{}.mutableCopy;
        
        _attributedText[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        
        _attributedText[NSForegroundColorAttributeName] = [UIColor whiteColor];
    }
    return _attributedText;
}

- (UIView *)statusbackgroundView
{
    if (_statusbackgroundView == nil) {
      
        _statusbackgroundView = [[UIView alloc] init];
    }
    _statusbackgroundView.frame = CGRectMake(0, 0, XZMScreenW, self.statusH);
    return _statusbackgroundView;
}

- (void)clearStatus
{
    [btn_ removeFromSuperview];
    [indicatorView_ removeFromSuperview];
    btn_ = nil;
    indicatorView_ = nil;
    
    _statusAlpha = 0;
    _statusbackgroundView = nil;
    _statusColor = nil;
    _statusH = 0;
    _attributedText = nil;
}

@end
