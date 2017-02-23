//
//  UpdataPasswordViewController.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/2/22.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///根据旧密码修改当前账号密码

#import <UIKit/UIKit.h>

@interface UpdataPasswordViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate>

{
    
    UITextField     *originalPassword;  //原密码
    UITextField     *newPassword;       //新密码
    UITextField     *repeatPassword;    //重复密码
    
    UITextField     *testCode;          //验证码输入框
    UIImageView     *getTestCode;       //获取验证码
    UILabel         *noticeLabel;       //验证码提示文字
    
    UIButton        *updataBtn;         //确定按钮
}

@property (strong ,nonatomic) NSArray *viewArr;     //视图数组

@property (strong, nonatomic) UIButton *eyes;       //密码是否可见按钮

@end
