//
//  BrowsingHistoryViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/3.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define SectionHeight 56    //分区头高度
#define CellHeight    99    //单元格高度

#import "BrowsingHistoryViewController.h"
#import "BrowsingHistoryViewController+Methods.h"

#import "HistoryTableViewCell.h"//自定义cell

#import "DetailNewsViewController.h"    //普通资讯
#import "PureImageViewController.h"     //图片资讯


@interface BrowsingHistoryViewController ()

@end

@implementation BrowsingHistoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatView];
    
}


-(void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    
    // 关闭侧滑效果
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];

    [self getDataFromLocation];     //从本地获取数据
    
}



#pragma mark ----- TableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return newsArr.count;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (newsArr.count==0) {
        
        [self.tableView setHidden:YES];
        
        return 0;

    }else{
        
        [self.tableView setHidden:NO];

        return [newsArr[section] count];
        
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *identifiId =@"cell";
    
    HistoryTableViewCell *cell =(HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifiId];
    
    if (cell==nil) {
        
        cell=[[HistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifiId];
        
        cell.titleLabel.font = [UIFont fontWithName:PingFangSCX size:14];
        cell.source.font = [UIFont fontWithName:PingFangSCQ size:12];
        cell.publishTime.font = [UIFont fontWithName:PingFangSCJ size:12];
        
    }
    
    NSArray *arr = newsArr[indexPath.section];

    NewsSourceModel *newsModel = arr[indexPath.row] ;
    
    [cell.ImageView setImage:newsModel.titleImg];
    
    [cell setViewWithNewsModel:newsModel];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   //单元格高度
{

    return CellHeight;

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section    //分区头高度
{

    return SectionHeight;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section     //分区头内容
{

    UIView *backView =[[UIView alloc]init];
    
    //记录的最新浏览日期
    NewsSourceModel *newsModel = [newsArr[section] firstObject];
    NSMutableString *time =[[newsModel.browsTime substringWithRange:NSMakeRange(0, 8)]mutableCopy];
    
//    NSLog(@"time:%@",time);
    
    //当前日期
    NSMutableString *currentDate = [self getTheCurrentDate];
    [currentDate deleteCharactersInRange:NSMakeRange(8, 6)];
//    NSLog(@"currentDate:%@",currentDate);
    
    //昨天的此时
    NSMutableString *yesterDate =[self getTheYesterDate];
    [yesterDate deleteCharactersInRange:NSMakeRange(8, 6)];
//    NSLog(@"yesterDate:%@",yesterDate);

    if ([time isEqualToString:currentDate]) {
        
        time=[@"今天"mutableCopy];
        
    }else if([time isEqualToString:yesterDate]){
    
        time=[@"昨天"mutableCopy];
    
    }else{  //除此之外全部显示具体日期
    
        [time insertString:@"-" atIndex:4];
        [time insertString:@"-" atIndex:7];
        
        NSString *spacestr = [time substringWithRange:NSMakeRange(5, 1)];
        //判断月份中是否有0,有则去除
        if ([spacestr isEqualToString:@"0"]) {
            
            [time deleteCharactersInRange:NSMakeRange(5, 1)];
            
        }
        
    }
    
    
    //时间图标
    UIImageView *timeView =[[UIImageView alloc]init];
    [timeView setImage:[UIImage imageNamed:@"clock"]];
    [timeView sizeToFit];
    timeView.frame=CGRectMake(16, (SectionHeight+(CellHeight-75)/2-timeView.frame.size.height)/2, timeView.frame.size.width, timeView.frame.size.height);
    [backView addSubview:timeView];
    
    //具体时间描述
    UILabel *timeLabel =[[UILabel alloc]init];
    timeLabel.font=[UIFont fontWithName:PingFangSCX size:16];
    timeLabel.dk_textColorPicker=DKColorWithColors(TitleTextColorNormal, TitleTextColorNight);
    [timeLabel setText:time];
    [timeLabel sizeToFit];
    timeLabel.frame=CGRectMake(timeView.frame.origin.x+timeView.frame.size.width+16, (SectionHeight+(CellHeight-75)/2-timeLabel.frame.size.height)/2, timeLabel.frame.size.width, timeLabel.frame.size.height);
    [backView addSubview:timeLabel];
    
    return backView;

}



#pragma mark --- TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
        
        [self showString:@"请先关闭离线模式"];
        
    }else{  //非离线模式下
     
        NSArray *arr = newsArr[indexPath.section];
        
        NewsSourceModel *newModel = arr[indexPath.row] ;
        
        self.hidesBottomBarWhenPushed=YES;
        
//        if ([newModel.contentType integerValue]==1) {           //普通资讯
//            
//            DetailNewsViewController *dv =[[DetailNewsViewController alloc]init];
//            dv.newsModel=newModel;
//            [self.navigationController pushViewController:dv animated:YES];
//            
//        }else if ([newModel.contentType integerValue]==2){      //图片资讯
//            
//            PureImageViewController *pv = [[PureImageViewController alloc]init];
//            pv.newsModel=newModel;
//            [self.navigationController pushViewController:pv animated:YES];
//            
//        }
        
        NSMutableDictionary *newsDict = [NSMutableDictionary new];
        [newsDict setValue:newModel.title forKey:@"title"];
        [newsDict setValue:newModel.source forKey:@"source"];
        [newsDict setValue:newModel.publishTime forKey:@"publishTime"];
        [newsDict setValue:newModel.contentType forKey:@"contentType"];
        [newsDict setValue:newModel.shareUrl forKey:@"shareUrl"];
        [newsDict setValue:newModel.newsId forKey:@"newsId"];
        
        NewsWebVC *wvc = [NewsWebVC new];
        wvc.newsModel = newsDict;
        wvc.webViewUrlStr = [MainUrl stringByAppendingString:newModel.shareUrl];
        [self.navigationController pushViewController:wvc animated:YES];
        
        self.hidesBottomBarWhenPushed=NO;
        
    }
    
    
    
}



@end
