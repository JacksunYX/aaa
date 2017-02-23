//
//  FirstViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/19.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstViewController+Methods.h"     //引入分类

#import "TableViewCell5.h"  //多图
#import "TableViewCell7.h"  //普通

#import "NormalRegisterViewController.h"    //新的注册界面
#import "NewLoginViewController.h"          //新的登录界面

#import "FirstViewTabBarVC.h"


@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadMainView];    //加载主界面
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    self.hidesBottomBarWhenPushed=NO;
    
}


-(void)viewDidAppear:(BOOL)animated
{
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [super viewDidAppear:animated];
    
    //开启侧边栏侧滑效果
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableRESideMenu" object:self userInfo:nil];
    
    //开启定时器
    [self openTheTimer];
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    
    //关闭定时器
    [self closeTheTimer];
    
}



#pragma mark --- TableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView//分区
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0&&recommendNews.count>0)
    {
        return 1;
    }
    
    if (recommendNews.count>0||processArr.count>0){

        [logImage setHidden:YES];
        
    }else{
    
        [logImage setHidden:NO];
    
    }
    
    if(section==1&&processArr.count){
        
        return processArr.count;
        
    }else{
        
        return 0;
        
    }
    
    
}

//填充cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) { //推荐区
        
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"scrollCell"];//滚动(三个新闻)
        
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scrollCell"];
            
//            NSLog(@"创建推荐区");
            
        }
        
        [cell.contentView addSubview:self.myRecommendView];
        
        cell.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
        
        
    }else{                     //其它区 (包括图片新闻和普通新闻)
        
//        NSLog(@"processArr.count:%lu",(unsigned long)processArr.count);
        
        if (processArr.count>0) {
            
            if ([processArr[indexPath.row] isKindOfClass:[NSArray class]]) {
                
                NSArray *arr =processArr[indexPath.row];
                
                //            NSLog(@"对象是数组");
                //使用普通cell
                TableViewCell7 *cell =(TableViewCell7 *) [tableView dequeueReusableCellWithIdentifier:@"normalCell"];//普通(包含2个新闻)
                
                if (cell == nil) {
                    
//                    NSLog(@"创建普通资讯");
                    
                    cell = [[TableViewCell7 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normalCell"];
                    
                }
                
                [cell setViewWithNewsArr:arr];
                UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalController1:)];
                singleTap1.delegate=cell;
                UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalController2:)];
                singleTap2.delegate=cell;
                
                [cell.backViewL addGestureRecognizer:singleTap1];
                
                [cell.backViewR addGestureRecognizer:singleTap2];
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;

                return cell;
                
            }else{
                
                NewsSourceModel *newsmodel = processArr[indexPath.row];
                //            NSLog(@"对象是Model");
                //使用多图的cell
                TableViewCell5 *cell =(TableViewCell5 *) [tableView dequeueReusableCellWithIdentifier:@"pureImageCell"];//多图
                
                if (cell == nil) {
                    
//                    NSLog(@"创建多图资讯");
                    
                    cell = [[TableViewCell5 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pureImageCell"];
                    
                }
                
                [cell setViewWithModel:newsmodel];
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Imagecontroller:)];
                singleTap.delegate=self;
                
                [cell.backView addGestureRecognizer:singleTap];
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                //夜间模式颜色设置
                cell.title.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), TitleTextColorNight);
                cell.backView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], RGBA(50, 50, 50, 1));
                cell.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
                cell.clicks.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), UnimportantContentTextColorNight);
                
                return cell;
            }
            
        }else{
            
            return nil;
            
        }
        
    }
    
}

//最后需要将cell的高度返回
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        
        return self.myRecommendView.frame.size.height+10;
        
    }else{
        
        
        if ([processArr[indexPath.row] isKindOfClass:[NSArray class]]) {
            
//            TableViewCell7 *cell = (TableViewCell7 *)[self tableView:self.mytableView cellForRowAtIndexPath:indexPath];
//            
//            return cell.frame.size.height;
            
            CGFloat cellHeight =(Width-30)/3+50+10;
            
            return cellHeight;
            
        }else{
            
//            TableViewCell5 *cell = (TableViewCell5 *)[self tableView:self.mytableView cellForRowAtIndexPath:indexPath];
//            
//            return cell.frame.size.height;
            
            CGFloat cellHeight = 10+14+10 +(Width-10*2-1*2)/3 +10+20+10+10;
            
            return cellHeight;
            
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0;
}




#pragma mark --- TableView delegate
//tableView单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)normalController1:(UITapGestureRecognizer *)tapGesture { // 一般咨询(包括除图片资讯的所有资讯)
    
    [self chooseContainerWithNewsId:tapGesture.view.tag];
    
}


- (void)normalController2:(UITapGestureRecognizer *)tapGesture { // 一般咨询(包括除图片资讯的所有资讯)
    
    [self chooseContainerWithNewsId:tapGesture.view.tag];
    
}


- (void)Imagecontroller:(UITapGestureRecognizer *)tapGesture {  //图文资讯
    
    [self jumpToPureImagesViewWithNewsId:tapGesture.view.tag];
    
}










@end
