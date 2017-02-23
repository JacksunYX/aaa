//
//  NewLoginViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/26.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///登录界面

#import <UIKit/UIKit.h>




@interface NewLoginViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>

{

    MBProgressHUD *myHud;   //用于第三方登录时使用的指示器

}

@property (strong, nonatomic)  UITextField *userName;//密码

@property (strong, nonatomic)  UITextField *passWord;//密码

@property (nonatomic,strong) UIButton *loginbtn;//登录按钮

@property (strong ,nonatomic) NSArray *viewArr;//视图数组

@end
