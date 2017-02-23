//
//  FirstCommentViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/18.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "FirstCommentViewController.h"
#import "FirstCommentViewController+Methods.h"  //引入分类

#import "CommentTableViewCell.h"    //自定义评论区cell

#import "SecondaryCommentViewController.h"  //二级评论页面


@implementation FirstCommentViewController

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self loadbaseView];    //加载视图并发送获取评论的请求
    
}


#pragma mark ----- TableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        
        return hotCommentArr.count;
        
    }else{
        
        return otherCommentArr.count;
        
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentTableViewCell *cell =(CommentTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"othercommentcell"];
    
    if (cell == nil) {
        
        cell = [[CommentTableViewCell alloc]initWithReuseIdentifier:@"othercommentcell"];
        
        //            NSLog(@"创建评论区");
        
    }
    
    CommendSourceModel *commentModel;
    
    if (indexPath.section==0) {     //热评区
        
        commentModel = hotCommentArr[indexPath.row];
        
    }else{                          //普通区
        
        commentModel = otherCommentArr[indexPath.row];
        
    }
    
    //评论内容创建内容并赋值
    [cell setContentWithCommentModle:commentModel];
    
    //异步加载用户头像
    NSMutableString *ImageUrl=[MainUrl mutableCopy];
    if (commentModel.userImg) {
        
        [ImageUrl appendString:commentModel.userImg];
        
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:ImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //先放大到需要的size
            UIImage *img =[self scaleToSize:image size:CGSizeMake(160, 160)];
            
            //再切圆
            UIImage *img2 =[self cutImage:img WithRadius:img.size.width/2];
            
            [cell.userImage setImage:img2];
            
        }];
        
    }
    
    cell.zanBtn.tag = [commentModel.commentId integerValue];
    
    //点击用户头像查看信息
    //        [cell.userbtn addTarget:self action:@selector(touchToSearch) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addBdageNumOnBtn:cell.zanBtn AndNum:[commentModel.ups integerValue]];
    
    cell.zanBtn.selected = commentModel.isUps;
    
    [cell.comments setText:commentModel.childNum];
    
    [cell.zanBtn addTarget:self action:@selector(changeSelectState:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


//分区头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==0){
        
        if (hotCommentArr.count) {
            
            return 20;
            
        }else{
            
            return 0;
            
        }
        
    }else{
        
        if (otherCommentArr.count) {
            
            return 20;
            
        }else{
            
            return 0;
            
        }
        
    }
    
}


//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommendSourceModel *commentModel;
    
    if (indexPath.section==0&&hotCommentArr.count>0) {
        
        commentModel = hotCommentArr[indexPath.row];
        
    }else if(otherCommentArr.count>0){
        
        commentModel = otherCommentArr[indexPath.row];
        
    }else{
        
        return 0;
        
    }
    
    return [commentModel.cellHeight integerValue];
    
}

//分区头填充内容
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *SectionView = [[UIView alloc]init];
    SectionView.backgroundColor=[UIColor clearColor];
    
    switch (section) {
            
        case 0:
        {
            
            if (hotCommentArr.count) {
                
                UILabel *hotLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 50, 10)];
                hotLabel.textAlignment=1;
                hotLabel.font=[UIFont boldSystemFontOfSize:12];
                hotLabel.backgroundColor=[UIColor clearColor];
                hotLabel.textColor=RGBA(255, 48, 48, 1);
                [hotLabel setText:@"最热评论"];
                [SectionView addSubview:hotLabel];
                
            }
            
        }
            break;
            
        case 1:
        {
            
            if (otherCommentArr.count) {
                
                UILabel *normalLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 50, 10)];
                normalLabel.textAlignment=1;
                normalLabel.font=[UIFont boldSystemFontOfSize:12];
                normalLabel.backgroundColor=[UIColor clearColor];
                normalLabel.textColor=RGBA(255, 106, 106, 1);
                [normalLabel setText:@"最新评论"];
                [SectionView addSubview:normalLabel];
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
    return SectionView;
}

#pragma mark ----- TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    CommendSourceModel *user;
    
    if (indexPath.section==0) {
        
        user = hotCommentArr[indexPath.row];
        
    }else{
        
        user = otherCommentArr[indexPath.row];
        
    }
    
    SecondaryCommentViewController *sv =[[SecondaryCommentViewController alloc]init];
    sv.comment=user;
    sv.newsModel=self.newsModel;
    [self.navigationController pushViewController:sv animated:YES];
    
}







@end
