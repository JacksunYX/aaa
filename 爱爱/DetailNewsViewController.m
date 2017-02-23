//
//  DetailNewsViewController.m
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/10.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.
//






#define HeightOfSection 74



#import "DetailNewsViewController.h"
#import "DetailNewsViewController+Method.h"//引入分类
#import "CommendSourceModel.h"//评论数据模型

#import "CommentTableViewCell.h"//自定义评论区cell

#import "SecondaryCommentViewController.h"  //二级评论页面





@interface DetailNewsViewController ()

@end

@implementation DetailNewsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self creatViewandSendRequest];//创建视图及发送请求统一方法
    
    
}




#pragma mark --- TableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView    //3个分区
{
    return 3;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (section==0) {
        
        return tableNews.count;//新闻组
        
    }else if(section==1){
        
        return tableHotComment.count;
        
    }else{
    
        return tableData.count;//评论组
    
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//cell的具体填充内容
{
    
    if (indexPath.section==0) {//新闻组
        
        NSString *identfiId =@"newscell";
        
        //接受数据
        NewsSourceModel *newsModel = [tableNews objectAtIndex:indexPath.row];
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identfiId];
        if (cell==nil) {
            
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfiId];
            
            [backView setLabelOfCellWithNewsModel:newsModel];
            
            [self addTapGesturesOnBackView];    //给新闻上的图片视图添加点击事件
            
            NSLog(@"backView:%@",backView);
            
            [backView.moreshare addTarget:self action:@selector(touchToSend) forControlEvents:UIControlEventTouchUpInside];
            [backView.weiboshare addTarget:self action:@selector(touchToShareWithWeibo) forControlEvents:UIControlEventTouchUpInside];
            [backView.qqshare addTarget:self action:@selector(touchToShareWithQQZone) forControlEvents:UIControlEventTouchUpInside];
            [backView.friendshare addTarget:self action:@selector(touchToShareWithFriend) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:backView];
        }
        
        
        
        //无点击效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);

        return cell;
        
    }else{          //评论组
        
        CommentTableViewCell *cell =(CommentTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"commentcell"];
        
        if (cell == nil) {
            
//            NSLog(@"创建评论~~~");
            
            cell = [[CommentTableViewCell alloc]initWithReuseIdentifier:@"commentcell"];
            
        }
        
        CommendSourceModel *commentModel;
        
        if (indexPath.section==1) {     //热评区
            
            commentModel = tableHotComment[indexPath.row];
            
        }else{                          //普通区
        
            commentModel = tableData[indexPath.row];
        
        }
        
        //评论内容创建内容并赋值
        [cell setContentWithCommentModle:commentModel];
        
        //异步加载用户头像
        NSMutableString *ImageUrl=[MainUrl mutableCopy];
        if (commentModel.userImg) {
            
            [ImageUrl appendString:commentModel.userImg];
            
            [cell.userImage sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:[UIImage imageNamed:@"userImg_icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
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

        
        
        [cell.zanBtn addTarget:self action:@selector(changeSelectState:) forControlEvents:UIControlEventTouchUpInside];
    
        //无点击效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        NSLog(@"创建后得到的cellHeight:%f",cell.frame.size.height);
        
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        
        cell.sd_tableView = tableView;
        cell.sd_indexPath = indexPath;
        
        ///////////////////////////////////////////////////////////////////////
        
 
        return cell;
    }
}


//最后需要将cell的高度返回
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
//        NSLog(@"H:%f",backView.frame.size.height);
        
        return backView.frame.size.height;
        
    }else{
        
        CommendSourceModel *commentModel;
        
        if (indexPath.section==1&&tableHotComment.count>0) {
            
            commentModel = tableHotComment[indexPath.row];
            
        }else if(tableData.count>0){
        
            commentModel = tableData[indexPath.row];
        
        }else{
        
            return 0;
        
        }
            
        NSString *cellHeight = commentModel.cellHeight;
            
        return [cellHeight integerValue];
        
    }
}


//分区头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        
        return 0;
        
    }else if (section==1){
    
        if (tableHotComment.count>0) {
            
            return 20;
            
        }else{
        
        return 0;
        
        }
        
    }else{
        
        if (tableData.count>0) {
            
            return 20;
            
        }else{
            
            return 0;
            
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;

}

//分区头填充内容
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *SectionView = [[UIView alloc]init];

    SectionView.backgroundColor = [UIColor clearColor];

    switch (section) {
            
        case 1:
        {
            
            if (tableHotComment.count) {
                
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
            
        case 2:
        {
            
            if (tableData.count) {
                
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
//tableView单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section!=0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        CommendSourceModel *user;
        
        if (indexPath.section==1) { //热评区
            
            user = tableHotComment[indexPath.row];
            
        }else{                      //普通评论区
        
            user = tableData[indexPath.row];
        
        }
        
        self.hidesBottomBarWhenPushed=YES;
        
        SecondaryCommentViewController *sv =[[SecondaryCommentViewController alloc]init];
        sv.comment=user;
        sv.newsModel=self.newsModel;
        [self.navigationController pushViewController:sv animated:YES];
        
        
    }
    
    
}




@end
