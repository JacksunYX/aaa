//
//  AboutUsVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/28.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

//版权相关视图的高度
#define LowViewHeight (44)
//上下部分的平均高度
#define AvgHeight ((Height - NavigationBarHeight - LowViewHeight)/2)



#import "AboutUsVC.h"





@interface AboutUsVC ()

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadBaseView];    //统一创建
    
//    [self getCurrentVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//集合方法
-(void)loadBaseView
{

    [self updataTheNavigationbar];
    
    [self loadUpperView];
    
    [self loadUnderView];
    
    [self loadLowView];

}

#pragma mark ----- 视图创建方法
-(void)updataTheNavigationbar   //导航栏设置
{
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(touchToPop)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    //修改间距
    SetUpNavigationBarItemLocation(20, 0, leftItem);
    
    
    //修改标题字体大小和颜色
    self.title=@"关于我们";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle(18, TitleTextColorNormal);
        
    }else{
        
        SetNavigationBarTitle(18, [UIColor whiteColor]);
        
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

///分两段，上面放logo，下面放其它信息
-(void)loadUpperView    //上半部分
{

    UIView *upperView = [UIView new];
    upperView.backgroundColor = RGBA(250, 250, 250, 0.8);
    
    [self.view addSubview:upperView];
    
    upperView.sd_layout
    .topSpaceToView(self.view,64)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(AvgHeight)
    ;
    
    //添加logo标志
    UIImageView *logView = [UIImageView new];
    [logView setImage:[UIImage imageNamed:@"aboutUs_icon"]];
    [logView sizeToFit];
    [upperView addSubview:logView];
    
    logView.sd_layout
    .widthIs(logView.frame.size.width)
    .heightIs(logView.frame.size.height)
    .centerXEqualToView(upperView)
    .centerYEqualToView(upperView)
    ;
    
    //分割线
    UIView *separatorLine = [UIView new];
    separatorLine.backgroundColor = [UIColor grayColor];
    [upperView addSubview:separatorLine];
    
    separatorLine.sd_layout
    .widthIs(Width-5*2)
    .heightIs(0.5)
    .centerXEqualToView(upperView)
    .bottomSpaceToView(upperView,0)
    ;
    
    //app版本
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSLog(@"Version:%@",app_Version);
    
    //版本号
    UILabel *vesionLabel = [UILabel new];
    vesionLabel.textColor = ContentTextColorNormal;
    vesionLabel.font = [UIFont systemFontOfSize:14];
    [upperView addSubview:vesionLabel];
    
    vesionLabel.sd_layout
    .topSpaceToView(logView,10)
    .centerXEqualToView(upperView)
    .autoHeightRatio(0)
    ;
    [vesionLabel setSingleLineAutoResizeWithMaxWidth:Width];
    [vesionLabel setText:[NSString stringWithFormat:@"Version:%@",app_Version]];
    
    
    
    
    
}

-(void)loadUnderView    //下半部分
{
    UIView *underView = [UIView new];
    underView.backgroundColor = RGBA(250, 250, 250, 0.8);
    
    [self.view addSubview:underView];
    
    underView.sd_layout
    .bottomSpaceToView(self.view,LowViewHeight)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(AvgHeight)
    ;
    
    //联系的相关信息
    UILabel *contactUsLabel = [UILabel new];
    contactUsLabel.font = [UIFont systemFontOfSize:20];
    [underView addSubview:contactUsLabel];
    
    contactUsLabel.sd_layout
    .topSpaceToView(underView,30)
    .centerXEqualToView(underView)
    .autoHeightRatio(0)
    ;
    [contactUsLabel setSingleLineAutoResizeWithMaxWidth:Width];
    
    [contactUsLabel setText:@"联系我们"];
    
    //电话(座机)
    UILabel *phoneLabel = [UILabel new];
    phoneLabel.font = [UIFont systemFontOfSize:16];
    phoneLabel.textColor = ContentTextColorNormal;
    [underView addSubview:phoneLabel];
    
    phoneLabel.sd_layout
    .topSpaceToView(contactUsLabel,20)
    .centerXEqualToView(underView)
    .autoHeightRatio(0)
    ;
    [phoneLabel setSingleLineAutoResizeWithMaxWidth:Width];
    
    [phoneLabel setText:@"电话 : 400-565562"];
    
    //邮箱
    UILabel *emailLabel = [UILabel new];
    emailLabel.font = [UIFont systemFontOfSize:16];
    emailLabel.textColor = ContentTextColorNormal;
    [underView addSubview:emailLabel];
    
    emailLabel.sd_layout
    .topSpaceToView(phoneLabel,20)
    .centerXEqualToView(underView)
    .autoHeightRatio(0)
    ;
    [emailLabel setSingleLineAutoResizeWithMaxWidth:Width];
    
    [emailLabel setText:@"邮箱 : aiai@qq.com"];
    
    
}

-(void)loadLowView      //版权部分
{

    UIView *lowView = [UIView new];
    lowView.backgroundColor = RGBA(230, 230, 230, 1);
    
    [self.view addSubview:lowView];
    
    lowView.sd_layout
    .bottomSpaceToView(self.view,0)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(LowViewHeight)
    ;
    
    //添加版权声明
    UILabel *statementLabel = [UILabel new];
    statementLabel.textColor = ContentTextColorNormal;
    statementLabel.font = [UIFont systemFontOfSize:14];
    [lowView addSubview:statementLabel];
    
    statementLabel.sd_layout
    .centerXEqualToView(lowView)
    .centerYEqualToView(lowView)
    .autoHeightRatio(0)
    ;
    [statementLabel setSingleLineAutoResizeWithMaxWidth:Width];
    
    [statementLabel setText:@"Copyright @2016 爱爱网 版权所有"];
    
}



#pragma mark ----- 辅助方法

-(void)touchToPop   //返回上一页
{

    [self.navigationController popViewControllerAnimated:YES];

}


-(void)getCurrentVersion
{
    
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
    NSLog(@"executableFile:%@",executableFile);
    
    //获取项目名称
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSLog(@"version:%@",version);
    
    //获取项目版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"app_Name:%@",app_Name);
    
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"app_Version:%@",app_Version);
    
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"app_build:%@",app_build);
    
}













@end
