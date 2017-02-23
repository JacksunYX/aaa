//
//  UserCommentCell.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/2/22.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "NewsSourceModel.h"
#import "CommendSourceModel.h"

#import "UserCommentCell.h"

#import "UIImageView+WebCache.h"

@implementation UserCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //创建基本视图
        [self loadCommentView];
        
        self.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
        
    }

    return self;
}


-(void)loadCommentView  //加载评论视图
{

    //点赞数
    _ups = [[UILabel alloc]init];
    _ups.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 0.5), UnimportantContentTextColorNight);
    [_ups setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_ups];
    
    //点赞图标
    _upsView = [[UIImageView alloc]init];
    [_upsView setImage:[UIImage imageNamed:@"my_praised_icon"]];
    [_upsView sizeToFit];
    [self .contentView addSubview:_upsView];
    
    //子评论数
    _childNum = [[UILabel alloc]init];
    _childNum.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 0.5), UnimportantContentTextColorNight);
    [_childNum setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_childNum];
    
    //子评论图标
    _childNumView = [[UIImageView alloc]init];
    [_childNumView setImage:[UIImage imageNamed:@"my_replyed_icon"]];
    [_childNumView sizeToFit];
    [self .contentView addSubview:_childNumView];
    
    //发表时间
    _createTime =[[UILabel alloc]init];
    _createTime.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 0.5), UnimportantContentTextColorNight);
    [_createTime setFont:[UIFont systemFontOfSize:12]];
    [self .contentView addSubview:_createTime];
    
    //发表内容
    _commentContent = [[UILabel alloc]init];
    _commentContent.dk_textColorPicker=DKColorWithColors(RGBA(50, 50, 50, 0.5), ContentTextColorNight);
    [_commentContent setFont:[UIFont systemFontOfSize:16]];
    [self .contentView addSubview:_commentContent];
    

    //加载下方相关新闻
    _backView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, Width-20*2, 50)];
    _backView.dk_backgroundColorPicker=DKColorWithColors(RGBA(238, 238, 238, 1), RGBA(100, 100, 100, 1));
    [self.contentView addSubview:_backView];
    
    
}



-(void)setCommentViewWithNewsCommentModel:(CommendSourceModel *)commentModel AndParentComment:(NSDictionary *)dict   //设置评论内容
{
    
    //点赞数
    [_ups setText:[NSString stringWithFormat:@"%@",commentModel.ups]];
    [_ups sizeToFit];
    _ups.frame = CGRectMake(Width-20-_ups.frame.size.width, 10, _ups.frame.size.width, _ups.frame.size.height);

    
    //点赞图标
    _upsView.frame = CGRectMake(_ups.frame.origin.x-_upsView.frame.size.width-5, _ups.frame.origin.y+(_ups.frame.size.height-_upsView.frame.size.height)/2, _upsView.frame.size.width, _upsView.frame.size.height);
    
    
    //子评论数
    [_childNum setText:commentModel.childNum];
    [_childNum sizeToFit];
    _childNum.frame = CGRectMake(_upsView.frame.origin.x-10-_childNum.frame.size.width, 10, _childNum.frame.size.width, _childNum.frame.size.height);
    
    
    //子评论图标
    _childNumView.frame = CGRectMake(_childNum.frame.origin.x-5- _childNumView.frame.size.width, _childNum.frame.origin.y+(_childNum.frame.size.height-_childNumView.frame.size.height)/2, _childNumView.frame.size.width, _childNumView.frame.size.height);
    
    
    //发表时间
    [_createTime setText:commentModel.createTime];
    [_createTime sizeToFit];
    _createTime.frame = CGRectMake(25, 10, _createTime.frame.size.width, _createTime.frame.size.height);
    
    NSMutableAttributedString *commentContent = [[NSMutableAttributedString alloc] initWithString:commentModel.commentContent];
    
    if ([dict allKeys].count>0) {   //说明有父类评论
        //对父类评论的评论者做颜色区分
        NSMutableAttributedString *parentCommentNickname =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" || @ %@ : ",[dict objectForKey:@"nickname"]]];
        [parentCommentNickname addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:RGBA(255, 151, 203, 1.0)} range:NSMakeRange(0, [parentCommentNickname length])];
        
        //把父类评论者发表的评论直接拼接在后面
        NSMutableAttributedString *parentCommentContent =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"commentContent"]]];
        
        [parentCommentNickname appendAttributedString:parentCommentContent];
        
        //最后再拼接到子评论的后面
        [commentContent appendAttributedString:parentCommentNickname];
        
    }
    
    //设置label的最大行数
    _commentContent.numberOfLines =0;
    _commentContent.frame = CGRectMake(25, _createTime.frame.origin.y+_createTime.frame.size.height+10, Width-25*2, 0);
    
    // 调整行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行距
    [paragraphStyle setLineSpacing:5];
    //需要添加行距的范围(添加范围为整个文本长度)
    [commentContent addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [commentContent length])];
    [_commentContent setAttributedText:commentContent];
    [_commentContent sizeToFit];
    
    
    _backView.frame = CGRectMake(_backView.frame.origin.x, _commentContent.frame.origin.y+_commentContent.frame.size.height+10, _backView.frame.size.width, _backView.frame.size.height);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, Width, _backView.frame.origin.y+_backView.frame.size.height+10);
}


-(void)setNewsViewWithNewsModel:(NewsSourceModel *)newsModel  //加载相关新闻的内容
{

    if (!newsModel.imageSrc) {
        return;
    }
    
    if (_backView.subviews.count>0) {
        
        for (UIView *view in _backView.subviews) {
            
            [view removeFromSuperview];
            
        }
        
    }
    
    //新闻图片
    UIImageView *newsImage =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    NSURL *imgUrl = [NSURL URLWithString:[[MainUrl copy] stringByAppendingString:newsModel.imageSrc]];
    [newsImage sd_setImageWithURL:imgUrl];
    [_backView addSubview:newsImage];
    
    
    //标题
    UILabel *newsTitle =[[UILabel alloc]initWithFrame:CGRectMake(newsImage.frame.origin.x+newsImage.frame.size.width+15, newsImage.frame.origin.y, _backView.frame.size.width-5*2-newsImage.frame.size.width-15*2, 0)];
    [newsTitle setFont:[UIFont systemFontOfSize:14]];
    newsTitle.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), TitleTextColorNight);
    [newsTitle setText:newsModel.title];
    [newsTitle sizeToFit];
    [newsTitle setFrame:CGRectMake(newsTitle.frame.origin.x, newsTitle.frame.origin.y, newsTitle.frame.size.width, newsImage.frame.size.height)];
    [_backView addSubview:newsTitle];
    
}


@end
