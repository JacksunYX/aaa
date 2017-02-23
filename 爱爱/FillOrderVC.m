//
//  OrderDetailVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/26.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "FillOrderVC.h"
#import "FillOrderVC+Methods.h" //引入分类

#import "FillRoomOrderCell.h"   //用于展示填写订单需求的自定义cell


#import "UIViewController+JTNavigationExtension.h"



@implementation FillOrderVC



-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self loadBaseView];     //加载基本视图
    
    //注册cell
//    [self.mytableView registerClass:[FillRoomOrderCell class] forCellReuseIdentifier:NSStringFromClass([FillRoomOrderCell class])];
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    self.jt_fullScreenPopGestureEnabled = NO;
    
    //注册支付宝回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToOrder:) name:@"aliPayResult" object:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    self.jt_fullScreenPopGestureEnabled = YES;

}






#pragma mark - WKTextFieldFormatterDelegate
- (void)formatter:(WKTextFieldFormatter *)formatter didEnterCharacter:(NSString *)string {

//    NSLog(@"%@", string);

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    if (textField==contactName) {
        
        [phoneNum becomeFirstResponder];
        
    }else{
    
        [self.view endEditing:YES];
    
    }
    
    
    return YES;
}




@end
