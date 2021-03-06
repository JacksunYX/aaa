//
//  UpdataPasswordWithPhone.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/2/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///根据手机号修改密码



#import <UIKit/UIKit.h>

@interface UpdataPasswordWithPhone : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate>

{
    
    UILabel     *originalPhoneNum;      //手机号
    UITextField     *newPassword;       //新密码
    UITextField     *repeatPassword;    //重复密码
    
    UITextField     *testCode;          //验证码输入框
    UIButton        *getTest;           //获取验证码
    
    UIButton        *updataBtn;         //确定按钮
    
    NSString        *phoneNum;          //保存手机号
}

@property (strong ,nonatomic) NSArray *viewArr;     //视图数组

@property (strong, nonatomic) UIButton *eyes;       //密码是否可见按钮




@end
