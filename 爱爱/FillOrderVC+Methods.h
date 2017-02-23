//
//  FillOrderVC+Methods.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/26.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "FillOrderVC.h"

@interface FillOrderVC (Methods)

#pragma mark ----- 统一视图加载方法
-(void)loadBaseView; //加载基本视图









#pragma mark ----- 辅助方法

-(void)addLimitToTextField:(UITextField *)textfield AndWKFormatterType:(NSInteger)formatterType;    //给指定的输入框添加输入限制

//-(void)touchToSelectDate:(UITapGestureRecognizer *)singletap; //选择日期的点击事件


//通知的回调,根据返回的结果进行跳转
-(void)jumpToOrder:(NSNotification *)dict;





@end
