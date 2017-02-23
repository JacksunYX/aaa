//
//  NewsVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/21.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///新的资讯页




#import <UIKit/UIKit.h>

@interface NewsVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    
    BOOL downPull;                                              //是否是下拉刷新
    
}

@property (nonatomic,strong) UITableView *mytableView;

@property (nonatomic,strong) NSString       *myDatebase;        //时间基点

@property (nonatomic,strong) NSString       *baseObjectId;      //基点ID


@end
