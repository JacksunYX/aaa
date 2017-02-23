//
//  MyMessageViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/8.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//


#import "UIImageView+WebCache.h"

#import "MyMessageViewController.h"
#import "MyMessageViewController+Methods.h"

#import "UserCommentCell.h"     //自定义cell
#import "CommendSourceModel.h"
#import "NewsSourceModel.h"

#import "SecondaryCommentViewController.h"  //二级评论页


#import "DetailNewsViewController.h"    //普通新闻
#import "PureImageViewController.h"     //图片新闻

@interface MyMessageViewController ()

@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatViewAndsendRequest];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    // 关闭侧滑效果
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    
}

#pragma mark ---TableView ---  datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (MessageArr.count==0) {
        [self.tableView setHidden:YES];
    }else{
        [self.tableView setHidden:NO];
    }
    return MessageArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserCommentCell *cell=(UserCommentCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell=[[UserCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    CommendSourceModel *commentModel = MessageArr[indexPath.row];
    
    [cell setCommentViewWithNewsCommentModel:commentModel AndParentComment:commentModel.parentComment];
    
    [cell setNewsViewWithNewsModel:commentModel.newsModel];
    
    //添加点击事件
    UITapGestureRecognizer *single =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToSearchNews:)];
    single.delegate =self;
    cell.backView.tag=indexPath.row;
    [cell.backView addGestureRecognizer:single];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //    NSLog(@"创建的cell的高度:%f",cell.frame.size.height);
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    UserCommentCell *cell = (UserCommentCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    //
    //    return cell.frame.size.height;
    
    if (MessageArr.count>0) {
        
        CommendSourceModel *commentModel = MessageArr[indexPath.row];
        
        NSString *cellHeight = commentModel.cellHeight;
        
        return [cellHeight integerValue];
        
    }else{
        
        return 0;
        
    }
    
}



#pragma mark--- TableView ---  delegate

//cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
        
        [self showString:@"请先关闭离线模式"];
        
    }else{  //非离线模式下
     
        CommendSourceModel *user = MessageArr[indexPath.row];
        
        SecondaryCommentViewController *sv =[[SecondaryCommentViewController alloc]init];
        
        sv.newsModel=user.newsModel;
        
        if ([user.parentComment allKeys].count>0) { //如果这条评论带的字典属性的键的个数大于0,说明它有父类评论
            
            sv.comment = [[CommendSourceModel alloc]init];
            
            [sv.comment setValue:[user.parentComment objectForKey:@"commentId"] forKey:@"commentId"];
            
        }else{
            
            sv.comment = user;
            
        }
        
        //    NSLog(@"sv.comment:%@",sv.comment);
        self.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:sv animated:YES];
        
//        self.hidesBottomBarWhenPushed=NO;
        
    }
    
}


//新闻图片的点击事件
-(void)touchToSearchNews:(UITapGestureRecognizer *)tapGesture
{
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
        
        [self showString:@"请先关闭离线模式"];
        
    }else{
        
        self.hidesBottomBarWhenPushed=YES;
    
        CommendSourceModel *commentModel = MessageArr[tapGesture.view.tag];
        
        switch ([commentModel.newsModel.contentType integerValue]) {
            case 1:
            {
                
                NSLog(@"跳转到普通新闻");
                
                DetailNewsViewController *dv=[[DetailNewsViewController alloc]init];
                dv.newsModel=commentModel.newsModel;
                [self.navigationController pushViewController:dv animated:YES];
                
            }
                break;
            case 2:
            {
                
                NSLog(@"跳转到图片新闻");
                PureImageViewController *pv =[[PureImageViewController alloc]init];
                pv.newsModel=commentModel.newsModel;
                [self.navigationController pushViewController:pv animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    
    }
    
}

@end
