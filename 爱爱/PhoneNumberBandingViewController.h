//
//  PhoneNumberBandingViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/20.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///绑定手机号

#import <UIKit/UIKit.h>

@interface PhoneNumberBandingViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate>

{

    UITextField *phoneNum;  //手机号
    UITextField *testCode;  //验证码

    UIButton    *getTestCode;   //获取验证码按钮
    UIButton    *bandPhone;     //绑定按钮
}

@property (strong ,nonatomic) NSArray *viewArr;//视图数组

@end
