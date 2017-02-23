//
//  SecondaryCommentViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/17.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "SecondaryCommentViewController.h"
#import "SecondaryCommentViewController+Methods.h"  //引入分类

#import "SecondaryComentCell.h"     //二级评论区自定义cell


@interface SecondaryCommentViewController ()

@end




@implementation SecondaryCommentViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadbaseView];
    
}


#pragma mark ----- TableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section==0) {
        
        return 1;
        
    }else{
    
        return commentsArr.count;
    
    }
    

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0) {     //一级评论主体
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        
        for (UIView *view in cell.contentView.subviews) {   //防止重复添加
            
            if (view==commentBackView) {
                
                [view removeFromSuperview];
                
            }
            
        }
        
        [cell.contentView addSubview:commentBackView];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{                          //二级评论
        
        CommendSourceModel *commentModel = commentsArr[indexPath.row];
    
        SecondaryComentCell *cell =(SecondaryComentCell*)[tableView dequeueReusableCellWithIdentifier:@"commentsCell"];
    
        if (cell==nil) {
            
//            NSLog(@"创建二级评论");
            
            cell=[[SecondaryComentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentsCell"];
            
        }
        
        [cell setIntroductionTextWithCommentModel:commentModel];
        
        [self addBdageNumOnBtn:cell.zanBtn AndNum:[commentModel.ups integerValue]];
        
        cell.zanBtn.selected = commentModel.isUps;
        
        cell.zanBtn.tag=[commentModel.commentId integerValue];
        
        [cell.zanBtn addTarget:self action:@selector(changeSelectState:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
//        NSLog(@"创建的cell高度:%f",cell.frame.size.height);
        
        return cell;
        
    }
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0) {
        
        return commentBackView.frame.size.height;

        
    }else{
        
//        SecondaryComentCell *cell =(SecondaryComentCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//        
//        return cell.frame.size.height;
    
        if (commentsArr.count) {
            
            CommendSourceModel *commentModel = commentsArr[indexPath.row];
            
            NSString *cellHeight = commentModel.cellHeight;
            
            return [cellHeight integerValue];
            
        }else{
            
            return 0;
            
        }
    
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;

}


#pragma mark ----- TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    }else{
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    }
    
}



@end
