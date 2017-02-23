//
//  NewSettingViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/1.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///设置

#import <UIKit/UIKit.h>

@interface NewSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

{

    float cachesFileSizes;  //保存缓存文件大小
    
    BOOL switchState;       //保存开关应该显示的状态
    
    AppDelegate *app;

}

@property (nonatomic,strong) UITableView *tableView;



@end
