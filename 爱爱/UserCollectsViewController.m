//
//  UserCollectsViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/5.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//






#import "UserCollectsViewController.h"

#import "FirstViewTabBarVC.h"

#import "TableViewCell4.h"//自定义cell
#import "UIImageView+WebCache.h"
#import "DetailNewsViewController.h"    //普通资讯
#import "PureImageViewController.h"     //图片资讯

#import "NewsWebVC.h"   //网页展示资讯页面

#import "UserCollectsViewController+Methods.h"

@interface UserCollectsViewController ()


@end

@implementation UserCollectsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed=YES;
    
    [self creatViewAndsendRequest];//视图创建及请求发送的统一方法
    
}


-(void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    
    // 关闭侧滑效果
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    
    [self sendRequestToGetCollectList]; //获取收藏列表
    
}

-(void)viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];

    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
}


#pragma mark ----- TableView  datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView//分区
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section//元素个数
{

    return newsModelArr.count;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell4 *cell =(TableViewCell4 *) [tableView dequeueReusableCellWithIdentifier:@"collectcell"];
    
    if (cell == nil) {
        //cell重用
        cell = [[TableViewCell4 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectcell"];
        
        cell.TextLabel.font = [UIFont fontWithName:PingFangSCX size:18];
        cell.source.font = [UIFont fontWithName:PingFangSCQ size:14];
        
    }
    NewsSourceModel *newsModel =newsModelArr[indexPath.row];
    
    //图片
    if (newsModel.imageSrc) {
        NSMutableString *imgUrl =[MainUrl mutableCopy];
        [imgUrl appendString:newsModel.imageSrc];
        [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    }
    
    //标题
    cell.TextLabel.text=newsModel.title;
    
    //来源
    cell.source.text=newsModel.source;
    
    cell.tintColor = MainThemeColor;
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;

    [cell creatViewWithCommentNum:[newsModel.commentNum integerValue] AndPublishTime:newsModel.publishTime];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 140;
}



#pragma mark --- TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.isEditing) {
        
        [deleteArr addObject:[newsModelArr objectAtIndex:indexPath.row]];
        
        return;
        
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    {
//        
//        if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
//            
//            [self showString:@"请先关闭离线模式"];
//            
//        }else{  //非离线模式下
//            
//            NewsSourceModel *newModel =newsModelArr[indexPath.row];
//            
//            //        NSLog(@"newModel:%ld",(long)[newModel.contentType integerValue]);
//            
//            self.hidesBottomBarWhenPushed=YES;
//            
//            if ([newModel.contentType integerValue]==1) {           //普通资讯
//                
//                DetailNewsViewController *dv =[[DetailNewsViewController alloc]init];
//                dv.newsModel=newModel;
//                [self.navigationController pushViewController:dv animated:YES];
//                
//            }else if ([newModel.contentType integerValue]==2){      //图片资讯
//                
//                PureImageViewController *pv = [[PureImageViewController alloc]init];
//                pv.newsModel=newModel;
//                [self.navigationController pushViewController:pv animated:YES];
//                
//            }
//            
//            //        self.hidesBottomBarWhenPushed=NO;
//            
//        }
//        
//        
//    }   //旧版资讯跳转
    
    self.hidesBottomBarWhenPushed = YES;
    
    {
        
        NewsWebVC *wvc = [NewsWebVC new];
        
        NewsSourceModel *newsModel = newsModelArr[indexPath.row];
        
        NSMutableDictionary *newsDict = [NSMutableDictionary new];
        [newsDict setValue:newsModel.newsId forKey:@"newsId"];
        [newsDict setValue:newsModel.title forKey:@"title"];
        [newsDict setValue:newsModel.source forKey:@"source"];
        [newsDict setValue:newsModel.shareUrl forKey:@"shareUrl"];
        [newsDict setValue:newsModel.publishTime forKey:@"publishTime"];
        [newsDict setValue:newsModel.imageSrc forKey:@"imageSrc"];
        
        wvc.webViewUrlStr = [DebugUrl stringByAppendingString:newsModel.shareUrl];
        wvc.newsModel = newsDict;
        
        [self.navigationController pushViewController:wvc animated:YES];
    
    }   //新版网页展示资讯
    
//    self.hidesBottomBarWhenPushed = NO;
    
}


//取消选中时 将存放在self.deleteArr中的数据移除

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.isEditing) {
    
        [deleteArr removeObject:[newsModelArr objectAtIndex:indexPath.row]];
        
    }
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath    //当在Cell上滑动时会调用此函数

{
    
    return UITableViewCellEditingStyleDelete;
    
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath //对选中的Cell根据editingStyle进行操作

{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
        
    {
    
        NewsSourceModel *newsModel = newsModelArr[indexPath.row];
        
        //先删除表格的
        [newsModelArr removeObject:newsModel];
        
        if (!newsModelArr) {
            
            self.navigationItem.rightBarButtonItem.enabled=NO;
            
        }
        [self.tableView reloadData];
        
        //再删除服务器端的
        [self deleteSingleCollectWithNewId:newsModel.newsId];
        
    }
    
}




@end
