//
//  NewSliderViewController+Methods.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/29.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "NewSliderViewController.h"

@interface NewSliderViewController (Methods)


#pragma mark ----- 视图加载方法

-(void)loadViewData; //加载视图

-(void)changeNavigationView; //修改导航栏相关设置

-(void)creatProgressView;    //创建进度圈

-(void)creatNoemalProgressView; //创建普通进度圈(无限转圈)



#pragma mark ---- 辅助方法

-(void)tongzhi:(NSNotification *)text;  //成功接到通知后的回调方法

-(void)jumpToViewWithNavi:(UIViewController *)uv;   //根据传入的视图进行跳转

-(void)showString:(NSString *)str;      //提示框

- (void)switchColor:(TableViewCell *)cell;   //  切换夜间/日间模式

-(IBAction)touchToUnlockTheOfflineMode:(UISwitch *)sender;  // 开启/关闭 离线阅读模式

@end
