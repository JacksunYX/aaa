//
//  RoomsClassifyListVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//



#import "RoomsClassifyListVC.h"
#import "RoomsClassifyListVC+Methods.h" //引入分类

#import "RoomClassifyCell.h"    //自定义cell

#import "RoomDetailVC.h"    //酒店详情页



@implementation RoomsClassifyListVC

-(void)viewDidLoad
{

    [super viewDidLoad];
    
    [self loadBaseView];    //加载基本视图
    
//    NSLog(@"model:%@",self.model);

}



#pragma mark ----- UITableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return roomsArr.count;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    RoomClassifyCell *cell = (RoomClassifyCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        
        cell=[[RoomClassifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.roomName.font = [UIFont fontWithName:PingFangSCX size:16];
        [cell.roomName setTextColor:MainThemeColor];
        cell.belongHotel.font = [UIFont fontWithName:PingFangSCX size:14];
        cell.priceLabel.font = [UIFont fontWithName:PingFangSCX size:16];
//        [cell.priceLabel setHidden:YES];
        
    }
    
    ThemeRoomModel *roomModel = roomsArr[indexPath.row];
    
    [cell setViewWithRoomMModel:roomModel];
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return Width*9/16+30*2+10;

}







#pragma mark ----- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ThemeRoomModel *roomModel = roomsArr[indexPath.row];
    
    RoomDetailVC *rvc =[[RoomDetailVC alloc]init];
    
    rvc.roomModel = roomModel;
    self.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:rvc animated:YES];
    
    rvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;    // 设置动画效果
//    [self presentViewController:rvc animated:YES completion:^{
//        
//    }];

}



@end
