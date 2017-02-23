//
//  FirstCommentViewController+Methods.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/18.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "FirstCommentViewController.h"

#import "NewsSourceModel.h"
#import "CommendSourceModel.h"


#import "UIImageView+WebCache.h"


@interface FirstCommentViewController (Methods)

#pragma  mark ----- 视图创建方法

-(void)loadbaseView;                    //加载基本视图

-(void)addBdageNumOnBtn:(UIButton *)btn AndNum:(NSInteger)value;    //根据数量改变小红点的显示数量


#pragma mark ----- 交互方法
-(IBAction)changeSelectState:(UIButton *)sender;  //点赞按钮事件




#pragma  mark ----- 图片处理方法

//图片重绘切圆
- (UIImage*)cutImage:(UIImage *)orImage WithRadius:(int)radius;

//重绘传入的image,切圆(方法2)
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset;

//重绘至期望大小(方法3)
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;




@end
