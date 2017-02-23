//
//  TableViewCell5.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/19.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//



#import "TableViewCell5.h"
#import "DetailNewsViewController.h"//新闻详情界面

//#import "UIImageView+WebCache.h"//图片处理库

#import "UIImageView+ProgressView.h"    //带进度圈的图片加载





@implementation TableViewCell5

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//重写初始化方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if (self.contentView.subviews.count) {
            
            for (UIView *view in self.contentView.subviews) {
                
                [view removeFromSuperview];
                
            }
            
        }
        
        CGRect frame =CGRectMake(0, 0, Width, 0);
        _backView =[[UIView alloc]initWithFrame:CGRectMake(10, 0, Width-20, 0)];
        _backView.backgroundColor=[UIColor whiteColor];
        //左上角多图标注
        _icon=[[UIImageView alloc]initWithFrame:CGRectMake(5, 8, 25, 20)];
        [_icon setImage:[UIImage imageNamed:@"picture_icon"]];
        [_backView addSubview:_icon];
        
        
        //标题
        _title=[[UILabel alloc]initWithFrame:CGRectMake(_icon.frame.origin.x+_icon.frame.size.width+5, 10,_backView.frame.size.width-(_icon.frame.origin.x+_icon.frame.size.width+5) , 14)];
        
        _title.font=[UIFont systemFontOfSize:16];
        [_backView addSubview:_title];
        
        
        //三张图片的方位确定
        CGFloat imgwidth =(Width-10*2-1*2)/3;
        _imvL=[[UIImageView alloc]initWithFrame:CGRectMake(0, _title.frame.origin.y+_title.frame.size.height+10, imgwidth, imgwidth)];
        [_backView addSubview:_imvL];
        _imvC=[[UIImageView alloc]initWithFrame:CGRectMake(_imvL.frame.origin.x+_imvL.frame.size.width+1, _imvL.frame.origin.y, imgwidth, imgwidth)];
        [_backView addSubview:_imvC];
        _imvR=[[UIImageView alloc]initWithFrame:CGRectMake(_imvC.frame.origin.x+_imvC.frame.size.width+1, _imvL.frame.origin.y, imgwidth, imgwidth)];
        [_backView addSubview:_imvR];
        
        //右下方浏览量
        _clicks=[[UILabel alloc]initWithFrame:CGRectMake(_backView.frame.size.width-50, _imvR.frame.origin.y+_imvR.frame.size.height+10, 40, 20)];
        
        _clicks.font=[UIFont systemFontOfSize:12];
        [_backView addSubview:_clicks];
        
        
        //眼睛
        _eye=[[UIImageView alloc]initWithFrame:CGRectMake(_clicks.frame.origin.x-5-15, (_clicks.frame.origin.y+_clicks.frame.size.height/2)-5, 15, 10)];
        [_eye setImage:[UIImage imageNamed:@"eye_icon"]];
        [_backView addSubview:_eye];
        
        //离线模式下隐藏
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
            
            [_eye setHidden:YES];
            
        }
        
        
        //更新cell的高度
        frame.size.height=_clicks.frame.origin.y+_clicks.frame.size.height+10;
        //更新背景框高度
        CGRect back =CGRectMake(10, 0, Width-20, frame.size.height);
        _backView.frame=back;
        
        //调整显示
        _backView.layer.borderColor=[[UIColor grayColor]CGColor];
        _backView.layer.borderWidth=0.1;
        _backView.layer.cornerRadius=3;
//        _backView.clipsToBounds = NO;
        
//        _backView.layer.shadowColor = [UIColor grayColor].CGColor;
//        _backView.layer.shadowOpacity = 0.5;
//        _backView.layer.shadowRadius = 5.0;
//        _backView.layer.shadowOffset = CGSizeMake(0, 1);
        
//        frame.size.height=frame.size.height+10;
        
//        self.frame=frame;
        
        [self.contentView addSubview:_backView];
        
    }
    return self;
}

//自定义设置界面方法
-(void)setViewWithModel:(NewsSourceModel *)newsModel
{

    self.title.text=newsModel.title;
    //设置图片
    
    NSString *imgurlL;
    NSString *imgurlC;
    NSString *imgurlR;
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
        
        //离线状态
        [self.imvL setImage:[newsModel.contentPictures[0] objectForKey:@"image"]];
        [self.imvC setImage:[newsModel.contentPictures[1] objectForKey:@"image"]];
        [self.imvR setImage:[newsModel.contentPictures[2] objectForKey:@"image"]];
        
    }else{  //有网状态
    
        if (newsModel.pictures[0]) {
            imgurlL = [MainUrl stringByAppendingString:newsModel.pictures[0]];
        }
        if (newsModel.pictures[1]) {
            imgurlC = [MainUrl stringByAppendingString:newsModel.pictures[1]];
        }
        if (newsModel.pictures[2]) {
            imgurlR = [MainUrl stringByAppendingString:newsModel.pictures[2]];
        }
        
        [self.imvL sd_setImageWithURL:[NSURL URLWithString:imgurlL] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(40, 40)];
        [self.imvC sd_setImageWithURL:[NSURL URLWithString:imgurlC] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(40, 40)];
        [self.imvR sd_setImageWithURL:[NSURL URLWithString:imgurlR] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(40, 40)];
        
        
        //浏览量
        if ([newsModel.views intValue]/10000>0) {
            
            self.clicks.text=[NSString stringWithFormat:@"%.1f万",[newsModel.views intValue]/10000.0];
            
        }else{
            
            self.clicks.text=[NSString stringWithFormat:@"%d",[newsModel.views intValue]];
            
        }
    
    }
    
    
    
//    NSLog(@"1:%@  2:%@  3:%@  ",imgurlL,imgurlC,imgurlR);
    
    //图片填充模式
//    self.imvL.contentMode = UIViewContentModeScaleToFill;
//    self.imvC.contentMode = UIViewContentModeScaleToFill;
//    self.imvR.contentMode = UIViewContentModeScaleToFill;
    
    
    _backView.tag=[newsModel.newsId intValue];//将传过来的newsId进行存储

    
}



//对图片做压缩处理(按照需求的比例缩小)
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
