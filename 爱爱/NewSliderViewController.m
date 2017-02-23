//
//  NewSliderViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/29.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "NewSliderViewController.h"
#import "NewSliderViewController+Methods.h" //引入分类

#import "NewSettingViewController.h"    //新的设置界面



@interface NewSliderViewController ()

@end

@implementation NewSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadViewData];    //加载界面
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self changeNavigationView];    //修改导航栏相关设置
    
    //接受通知(只会接受一次)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"LoginTongZhi" object:nil];
}


-(void)viewDidAppear:(BOOL)animated
{

    [self.mytableView reloadData];
    
    [super viewDidAppear:animated];
    
}


#pragma mark ----- TableView delegate  

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.TextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        cell.TextLabel.dk_textColorPicker=DKColorWithColors([UIColor grayColor], RGBA(200, 200, 200, 1));
        cell.TextLabel.highlightedTextColor = normalbackgroundColor;//高亮状态下的字体颜色
        
    }
    
    if (indexPath.section==0) {     //分区1
        
        switch (indexPath.row) {
                
            case 0:
            {
                cell.TextLabel.text=@"我的收藏";
                [cell.ImageView setImage:[UIImage imageNamed:@"mybookmark_icon"]];
            }
                break;
            case 1:
            {
                cell.TextLabel.text=@"我的评论";
                [cell.ImageView setImage:[UIImage imageNamed:@"reply"]];
            }
                break;
            case 2:
            {
                cell.TextLabel.text=@"浏览历史";
                [cell.ImageView setImage:[UIImage imageNamed:@"BrowsingHistory_icon"]];
            }
                break;

        }
        
        
    }else{                          //分区2
    
        switch (indexPath.row) {
                
            case 0:
            {
                cell.TextLabel.text=@"夜间模式";
                cell.ImageView.dk_imagePicker=DKImageWithImages([UIImage imageNamed:@"night_icon"], [UIImage imageNamed:@"sun3_icon"]);
                
            }
                break;
            case 1:
            {
                cell.TextLabel.text=@"离线阅读";
                [cell.ImageView setImage:[UIImage imageNamed:@"download_icon"]];
                
                //开关按钮
                if (!offLineRead) {
                    offLineRead =[[UISwitch alloc]init];
                    offLineRead.onTintColor=MainThemeColor;
                    offLineRead.on=NO;
                    offLineRead.frame=CGRectMake(self.mytableView.frame.size.width-offLineRead.frame.size.width-15, CellHeight/2-offLineRead.frame.size.height/2, offLineRead.frame.size.width, offLineRead.frame.size.height);
                    
                    [offLineRead addTarget:self action:@selector(touchToUnlockTheOfflineMode:) forControlEvents:UIControlEventValueChanged];
                    [offLineRead setHidden:YES];
                }
                
                [cell.contentView addSubview:offLineRead];
                
                
                //判断是否显示离线模式开关按钮
                if ([(NSString *)[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState] length]>0) {  //说明已经离线过资源
                    
                    [offLineRead setHidden:NO];
                    
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
                        
                        offLineRead.on=YES;
                        
                    }else{
                    
                        offLineRead.on=NO;
                        
                    }
                    
                }else{
                
                    [offLineRead setHidden:YES];
                
                }
                
                if (offLineRead.isHidden) {
                    
                    offlineDataFinished=NO;
                    
                }else{
                
                    offlineDataFinished=YES;
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                }
                
                //创建进度圈
                if (!progressView) {
                    
                    [self creatProgressView];   //创建进度圈
                    
                    [progressView setHidden:YES];   //暂时隐藏
                }
                
                [cell.contentView addSubview:progressView];
                
            }
                break;
            case 2:
            {
                cell.TextLabel.text=@"设置";
                [cell.ImageView setImage:[UIImage imageNamed:@"setup_icon"]];
            }
                break;

        }
    
    }
    
    return cell;

}

//返回cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return CellHeight;

}


//cell的点击反馈
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        
        switch (indexPath.row) {    //分区1
                
            case 0:
            {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
                    
                    [self jumpToViewWithNavi:[[UserCollectsViewController alloc]init]];
                    
                }else{
                    
                    [self showString:@"您还没有登录哟~"];
                    
                }
                
            }
                break;
            case 1:
            {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
                    
                    [self jumpToViewWithNavi:[[MyMessageViewController alloc]init]];
                    
                }else{
                    
                    [self showString:@"您还没有登录哟~"];
                    
                }
            }
                break;
            case 2:
            {
                
                [self jumpToViewWithNavi:[[BrowsingHistoryViewController alloc]init]];
                
            }
                break;

        }
        
    }else{
    
        switch (indexPath.row) {    //分区2
                
            case 0:
            {
                
                TableViewCell *cell =(TableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                [self switchColor:cell];//切换夜间模式，并改变单元格显示文字
                
            }
                break;
            case 1:
            {
                
                if (offLineRead.isHidden&&progressView.isHidden&&offlineDataFinished==NO&&DataNum==0) { //开关按钮隐藏说明没有离线资源
                    
                    offlineData = [[UIAlertView alloc]initWithTitle:@"提示" message:@"离线阅读会消耗较多流量,请确保您在Wi-Fi模式下进行" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
                    [offlineData show];
                    
                }
                
            }
                break;
            case 2:                 //设置
            {
                
                [self jumpToViewWithNavi:[[NewSettingViewController alloc]init]];
                
            }
                break;
                
        }
    
    }

}
































@end
