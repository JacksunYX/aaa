//
//  UserDataViewController+Methods.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/1.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "UserDataViewController.h"

#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface UserDataViewController (Methods)<VPImageCropperDelegate>

#pragma mark --- 加载视图集成方法

-(void)loadMainView; //统一加载视图方法



#pragma  mark ----- 视图创建

-(void)updataTheNavigationbar;  //导航栏设置

-(void)loadLocationUserData;     //加载本地用户数据


#pragma mark ----- 交互方法
-(void)getUserInfo;      //获取用户信息列表



#pragma mark ----- 辅助功能

-(void)touchToCancel;     //点击注销
    




@end
