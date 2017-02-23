//
//  MyOrdersVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/5.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//


#import "MyOrdersVC.h"
#import "MyOrdersVC+Methods.h"  //引入分类
#import "OrdersCell.h"  //用于展示订单列表的自定义cell

#import "OrderDetailVC.h"   //订单详情页



@implementation MyOrdersVC

-(void)viewDidLoad
{

    [super viewDidLoad];
    
    [self loadBaseView];    //加载基本视图
    
    //注册cell
    [self.mytableView registerClass:[OrdersCell class] forCellReuseIdentifier:NSStringFromClass([OrdersCell class])];

}

-(void)viewDidAppear:(BOOL)animated
{

    //判断是否有需要删除的订单
    if (UserDefaultObjectForKey(@"DeleteOrderId")) {    //如果有值，说明需要删掉
        
        for (NSDictionary *dict in [ordersModelArr mutableCopy]) {
            
            if ([[dict objectForKey:@"orderId"]isEqualToString:UserDefaultObjectForKey(@"DeleteOrderId")]) {
                
                [ordersModelArr removeObject:dict]; //移除这个对象，并且还要刷新表视图
                
                [self.mytableView reloadData];
                
                //完了要移除这个键值
                UserDefaultRemoveObjectForKey(@"DeleteOrderId");
                
                break;
            }
            
        }
        
    }

}


#pragma mark ----- UITableView datasource 

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return ordersModelArr.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    Class currentClass = [OrdersCell class];
    OrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    
    NSDictionary *model = ordersModelArr[indexPath.section];
    
    cell.model=model;
    
    //给按钮添加点击事件(取消订单)
    [cell.cancelOrder addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    
    ///////////////////////////////////////////////////////////////////////
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[self cellContentViewWith] tableView:tableView];
    
    // 推荐使用此普通简化版方法（一步设置搞定高度自适应，性能好，易用性好）
    return [self.mytableView cellHeightForIndexPath:indexPath model:ordersModelArr[indexPath.section] keyPath:@"model" cellClass:[OrdersCell class] contentViewWidth:[self cellContentViewWith]];
    
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 5;

}





#pragma mark ----- UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.hidesBottomBarWhenPushed = YES;

    OrderDetailVC *oVC =[OrderDetailVC new];
    
//    oVC.hideLeftBtn = YES;
    NSDictionary *model = ordersModelArr[indexPath.section];
    
    int a = [[model objectForKey:@"orderStatus"]intValue];
    if (a==0||a==2) {
        
        showHudString(@"订单已不存在~");
        
        return;
        
    }
    
    oVC.orderDic = [model mutableCopy];
    
    [self.navigationController pushViewController:oVC animated:YES];

}











@end








