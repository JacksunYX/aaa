//
//  HotelReservationVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/17.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "HotelReservationVC.h"
#import "HotelReservationVC+Methods.h"  //引入分类

#import "HotelRoomClassifyCell.h"   //自定义的酒店分类cell
#import "HotelClassifyModel.h"      //酒店分类模型

#import "RoomsClassifyListVC.h" //主题房间列表



@interface HotelReservationVC ()

@end

@implementation HotelReservationVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadBaseView];    //加载基本视图
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    self.hidesBottomBarWhenPushed=NO;
    
}




-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    //接受修改定位状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"SetLocation" object:nil];
    
    //开启侧边栏侧滑效果
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableRESideMenu" object:self userInfo:nil];

}



#pragma mark ----- UITableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return hotelClassifyArr.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    HotelRoomClassifyCell *cell =(HotelRoomClassifyCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        
        cell=[[HotelRoomClassifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    HotelClassifyModel *hotelClassifyModel = hotelClassifyArr[indexPath.row];
    
    [cell setViewWithHotelClassifyModel:hotelClassifyModel];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return ((Width-20)/2)+(25+10+50+10);
    
}



#pragma mark ----- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    RoomsClassifyListVC *rvc =[[RoomsClassifyListVC alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    
    HotelClassifyModel *hotelClassifyModel = hotelClassifyArr[indexPath.row];
    
    NSMutableDictionary *dict =[NSMutableDictionary new];
    
    [dict setValue:currentCityCode forKey:@"zoneCode"];
    [dict setValue:hotelClassifyModel.themeId   forKey:@"roomThemeId"];
    [dict setValue:hotelClassifyModel.classify  forKey:@"classify"];
    
    rvc.model = dict;
    
    [self.navigationController pushViewController:rvc animated:YES];
    self.hidesBottomBarWhenPushed=NO;

}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
