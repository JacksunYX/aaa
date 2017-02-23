//
//  HotelDetailVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "HotelDetailVC.h"
#import "HotelDetailVC+Methods.h"   //引入分类

#import "HotelRoomCell.h"   //自定义的cell

#import "ThemeRoomModel.h"  //主题房间模型

@implementation HotelDetailVC

-(void)viewDidLoad
{

    [super viewDidLoad];
    
    [self creatView];   //加载基本视图

}


#pragma mark ----- UITableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return hotelRoomsArr.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    HotelRoomCell *cell = (HotelRoomCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        
        cell = [[HotelRoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    ThemeRoomModel *roomModel = hotelRoomsArr[indexPath.row];
    
    [cell setViewWithRoomModel:roomModel];
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 10+((Width-10*3)/2)*3/4;

}


#pragma mark ----- UITableView delegate
//cell的点击反馈
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark ----- HorizontalMenuDelegate
-(void)clickButton:(UIButton *)button
{
    
    NSLog(@"点击了第%ld页",button.tag);
    
}









@end
