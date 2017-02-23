//
//  TableViewCell8.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/1.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "TableViewCell8.h"

#import "UserSourceModel.h"

@implementation TableViewCell8

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        [self loadCell];
        
        self.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
        
        self.selectedBackgroundView.dk_backgroundColorPicker=DKColorWithColors([UIColor grayColor], UnimportantContentTextColorNight);
    }

    return self;
}

-(void)loadCell
{
    //标题
    _titleLabel = [[UILabel alloc]init];

    _titleLabel.font = [UIFont fontWithName:PingFangSCX size:16];
    
    _titleLabel.dk_textColorPicker=DKColorWithColors(RGBA(50, 50, 50, 1), TitleTextColorNight);
    
    _titleLabel.numberOfLines=1;
    
    [self.contentView addSubview:_titleLabel];
    
    //辅助视图
    _assistView = [[UIImageView alloc]init];
    
    [_assistView setImage:[UIImage imageNamed:@"pull_down"]];
    
    [_assistView sizeToFit];
    
    _assistView.frame=CGRectMake(Width-_assistView.frame.size.width, 33-_assistView.frame.size.height/2, _assistView.frame.size.width, _assistView.frame.size.height);
    
    [self.contentView addSubview:_assistView];
    
    //展示内容
    _contentLabel = [[UILabel alloc]init];
    
    _contentLabel.font = [UIFont fontWithName:PingFangSCX size:12];
    
    _contentLabel.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), ContentTextColorNight);
    
    _contentLabel.numberOfLines=1;
    
    [self.contentView addSubview:_contentLabel];
    
}

-(void)settitleWithText:(NSString *)string     //填充标题
{

    [_titleLabel setText:string];
    [_titleLabel sizeToFit];
    _titleLabel.frame=CGRectMake(20, 33-_titleLabel.frame.size.height/2, _titleLabel.frame.size.width, _titleLabel.frame.size.height);

}

-(void)setintrodictionWithText:(NSString *)string     //填充内容
{

    if (string) {
        [_contentLabel setText:string];
    }else{
        [_contentLabel setText:@"保密"];
    }
    
    [_contentLabel sizeToFit];
    
    _contentLabel.frame = CGRectMake(_assistView.frame.origin.x-5-_contentLabel.frame.size.width, 33-_contentLabel.frame.size.height/2, _contentLabel.frame.size.width, _contentLabel.frame.size.height);

}




@end
