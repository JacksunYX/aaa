//
//  MineDataVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/23.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///我的信息界面主页



#import <UIKit/UIKit.h>

@interface MineDataVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>

{

    UIImageView *userView;  //用户头像

}

@property (nonatomic,strong) UITableView *mytableView;  //用来展示分类列表的表视图

@end
