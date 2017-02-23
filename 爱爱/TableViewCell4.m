//
//  TableViewCell4.m
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/14.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.
//



#import "TableViewCell4.h"


#import "WZLBadgeImport.h"      //按钮小红点库


@implementation TableViewCell4

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//重写初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //图片
        _ImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 100, 100)];
        [self.contentView addSubview:_ImageView];
        
        //标题
        _TextLabel = [[UILabel alloc]initWithFrame:CGRectMake(_ImageView.frame.origin.x+_ImageView.frame.size.width+15, _ImageView.frame.origin.y, Width/2, 20)];
        _TextLabel.numberOfLines=0;
        _TextLabel.font =[UIFont systemFontOfSize:18];
        _TextLabel.dk_textColorPicker=DKColorWithColors([UIColor blackColor], TitleTextColorNight);
        [self.contentView addSubview:_TextLabel];
        
        //来源
        _source =[[UILabel alloc]initWithFrame:CGRectMake(_TextLabel.frame.origin.x, _TextLabel.frame.origin.y+_TextLabel.frame.size.height+10, Width/2, 10)];
        _source.font=[UIFont systemFontOfSize:14];
        _source.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), UnimportantContentTextColorNight);
        [self.contentView addSubview:_source];
        self.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
        
    }
    return self;
}

-(void)creatViewWithCommentNum:(NSInteger)commentNum AndPublishTime:(NSString *)publishTime //创建下方控件
{

    //评论数
    _comments =[[UIButton alloc]init];
    [_comments setBackgroundImage:[UIImage imageNamed:@"comment_icon"] forState:UIControlStateNormal];
    
    [_comments sizeToFit];
    _comments.frame=CGRectMake(_TextLabel.frame.origin.x, _ImageView.frame.origin.y+_ImageView.frame.size.height-_comments.frame.size.height, _comments.frame.size.width, _comments.frame.size.height);
    
    [self addBdageNumOnBtn:_comments AndNum:commentNum];
    [self.contentView addSubview:_comments];
    
    //发布时间
    _issueTime =[[UILabel alloc]initWithFrame:CGRectMake(_comments.frame.origin.x+_comments.frame.size.width+20, _comments.frame.origin.y, Width/2, _comments.frame.size.height)];
    _issueTime.font =[UIFont systemFontOfSize:12];
    _issueTime.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), UnimportantContentTextColorNight);
    _issueTime.text=publishTime;
    [self.contentView addSubview:_issueTime];

}


-(void)addBdageNumOnBtn:(UIButton *)btn AndNum:(NSInteger)value    //根据数量改变小红点的显示数量
{
    
    [btn showBadgeWithStyle:WBadgeStyleNumber value:value animationType:WBadgeAnimTypeBreathe];
    if (value>0) {
        
        btn.aniType = WBadgeAnimTypeBreathe;    //抖动效果
        
    }else{
        
        btn.aniType = WBadgeAnimTypeNone;       //无效果
        
    }
    btn.badgeBgColor = [UIColor purpleColor];      //底色
    btn.badgeCenterOffset = CGPointMake(0, 5);    //偏移量
    btn.badgeTextColor = [UIColor whiteColor];     //字体颜色
    
}

@end
