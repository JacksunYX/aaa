//
//  HotelShowVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///酒店列表展示页


#import <UIKit/UIKit.h>

@interface HotelListVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

{

    BOOL downPull;  // 上(下)拉
    
    NSMutableArray *hotelArr;   //用于保存酒店模型的数组

}

@property (nonatomic,strong) UITableView *mytableView;


@end
