//
//  ServiceDetailVC.m
//  MultiSelectExample
//
//  Created by 薇薇一笑 on 16/4/12.
//  Copyright © 2016年 Darshan Patel. All rights reserved.
//

#import "ServiceDetailVC.h"

@interface ServiceDetailVC ()

@end

@implementation ServiceDetailVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self updataTheNavigationbar];
    
}


-(void)updataTheNavigationbar   //导航栏设置
{
    
//    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
//    [leftButton setBackgroundImage:[[UIImage imageNamed:@"back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    
//    [leftButton addTarget:self action:@selector(touchtoPop)forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
//    //处理左按钮靠右的情况(当前设备的版本>=ios7.0)
//    if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
//        
//    {
//        
//        UIBarButtonItem *negativeSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemFixedSpace
//                                           
//                                                                                          target : nil action : nil ];
//        
//        negativeSpacer. width = - 20 ;//这个数值可以根据情况自由变化
//        
//        self.navigationItem.leftBarButtonItems = @[ negativeSpacer, leftItem ] ;
//        
//    }else{//低于7.0版本不需要考虑
//        
//        self.navigationItem.leftBarButtonItem= leftItem;
//        
//    }
    
    //修改标题字体大小和颜色
    self.title=@"服务详情";

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0]}];

    self.view.backgroundColor = [UIColor whiteColor];
    
}


-(void)touchtoPop
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
