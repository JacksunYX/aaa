//
//  MyMessageViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/8.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///我的回复展示

#import <UIKit/UIKit.h>
#import "MJRefresh.h"//刷新库
#import "NewsSourceModel.h"//新闻模型

@interface MyMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

{
    NSMutableArray  *MessageArr;//用来保存数据模型的数组
    
    UIImageView     *logImage;  //log
    
    NSString        *baseDate;  //时间基点
    
    MBProgressHUD   *hud;
}

@property (nonatomic,strong)UITableView *tableView;


@end
