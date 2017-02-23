//
//  HotelShowVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "HotelListVC.h"
#import "HotelListVC+Methods.h" //引入分类
#import "HotelListCell.h"       //引入自定义cell

#import "HotelDetailVC.h"   //酒店详情页


@interface HotelListVC ()

@end

@implementation HotelListVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadBaseView];    //加载基本视图
    
}



#pragma mark ----- TableView datasource 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return hotelArr.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    HotelListCell *cell = (HotelListCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        
        cell=[[HotelListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    HotelModel *hotelModel = hotelArr[indexPath.row];
    
    [cell UpdataViewWithHotelModel:hotelModel];

    return cell;
    
}

//返回cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 100;

}


#pragma mark ----- UITableView delegate 
//cell的点击反馈
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HotelDetailVC *hdvc =[[HotelDetailVC alloc]init];
    
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:hdvc animated:YES];
    
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
