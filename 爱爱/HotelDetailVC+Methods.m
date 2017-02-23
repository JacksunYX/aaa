//
//  HotelDetailVC+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "HotelDetailVC+Methods.h"

#import "ThemeRoomModel.h"  //酒店主题酒店模型

#import "HotelHeaderView.h" //自定义表头

#import "ParallaxHeaderView.h"  //表头动态模糊库




@implementation HotelDetailVC (Methods)

#pragma mark ----- 视图创建方法
-(void)creatView   //加载基本视图
{
    
    hotelRoomsArr = [NSMutableArray new];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self updataNavigation];    //修改导航栏显示
    
    [self creatThemeRooms];     //创建虚拟数据
    
    [self creatHotelHeaderView];//创建上部分视图
    
    [self creatSegmentMenu];    //创建分段选择控件
    
}

-(void)updataNavigation //修改导航栏显示
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
    self.title=@"酒店详情";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:18],
           NSForegroundColorAttributeName:RGBA(50, 50, 50, 1)}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:18],
           NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);

    
}

-(void)creatHotelHeaderView //创建酒店介绍上部分
{

    self.headerView = [self creatTableHeader];
    
    myScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, Width, Height-NavigationBarHeight)];
    //    myScrollView.backgroundColor=[UIColor greenColor];
    myScrollView.delegate=self;
    myScrollView.alwaysBounceVertical=YES;
    myScrollView.contentSize = myScrollView.frame.size;
    
    [myScrollView addSubview:self.headerView];
    
    [self.view addSubview:myScrollView];

}

-(void)creatSegmentMenu     //创建分段选择控件
{

    segment = [[HorizontalMenu alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height, Width, 44) withTitles:@[@"酒店主题", @"酒店信息"]];
    segment.delegate = self;
    [myScrollView addSubview:segment];

}

-(void)creatTableView       //创建用于展示主题房间列表的表视图
{
    
    UITableView *table =[[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, Width, Height-NavigationBarHeight)];
    self.mytableView=table;
    [self.view addSubview:self.mytableView];
    self.mytableView.dataSource=self;
    self.mytableView.delegate=self;
    self.mytableView.tableFooterView=[[UIView alloc]init];
    self.mytableView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    
    
}









#pragma mark ----- 辅助方法

-(void)touchtoPop   //返回上一页
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


//创建主题房间的虚拟数据
-(void)creatThemeRooms
{

    ThemeRoomModel *roomModel1 =[[ThemeRoomModel alloc]init];
    [roomModel1 setValue:@"http://www.tianelian.com/uploads/housetype/post-thumbnail/53ec7e52b4fed.jpg" forKey:@"imageSrc"];
    [roomModel1 setValue:@"迷情盛宴" forKey:@"theme"];
    [roomModel1 setValue:@"人生两大境界:洞房花烛夜,金榜题名时。今夜,烛光摇曳中......" forKey:@"introduction"];
    [roomModel1 setValue:@"368" forKey:@"unitPrice"];
    
    ThemeRoomModel *roomModel2 =[[ThemeRoomModel alloc]init];
    [roomModel2 setValue:@"http://www.tianelian.com/uploads/housetype/post-thumbnail/543c82fc767dd.jpg" forKey:@"imageSrc"];
    [roomModel2 setValue:@"HelloKitty" forKey:@"theme"];
    [roomModel2 setValue:@"每个女人心中都住着一个公主,这一刻,需要被疼爱......" forKey:@"introduction"];
    [roomModel2 setValue:@"268" forKey:@"unitPrice"];
    
    ThemeRoomModel *roomModel3 =[[ThemeRoomModel alloc]init];
    [roomModel3 setValue:@"http://www.tianelian.com/uploads/housetype/post-thumbnail/543c80f4d4d8e.jpg" forKey:@"imageSrc"];
    [roomModel3 setValue:@"海洋之恋" forKey:@"theme"];
    [roomModel3 setValue:@"躺在幽蓝的天空下,默数星星一颗两颗三颗四颗连成线,沉醉在......" forKey:@"introduction"];
    [roomModel3 setValue:@"458" forKey:@"unitPrice"];
    
    ThemeRoomModel *roomModel4 =[[ThemeRoomModel alloc]init];
    [roomModel4 setValue:@"http://www.tianelian.com/uploads/housetype/post-thumbnail/5594c56e83216.jpg" forKey:@"imageSrc"];
    [roomModel4 setValue:@"丛林迷踪" forKey:@"theme"];
    [roomModel4 setValue:@"置身在热带雨林中,牵着彼此的手,去探寻生命中的美好......" forKey:@"introduction"];
    [roomModel4 setValue:@"233" forKey:@"unitPrice"];
    
    
    [hotelRoomsArr addObject:roomModel1];
    [hotelRoomsArr addObject:roomModel2];
    [hotelRoomsArr addObject:roomModel3];
    [hotelRoomsArr addObject:roomModel4];

}

//创建虚拟表头
-(ParallaxHeaderView *)creatTableHeader
{

    HotelHeaderView *headerView =[[HotelHeaderView alloc]initWithWidth:Width];
    
    //设置属性
    headerView.backImageView.image =[UIImage imageNamed:@"hotelBakImage.png"];
    [headerView sethotelIconImage:[UIImage imageNamed:@"hotelLogo.png"]];
    headerView.hotelName.text=@"天鹅恋情侣酒店(关山店)";
    
    UIImage *headerImage = [self convertViewToImage:headerView];
    
    ParallaxHeaderView *phView =[ParallaxHeaderView parallaxHeaderViewWithImage:headerImage forSize:CGSizeMake(headerImage.size.width, headerImage.size.height)];
    
    return phView;
    
}

///将UIView重绘为UIImage
-(UIImage*)convertViewToImage:(UIView*)view
{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark ----- UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == myScrollView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [self.headerView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}







@end
