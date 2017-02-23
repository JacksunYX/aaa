//
//  FirstViewTabBarVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/17.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "FirstViewTabBarVC.h"

#import "MJRefresh.h"

#import "FirstViewController.h" //资讯页面
#import "HotelReservationVC.h"  //酒店页面

@interface FirstViewTabBarVC ()<ZFTabBarDelegate>
/**
 *  自定义的tabbar
 */


@end




@implementation FirstViewTabBarVC

static NSInteger lastViewIndex; //保存之前页面的下标

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    lastViewIndex=0;    //默认进来就是首页
    
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"count:%lu",(unsigned long)self.tabBar.subviews.count);
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];

}


/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    ZFTabBar *customTabBar = [[ZFTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}


/** 代理方法
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(ZFTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    
    NSLog(@"点击了下标");
    
    if (to!=lastViewIndex) {
        //说明只是做了下标页的点击,可以不用隐藏下方控件
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ClickTabBar"]; //做标记
        
        [[NSUserDefaults standardUserDefaults] synchronize];    //立即执行
    }
    
    if (self.selectedIndex == to && to == 0 ) {//双击刷新制定页面的列表
        JTNavigationController *nav =self.viewControllers[0];

        FirstViewController *fv =nav.jt_viewControllers[0];
        
        [fv.mytableView.mj_header beginRefreshing];
    }
    
    lastViewIndex=to;
    
    self.selectedIndex = to;

}


/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    // 1.资讯页
    FirstViewController *firestNews = [[FirstViewController alloc] init];
    JTNavigationController *nav1 = [[JTNavigationController alloc] initWithRootViewController:firestNews];
    nav1.tabBarItem.badgeValue = @"N";
    
    [self setupChildViewController:nav1 title:@"资讯" imageName:@"news_icon" selectedImageName:@"news_icon"];
    
    // 2.酒店页
    HotelReservationVC *hotel = [[HotelReservationVC alloc] init];
    JTNavigationController *nav2 = [[JTNavigationController alloc] initWithRootViewController:hotel];
    nav2.tabBarItem.badgeValue = @"8";
    
    [self setupChildViewController:nav2 title:@"酒店" imageName:@"hotel_icon" selectedImageName:@"hotel_icon"];
    
}


/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UINavigationController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    if (ISiOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    // 2.包装一个导航控制器
//    JTNavigationController *nav = [[JTNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:childVc];
    
    
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
