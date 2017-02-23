//
//  BrowsingHistoryViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/3.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///浏览历史展示


#import <UIKit/UIKit.h>
@class  NewsSourceModel;

@interface BrowsingHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>

{
    NSMutableArray  *newsArr;       //用于保存已完成分组过程的新闻
    
    NSMutableArray  *allArr;        //用于保存所有浏览的新闻
    
    UIImageView     *logImage;
    
    NewsSourceModel *middleNewsModel;   //用于暂时存储新闻
    
    UIButton *rightBtn;
    
    NSString *str1;
    NSString *str2;
}

@property (nonatomic,strong)UITableView *tableView;


@end
