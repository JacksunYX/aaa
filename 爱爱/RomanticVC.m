//
//  RomanticVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/5/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define DownViewHeight  50  //下方控件视图的高度

#import "UIImageView+Animation.h"   //带动画的动画加载


#import "RomanticVC.h"

@interface RomanticVC ()
{

    UIButton *bookBtn;  //预订按钮

}

@end

@implementation RomanticVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadBaseView];
    
//    NSLog(@"浪漫服务数据:%@",_romanticDic);
}

#pragma  mark ----- 视图创建

//加载所有视图
-(void)loadBaseView
{

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self updataTheNavigationbar];
    
    [self creatDownControl];
    
    [self creatRomantiServiceView];

}

-(void)updataTheNavigationbar   //导航栏设置
{
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(touchtoPop)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //处理左按钮靠右的情况(当前设备的版本>=ios7.0)
    if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
        
    {
        
        UIBarButtonItem *negativeSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemFixedSpace
                                           
                                                                                          target : nil action : nil ];
        
        negativeSpacer. width = - 20 ;//这个数值可以根据情况自由变化
        
        self.navigationItem.leftBarButtonItems = @[ negativeSpacer, leftItem ] ;
        
    }else{//低于7.0版本不需要考虑
        
        self.navigationItem.leftBarButtonItem= leftItem;
        
    }
    
    //修改标题字体大小和颜色
    self.title = @"服务详情";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNormal);
        
    }else{
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNight);
        
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    //打开手势侧滑功能
    //    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

-(void)creatDownControl     //创建下方控件
{
    
    UIView *downView =[[UIView alloc]initWithFrame:CGRectMake(0, Height-DownViewHeight, Width, DownViewHeight)];
    downView.backgroundColor=[UIColor whiteColor];
    
    //预订按钮
    bookBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width, DownViewHeight)];
    [bookBtn setBackgroundColor:MainThemeColor];
    [bookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [bookBtn setTitle:@"选择服务" forState:UIControlStateNormal];
    
    RomanticSingleExample *single = [RomanticSingleExample shareExample];
    NSMutableArray *copyArr = [single.serviceArr mutableCopy];
    for (NSDictionary *dic in copyArr) {
        
        if ((int)[dic objectForKey:@"romanticId"] == (int)[_romanticDic objectForKey:@"romanticId"]) {
            
            [bookBtn setTitle:@"取消服务" forState:UIControlStateNormal];
            
            break;
            
        }
        
    }
    
    [bookBtn addTarget:self action:@selector(touchToSelectService) forControlEvents:UIControlEventTouchUpInside];
    bookBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [downView addSubview:bookBtn];
    
    [self.view addSubview:downView];
}

-(void)creatRomantiServiceView  //创建中间的滚动视图，用以展示浪漫服务
{

    //使用滚动视图来展示数据
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    
    scrollView.sd_layout
    .topSpaceToView(self.view,64)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,DownViewHeight)
    ;
    
    //服务图片
    UIImageView *imageview = [UIImageView new];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds = YES;
    
    //服务名称
    UILabel *romanticName = [UILabel new];
    [romanticName setTextColor:MainThemeColor];
    [romanticName setFont:[UIFont fontWithName:PingFangSCX size:20]];
    
    //价格
    UILabel *romanticPrice = [UILabel new];
    [romanticPrice setTextColor:MainThemeColor];
    [romanticPrice setFont:[UIFont fontWithName:PingFangSCX size:16]];
    
    //服务描述
    UILabel *romanticDescription = [UILabel new];
    [romanticDescription setTextColor:ContentTextColorNormal];
    [romanticDescription setFont:[UIFont fontWithName:PingFangSCJ size:14]];
    
    
    //添加到视图上
    [scrollView sd_addSubviews:@[imageview,romanticName,romanticPrice,romanticDescription]];
    
    
    CGFloat margin = 15.0f;
    
    //布局
    imageview.sd_layout
    .widthIs(Width)
    .heightIs(Width*3/4)
    .topSpaceToView(scrollView,0)
    .centerXEqualToView(scrollView)
    ;
    
    romanticName.sd_layout
    .topSpaceToView(imageview,20)
    .leftSpaceToView(scrollView,margin)
    .autoHeightRatio(0)
    ;
    //单行文本自适应宽度
    [romanticName setSingleLineAutoResizeWithMaxWidth:Width/2];
    
    romanticPrice.sd_layout
    .rightSpaceToView(scrollView,margin)
    .autoHeightRatio(0)
    .centerYEqualToView(romanticName)
    ;
    //单行文本自适应宽度
    [romanticPrice setSingleLineAutoResizeWithMaxWidth:Width/2];
    
    
    romanticDescription.sd_layout
    .topSpaceToView(romanticName,20)
    .leftSpaceToView(scrollView,margin)
    .rightSpaceToView(scrollView,margin)
    .autoHeightRatio(0)
    ;
    
    
    //适应内部视图的高度
    [scrollView setupAutoContentSizeWithBottomView:romanticDescription bottomMargin:margin];
    
    //加载数据
    if ([_romanticDic objectForKey:@"romanticPicture"]) {
        
        NSString *imageStr = [MainUrl stringByAppendingString:[_romanticDic objectForKey:@"romanticPicture"]];
        
        [imageview animateImageWithURL:[NSURL URLWithString:imageStr]];
        
    }
    
    [romanticName setText:[_romanticDic objectForKey:@"romanticName"]];
    
    [romanticPrice setText:[NSString stringWithFormat:@"¥%@",[_romanticDic objectForKey:@"romanticPrice"]]];
    
    [romanticDescription setText:[_romanticDic objectForKey:@"romanticDescription"]];
    
}


//选择服务
-(void)touchToSelectService
{
    
    RomanticSingleExample *single = [RomanticSingleExample shareExample];
    if ([bookBtn.titleLabel.text isEqualToString:@"选择服务"]) {    //说明是在执行选区操作
        
        [single.serviceArr addObject:_romanticDic];
        
    }else{  //反之则是在执行取消操作

//        NSMutableArray *copyArr = [single.serviceArr mutableCopy];
        for (NSDictionary *dic in single.serviceArr) {
            
            if ([dic objectForKey:@"romanticId"] == [_romanticDic objectForKey:@"romanticId"]) {
                
                [single.serviceArr removeObject:dic];
                
                break;
                
            }
            
        }
    
    }
    
    [self touchtoPop];  //返回

}





















#pragma  mark ----- 辅助方法

- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
}

-(void)loadIndicator    //加载指示器
{
    
    if (!activityIndicatorView) {
        
        activityIndicatorView = [[DGActivityIndicatorView alloc]initWithType:7 tintColor:MainThemeColor size:Width/8];
        
    }
    
    [self.view addSubview:activityIndicatorView];
    
    //布局下
    activityIndicatorView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    ;
    
    [activityIndicatorView startAnimating]; //加载等待视图
    
}

-(void)showAlertView:(NSString *)string     //警告框
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}

-(void)showString:(NSString *)str           //提示框
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    //    hud.cornerRadius=20;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

-(void)touchtoPop
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//懒加载
-(NSMutableDictionary *)romanticDic
{
    
    if (!_romanticDic) {
        
        _romanticDic = [NSMutableDictionary new];
        
    }
    
    return _romanticDic;
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
