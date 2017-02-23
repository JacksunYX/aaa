//
//  SecondaryCommentViewController+Methods.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/17.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "SecondaryCommentViewController.h"



@interface SecondaryCommentViewController (Methods)



#pragma mark ----- 统一视图加载方法

-(void)loadbaseView;                    //加载基本视图




#pragma mark ----- 视图创建方法
//-(void)loadcommentView;                 //加载上方评论的视图

-(void)addBdageNumOnBtn:(UIButton *)btn AndNum:(NSInteger)value;    //根据数量改变小红点的显示数量




#pragma mark ----- 交互方法

-(IBAction)changeSelectState:(UIButton *)sender; //点赞按钮事件


#pragma mark ----- 辅助方法

- (UIImage*)cutImage:(UIImage *)orImage WithRadius:(int)radius;//图片重绘切圆


@end
