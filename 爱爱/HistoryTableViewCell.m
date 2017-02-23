//
//  HistoryTableViewCell.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/16.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "NewsSourceModel.h"

@implementation HistoryTableViewCell

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
        _ImageView =[[UIImageView alloc]initWithFrame:CGRectMake(16, 12, 75, 75)];
        [self.contentView addSubview:_ImageView];
        
        [self creatView];
        
    }
    return self;
}

-(void)creatView
{
    
    //标题
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.numberOfLines=0;
    _titleLabel.font =[UIFont systemFontOfSize:14];
    _titleLabel.dk_textColorPicker=DKColorWithColors(TitleTextColorNormal, TitleTextColorNight);

    [self.contentView addSubview:_titleLabel];
    
    //来源
    _source =[[UILabel alloc]init];
    _source.font=[UIFont systemFontOfSize:12];
    _source.dk_textColorPicker=DKColorWithColors(ContentTextColorNormal, UnimportantContentTextColorNight);

    [self.contentView addSubview:_source];
    
    //发布时间
    _publishTime =[[UILabel alloc]init];
    _publishTime.font=[UIFont systemFontOfSize:12];
    _publishTime.dk_textColorPicker=DKColorWithColors(UnimportantContentTextColorNormal, UnimportantContentTextColorNight);

    [self.contentView addSubview:_publishTime];
    self.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);

}

-(void)setViewWithNewsModel:(NewsSourceModel *)newsModel   //根据传过来的新闻数据设置cell
{

        self.titleLabel.frame=CGRectMake(self.ImageView.frame.origin.x+self.ImageView.frame.size.width+16, self.ImageView.frame.origin.y, Width-(self.ImageView.frame.origin.x+self.ImageView.frame.size.width+16*2), 0);
        [self.titleLabel setText:newsModel.title];
        [self.titleLabel sizeToFit];
        self.titleLabel.frame=CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
    
        self.source.frame=CGRectMake(self.titleLabel.frame.origin.x, 0, Width-(self.ImageView.frame.origin.x+self.ImageView.frame.size.width+16*2), 0);
        [self.source setText:newsModel.source];
        [self.source sizeToFit];
        self.source.frame=CGRectMake(self.source.frame.origin.x, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+8, self.source.frame.size.width, self.source.frame.size.height);
    
    
        [self.publishTime setText:newsModel.publishTime];
        [self.publishTime sizeToFit];
        self.publishTime.frame=CGRectMake(self.titleLabel.frame.origin.x, self.ImageView.frame.origin.y+self.ImageView.frame.size.height-self.publishTime.frame.size.height, self.publishTime.frame.size.width, self.publishTime.frame.size.height);

}

@end
