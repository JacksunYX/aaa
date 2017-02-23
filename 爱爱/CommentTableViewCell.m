//
//  CommentTableViewCell.m
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/10.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.
//
//当前设备的屏幕宽度


#import "WZLBadgeImport.h"

#import "CommentTableViewCell.h"
#import "CommendSourceModel.h"

@implementation CommentTableViewCell

-(instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier //创建方法
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initLayuot];
        
    }
    
    return self;
    
}


-(void)initLayuot   //初始化控件
{
    
    for(int i = 0;i<=[_backView.subviews count];i++){
    
        [_backView.subviews[i] removeFromSuperview];
    }

    
    self.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    _backView =[[UIView alloc]initWithFrame:CGRectMake(10, 0, Width-20, 0)];
    _backView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    //用户头像
    _userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
    _userImage.contentMode=UIViewContentModeScaleAspectFit;
    
    [_backView addSubview:_userImage];
    
    
    //评论用户名
    _name = [[UILabel alloc] initWithFrame:CGRectMake(_userImage.frame.origin.x+_userImage.frame.size.width+10, _userImage.frame.origin.y, 0, 0)];
    _name.font =[UIFont systemFontOfSize:12];
    [_backView addSubview:_name];
    _name.dk_textColorPicker = DKColorWithColors(RGBA(100, 100, 100, 1), RGBA(218, 218, 218, 1));
    
    
    //用户性别图标
    _genderView =[[UIImageView alloc]init];
    [_backView addSubview:_genderView];
    
    
    //发表时间
    _issueTime =[[UILabel alloc]initWithFrame:CGRectMake(_name.frame.origin.x, 0, 0, 0)];
    _issueTime.font =[UIFont systemFontOfSize:10];
    _issueTime.dk_textColorPicker =DKColorWithColors(RGBA(100, 100, 100, 1), UnimportantContentTextColorNight);
    [_backView addSubview:_issueTime];
    
    
    
    //评论内容
    _introduction = [[UILabel alloc] initWithFrame:CGRectMake(_issueTime.frame.origin.x, _issueTime.frame.origin.y+_issueTime.frame.size.height+10, _backView.frame.size.width-_name.frame.origin.x-10, 0)];
    _introduction.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), ContentTextColorNight);
    
    [_backView addSubview:_introduction];
    if (Width==414&&Height==736) {
        _introduction.font =[UIFont systemFontOfSize:16];
    }else{
        _introduction.font =[UIFont systemFontOfSize:14];
    }

    
    //点赞按钮
    _zanBtn=[[UIButton alloc]initWithFrame:CGRectMake(_introduction.frame.origin.x, _introduction.frame.origin.y+_introduction.frame.size.height+10, 24, 24)];
    [_zanBtn setBackgroundImage:[UIImage imageNamed:@"praise_icon"] forState:UIControlStateNormal];
    [_zanBtn setBackgroundImage:[UIImage imageNamed:@"praised_icon"] forState:UIControlStateSelected];
    
    [_backView addSubview:_zanBtn];
    
    
    //评论图标
    _comment =[[UIImageView alloc]initWithFrame:CGRectMake(_zanBtn.frame.origin.x+_zanBtn.frame.size.width+30, _zanBtn.frame.origin.y, 24, 24)];
    [_comment setImage:[UIImage imageNamed:@"reply_icon"]];
    [_backView addSubview:_comment];
    _comment.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    
    
    //评论数
    _comments =[[UILabel alloc]initWithFrame:CGRectMake(_comment.frame.origin.x+_comment.frame.size.width+5, _comment.frame.origin.y+_comment.frame.size.height/2-10, 48, 20)];
    _comments.dk_textColorPicker=DKColorWithColors([UIColor blackColor], UnimportantContentTextColorNight);
    
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
        _comments.layer.borderColor=[[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0]CGColor];
    } else {
        _comments.layer.borderColor=[[UIColor colorWithRed:230.0f/255.0f green:23.0f/255.0f blue:115.0f/255.0f alpha:1.0]CGColor];
    }
    _comments.layer.borderWidth = 0.2f;//边框粗细度
    _comments.layer.cornerRadius=10;//圆角
    _comments.font=[UIFont systemFontOfSize:12];//字体大小
    _comments.textAlignment=1;//字体居中
    [_backView addSubview:_comments];
 
//    NSLog(@"固定高度:%f",_introduction.frame.origin.y);
}



//通过传过来的数据模型填充评论内容
-(void)setContentWithCommentModle:(CommendSourceModel *)commentModel//赋值以及自动换行,计算出cell的高度
{
    
    //用户昵称
    [_name setText:commentModel.nickname];
    [_name sizeToFit];
    _name.frame=CGRectMake(_name.frame.origin.x, _name.frame.origin.y, _name.frame.size.width, 20);
    
    if (commentModel.gender.length>0) {
        
        if ([commentModel.gender isEqualToString:@"1"]) {
            
            [_genderView setImage:[UIImage imageNamed:@"userGender_M"]];    //男
            
        }else{
        
            [_genderView setImage:[UIImage imageNamed:@"userGender_W"]];    //女
        
        }
        
        [_genderView sizeToFit];
        
        _genderView.frame=CGRectMake(_name.frame.origin.x+_name.frame.size.width+5, _name.frame.origin.y+_name.frame.size.height/2-_genderView.frame.size.height/2, _genderView.frame.size.width, _genderView.frame.size.height);
        
    }else{
    
        [_genderView setImage:nil];
    
    }
    
    
    //发布时间
    [_issueTime setText:commentModel.createTime];
    [_issueTime sizeToFit];
    _issueTime.frame=CGRectMake(_issueTime.frame.origin.x, _name.frame.origin.y+_name.frame.size.height+10, _issueTime.frame.size.width, 15);
    
    
    //发布内容
    self.introduction.frame = CGRectMake(_issueTime.frame.origin.x, _issueTime.frame.origin.y+_issueTime.frame.size.height+10, _backView.frame.size.width-_name.frame.origin.x-10, 0);
    
    self.introduction.text = commentModel.commentContent;
    
    //设置label的最大行数
    
    self.introduction.numberOfLines =0;
    
//    CGSize size = CGSizeMake(, 100000);
//    
//    CGSize labelSize = [self.introduction.text sizeWithFont:self.introduction.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
//    
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_introduction.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行距
    [paragraphStyle setLineSpacing:5];
    //需要添加行距的范围(添加范围为整个文本长度)
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_introduction.text length])];
    
    [_introduction setAttributedText:attributedString];
    [_introduction sizeToFit];      //自适应高度
    
    //点赞按钮
    _zanBtn.frame = CGRectMake(_introduction.frame.origin.x, _introduction.frame.origin.y+_introduction.frame.size.height+10, 24, 24);
    //评论图标
    _comment.frame =CGRectMake(_zanBtn.frame.origin.x+_zanBtn.frame.size.width+30, _zanBtn.frame.origin.y, 24, 24);
    //评论数
    _comments.frame =CGRectMake(_comment.frame.origin.x+_comment.frame.size.width+5, _comment.frame.origin.y+_comment.frame.size.height/2-10, 48, 20);
    
    
    _backView.frame=CGRectMake(_backView.frame.origin.x, _backView.frame.origin.y, _backView.frame.size.width, _zanBtn.frame.origin.y+_zanBtn.frame.size.height+5);
    
//    _backView.layer.borderColor=[UIColor redColor].CGColor;
//    _backView.layer.shadowOpacity=0.3;
//    _backView.layer.shadowOffset=CGSizeMake(0, 1);
//    _backView.layer.shadowColor=[UIColor blackColor].CGColor;
//    _backView.layer.cornerRadius=5;
//    _backView.clipsToBounds=YES;
//    _backView.sd_cornerRadius = @(5);
    
    CGRect  frame=CGRectMake(0, 0, Width, _backView.frame.size.height+5);
    
    
    [self addSubview:_backView];
    
    self.frame = frame;
    
    self.zanBtn.selected = commentModel.isUps;
    
    [self.comments setText:commentModel.childNum];
    
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
