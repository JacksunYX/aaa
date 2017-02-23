//
//  UserDataViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/1.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///用户信息页展示

#define CellHeight 66

@class ZHPickView;

#import <UIKit/UIKit.h>

#import "UserSourceModel.h" //用户数据模型

#import "CameraSessionView.h" //拍照库

@interface UserDataViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CACameraSessionDelegate,UITextFieldDelegate>

{

    NSMutableArray *section1Arr;    //分区1数组
    NSMutableArray *section2Arr;    //分区2数组

    UIAlertView    *myAlert;        //提示框
    
    UIAlertView    *nicknameAlert;  //昵称修改框
    UIAlertView    *phoneNumAlert;  //绑定手机弹框
    
    UIActionSheet  *userImgAction;  //点击更换头像
    UIActionSheet  *userSex;        //性别更换
    UIActionSheet  *userAge;        //年龄更改
    
    ZHPickView     *myPickView;     //地域选择器
}

@property (nonatomic,strong) UITableView *myTableView;  //自带的表视图

@property (nonatomic,strong) UIImageView *userImg;      //用户头像

@property (nonatomic,strong) CameraSessionView *cameraView;

@property (nonatomic,strong) UserSourceModel *userModel;


@end
