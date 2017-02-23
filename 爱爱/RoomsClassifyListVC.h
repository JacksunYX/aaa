//
//  RoomsClassifyListVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///主题房间列表



#import <UIKit/UIKit.h>

@interface RoomsClassifyListVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

{

    NSMutableArray *roomsArr;   //用于保存某类房间模型的数组
    
    DGActivityIndicatorView *activityIndicatorView; //加载指示器

}

@property (nonatomic,strong) UITableView *mytableView;  //用于展示某类房间的表视图

@property (nonatomic,strong) NSMutableDictionary *model;    //保存上个页面传入的数据



@end
