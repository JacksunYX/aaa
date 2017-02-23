//
//  SecondaryComentCell.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/17.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "SecondaryComentCell.h"
#import "UIImageView+WebCache.h"

@interface SecondaryComentCell ()

@end

@implementation SecondaryComentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initLayuot];
        
    }
    
    return self;
    
}

-(void)initLayuot   //控件的初始化
{

    _backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 0)];
    _backView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    //用户头像
    _userImg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 45, 45)];
    [_backView addSubview:_userImg];
    
    
    //评论用户名
    _nickname = [[UILabel alloc] initWithFrame:CGRectMake(_userImg.frame.origin.x+_userImg.frame.size.width+20, 10, Width-(_userImg.frame.origin.x+_userImg.frame.size.width+20*2), 0)];
    _nickname.font =[UIFont boldSystemFontOfSize:16];
    _nickname.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), TitleTextColorNight);
    [_backView addSubview:_nickname];
    
    
    //用户性别图标
    _genderView =[[UIImageView alloc]init];
    [_backView addSubview:_genderView];
    
    
    //发表时间
    _creatTime =[[UILabel alloc]initWithFrame:CGRectMake(_userImg.frame.origin.x+_userImg.frame.size.width+20, 0, Width-(_userImg.frame.origin.x+_userImg.frame.size.width+20*2), 0)];
    _creatTime.font =[UIFont systemFontOfSize:14];
    _creatTime.dk_textColorPicker=DKColorWithColors(RGBA(80, 80, 80, 1), UnimportantContentTextColorNight);
    [_backView addSubview:_creatTime];
    
    
    //评论内容
    _content = [[UILabel alloc] initWithFrame:CGRectMake(_userImg.frame.origin.x+_userImg.frame.size.width+20, 0, Width-(_userImg.frame.origin.x+_userImg.frame.size.width+20*2), 0)];
    [_backView addSubview:_content];
    if (Width==414&&Height==736) {
        _content.font =[UIFont systemFontOfSize:16];
    }else{
        _content.font =[UIFont systemFontOfSize:14];
    }
    _content.dk_textColorPicker=DKColorWithColors([UIColor blackColor], ContentTextColorNight);
    
    
    //点赞按钮
    _zanBtn = [[UIButton alloc]init];
    [_zanBtn setBackgroundImage:[UIImage imageNamed:@"praise_icon"] forState:UIControlStateNormal];
    [_zanBtn setBackgroundImage:[UIImage imageNamed:@"praised_icon"] forState:UIControlStateSelected];
    [_zanBtn sizeToFit];
    _zanBtn.frame=CGRectMake(Width-_zanBtn.frame.size.width-20, 10, _zanBtn.frame.size.width, _zanBtn.frame.size.height);
    [_backView addSubview:_zanBtn];
    
}

//给评论赋值并且实现自动换行
-(void)setIntroductionTextWithCommentModel:(CommendSourceModel *)commentModel
{

    //头像处理
    NSURL *userImgUrl =[NSURL URLWithString:[[MainUrl copy] stringByAppendingString:commentModel.userImg]];
    [_userImg sd_setImageWithURL:userImgUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //先放大到需要的size
        UIImage *img =[self scaleToSize:image size:CGSizeMake(160, 160)];
        
        //再切圆
        UIImage *img2 =[self cutImage:img WithRadius:img.size.width/2];
        
        [self.userImg setImage:img2];
        
    }];
    
    //昵称处理
    [_nickname setText:commentModel.nickname];
    [_nickname sizeToFit];
    
    
    //性别
    if (commentModel.gender.length>0) {
        
        if ([commentModel.gender isEqualToString:@"1"]) {
            
            [_genderView setImage:[UIImage imageNamed:@"userGender_M"]];    //男
            
        }else{
            
            [_genderView setImage:[UIImage imageNamed:@"userGender_W"]];    //女
            
        }
        
        [_genderView sizeToFit];
        
        _genderView.frame=CGRectMake(_nickname.frame.origin.x+_nickname.frame.size.width+5, _nickname.frame.origin.y+_nickname.frame.size.height/2-_genderView.frame.size.height/2, _genderView.frame.size.width, _genderView.frame.size.height);
        
    }else{
        
        [_genderView setImage:nil];
        
    }

    //评论时间处理
    [_creatTime setText:commentModel.createTime];
    [_creatTime sizeToFit];
    _creatTime.frame=CGRectMake(_creatTime.frame.origin.x, _nickname.frame.origin.y+_nickname.frame.size.height+10, _creatTime.frame.size.width, _creatTime.frame.size.height);
    
    
    //评论内容处理
    self.content.text = commentModel.commentContent;
    
    //设置label的最大行数
    
    self.content.numberOfLines =0;
    
    self.content.frame = CGRectMake(self.content.frame.origin.x, _creatTime.frame.origin.y+_creatTime.frame.size.height+20, Width-(_userImg.frame.origin.x+_userImg.frame.size.width+20*2), 0);
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_content.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行距
    [paragraphStyle setLineSpacing:5];
    //需要添加行距的范围(添加范围为整个文本长度)
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_content.text length])];
    
    [_content setAttributedText:attributedString];
    [_content sizeToFit];
    
    _backView.frame=CGRectMake(_backView.frame.origin.x, _backView.frame.origin.y, _backView.frame.size.width, _content.frame.origin.y+_content.frame.size.height+10);

    [self.contentView addSubview:_backView];
    
    self.frame=CGRectMake(0, 0, Width, _backView.frame.size.height);
}



//图片重绘切圆
- (UIImage*)cutImage:(UIImage *)orImage WithRadius:(int)radius
{
    UIGraphicsBeginImageContext(orImage.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.f;
    float y1 = 0.f;
    float x2 = x1+orImage.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+orImage.size.height;
    float x4 = x1;
    float y4 = y3;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0.f, orImage.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0.f, 0.f, orImage.size.width, orImage.size.height), orImage.CGImage);
    
    
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}

//重绘至期望大小(方法3)
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


@end
