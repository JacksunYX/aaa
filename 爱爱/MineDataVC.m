//
//  MineDataVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/23.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "MineDataVC.h"
#import "MineDataVC+Methods.h"  //引入分类

#import "MyOrdersVC.h"  //我的订单页面
#import "NewSettingViewController.h"    //新的设置界面




@implementation MineDataVC

-(void)viewDidLoad
{

    [super viewDidLoad];
    
    [self loadBaseView];    //加载基本视图
    
    //注册登录通知 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"LoginTongZhi" object:nil];
    
    //注册注销通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutTongzhi:) name:@"LogoutTongZhi" object:nil];
    
    //注册更换头像的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdataUserImgTongZhi:) name:@"UpdataUserImgTongZhi" object:nil];

}


-(void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    
//    NSLog(@"个人中心页面显示了");
    
    self.navigationController.navigationBarHidden=YES;  //隐藏导航栏
    
}





#pragma mark ----- UITableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 3;   //3个分区

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsNum;
    
    switch (section) {
        case 0:
            
            rowsNum = 1;
            
            break;
            
        case 1:
            
            rowsNum = 2;
            
            break;
            
        case 2:
            
            rowsNum = 2;
            
            break;
            
        default:
            break;
    }
    
    return rowsNum;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont fontWithName:PingFangSCX size:18];
        
    }
    
    if (indexPath.section==0) {         //分区1
        
        [cell.textLabel setText:@"我的订单"];
        [cell.imageView setImage:[UIImage imageNamed:@"oderList_icon"]];
        
    }else if (indexPath.section==1){    //分区2
    
        switch (indexPath.row) {
            case 0:
                
                [cell.textLabel setText:@"我的收藏"];
                [cell.imageView setImage:[UIImage imageNamed:@"collects_icon"]];
                
                break;
                
            case 1:
                
                [cell.textLabel setText:@"浏览历史"];
                [cell.imageView setImage:[UIImage imageNamed:@"History_icon"]];
                
                break;
                
                
            default:
                break;
        }
        
    }else if (indexPath.section==2){    //分区3
    
        switch (indexPath.row) {
                
            case 0:
                
                [cell.textLabel setText:@"编辑个人资料"];
                [cell.imageView setImage:[UIImage imageNamed:@"edit_icon"]];
                
                break;
                
            case 1:
                
                [cell.textLabel setText:@"设置"];
                [cell.imageView setImage:[UIImage imageNamed:@"setting_icon"]];
                
                break;
                
            default:
                break;
        }
        
    }
    
    return cell;

}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section!=2) {
        
        return 10;
        
    }else{
        
        return 0;
    
    }

}



#pragma mark ----- UITableView Delegate
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;
    
    if (indexPath.section==0) {
        
        switch (indexPath.row) {
                
            case 0: //我的订单
            {
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
                    
                    //如果用户登录了，点击跳转到我的订单页面
                    MyOrdersVC *mVC =[MyOrdersVC new];
                    
                    [self.navigationController pushViewController:mVC animated:YES];
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟~" delegate:self cancelButtonTitle:@"不用了" otherButtonTitles:@"去登录", nil];
                    alert.tag = 109 ;   //代表登录的标记
                    
                    [alert show];
                    
                }
                
                
            }
                break;
                
            default:
                break;
        }
        
    }else if (indexPath.section==1){
    
        switch (indexPath.row) {
            case 0: //我的收藏
            {
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {

                    UserCollectsViewController *ucVC =[UserCollectsViewController new];
                    
                    [self.navigationController pushViewController:ucVC animated:YES];
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟~" delegate:self cancelButtonTitle:@"不用了" otherButtonTitles:@"去登录", nil];
                    alert.tag = 109 ;   //代表登录的标记
                    
                    [alert show];
                    
                }
                
                
            }
                break;
                
            case 1: //浏览历史
            {

                BrowsingHistoryViewController *bhVC =[BrowsingHistoryViewController new];
                
                [self.navigationController pushViewController:bhVC animated:YES];
     
            }
                break;
                
                
            default:
                break;
        }
    
    }else if (indexPath.section==2){
    
        switch (indexPath.row) {
                
            case 0: //用户信息设置
            {
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
                    
                    //如果用户登录了，点击跳转到用户信息设置界面
                    UserDataViewController *userVC =[UserDataViewController new];
                    
                    [self.navigationController pushViewController:userVC animated:YES];
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟~" delegate:self cancelButtonTitle:@"不用了" otherButtonTitles:@"去登录", nil];
                    alert.tag = 109 ;   //代表登录的标记
                    
                    [alert show];
                    
                }
                
            }
                break;
                
            case 1: //设置
            {
                NewSettingViewController *svc = [NewSettingViewController new];
                
                [self.navigationController pushViewController:svc animated:YES];
                
            }
                break;
                
            default:
                break;
                
        }
    
    }
    
    self.hidesBottomBarWhenPushed=NO;

}



#pragma mark ----- UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == 109) { //代表是登录的提示框
        
        if (buttonIndex==1) {
         
            self.hidesBottomBarWhenPushed = YES ;
            
            QuickLoginVC *loginVC =[QuickLoginVC new];
            
//            [self.navigationController pushViewController:loginVC animated:YES];
            
            loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;    // 设置动画效果
            [self presentViewController:loginVC animated:YES completion:nil];
            
            self.hidesBottomBarWhenPushed = NO ;
            
        }
        
    }

}





@end
