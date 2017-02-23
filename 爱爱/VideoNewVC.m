//
//  VideoNewVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/10.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "VideoNewVC.h"
#import "VideoNewVC+Methods.h"  //引入分类




@interface VideoNewVC ()

@end

@implementation VideoNewVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatViewandSendRequest]; //加载视图以及发送请求
    
}







#pragma mark ----- TableView Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 0;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 0;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *identifi=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
        
    }
    
    return cell;

}





@end
