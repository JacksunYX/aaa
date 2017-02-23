//
//  UserCollectsViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/5.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///我的收藏展示



#import <UIKit/UIKit.h>
#import "MJRefresh.h"//刷新库
#import "NewsSourceModel.h"//新闻模型


@interface UserCollectsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

{
    NSMutableArray  *newsModelArr;  //保存所有的收藏数据
    UIImageView     *logImage;
    UIButton        *rightBtn;      //导航栏右按钮
    NSMutableArray  *deleteArr;     //保存要删除的数据
    
    MBProgressHUD   *hud;
    
    DGActivityIndicatorView *activityIndicatorView; //加载指示器
}
@property (nonatomic,strong)UITableView *tableView;
@end
