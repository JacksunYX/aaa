//
//  MineDataVC+Methods.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/1.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//


#import "UserDataViewController.h"  //用户信息界面
#import "NewLoginViewController.h"  //新的登录界面
#import "UserCollectsViewController.h"      //用户收藏页(资讯)
#import "BrowsingHistoryViewController.h"   //用户浏览历史页(资讯)
#import "QuickLoginVC.h"            //快速登录测试页面


#import "MineDataVC.h"

@interface MineDataVC (Methods)

#pragma mark ----- 统一视图加载方法
-(void)loadBaseView; //加载基本视图

-(void)changeUserDataShow; //修改用户头像显示





#pragma mark ---- 辅助方法

-(void)tongzhi:(NSNotification *)text;  //成功接到登录通知后的回调方法

-(void)logoutTongzhi:(NSNotification *)text;  //成功接到注销通知后的回调方法

-(void)UpdataUserImgTongZhi:(NSNotification *)text; //成功接到更换图片的通知后的回调方法

@end
