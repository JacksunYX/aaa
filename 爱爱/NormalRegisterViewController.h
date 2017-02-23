//
//  NormalRegisterViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/21.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///普通注册

#import <UIKit/UIKit.h>

#import "PhoneResgisterViewController.h"    //手机注册页面


#import "AFViewShaker.h"//视图震动库


@interface NormalRegisterViewController : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic)  UITextField *userName;   //用户名

@property (strong, nonatomic)  UITextField *nickName;   //昵称

@property (strong, nonatomic)  UITextField *passWord;   //密码

@property (strong, nonatomic)  UITextField *repeatPassWord;//重复密码

@property (strong, nonatomic)  UITextField *testCode;   //验证码

@property (strong, nonatomic)  UIButton *eyes;          //密码是否可见按钮

@property (strong, nonatomic)  UIImageView *test;       //验证码显示框

@property (nonatomic,strong) UILabel *noticeLabel;      //验证码提示文字;


@property (strong, nonatomic)  UIButton *regist;        //注册按钮

@property (strong ,nonatomic) NSArray *viewArr;     //视图数组



@end
