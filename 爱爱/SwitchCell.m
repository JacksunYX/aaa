//
//  SwitchCell.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/2/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadCell];
        
        self.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
        
    }
    
    return self;
}

-(void)loadCell
{
    
    //开关按钮
    _Switch =[[UISwitch alloc]init];
    _Switch.onTintColor=MainThemeColor;
    _Switch.frame=CGRectMake(Width-_Switch.frame.size.width-15, 40-_Switch.frame.size.height/2, _Switch.frame.size.width, _Switch.frame.size.height);
    [self.contentView addSubview:_Switch];
//    _Switch.on = [self isAllowedNotification];
//    _Switch.userInteractionEnabled = NO;
    
    //标题
    _titleLabel = [[UILabel alloc]init];
    
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    _titleLabel.dk_textColorPicker=DKColorWithColors(RGBA(50, 50, 50, 1), TitleTextColorNight);
    
    _titleLabel.numberOfLines=1;
    
    [self.contentView addSubview:_titleLabel];
    
    
    //标题下方的描述
    _detailContent =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width-20*2-_Switch.frame.size.width-15, 0)];
    _detailContent.font = [UIFont fontWithName:PingFangSCQ size:12];
    _detailContent.dk_textColorPicker=DKColorWithColors([UIColor redColor], UnimportantContentTextColorNight);
    _detailContent.numberOfLines=0;
    [self.contentView addSubview:_detailContent];
    
}

-(void)settitleWithText:(NSString *)string AndOnOrNot:(BOOL)onOrNot    //填充标题
{

    [_titleLabel setText:string];
    [_titleLabel sizeToFit];
    _titleLabel.frame=CGRectMake(20, 33-_titleLabel.frame.size.height/2, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    
    _Switch.on = onOrNot;
    _detailContent.frame = CGRectMake(0, 0, Width-20*2-_Switch.frame.size.width-15, 0);
    
    if (onOrNot) {
        
        [_detailContent setText:@"后台会不时的给您推送些有趣的东西哟~"];
        [_detailContent sizeToFit];
        
    }else{
    
        [_detailContent setText:@"您可能错过重要资讯通知哟~"];
        [_detailContent sizeToFit];
    
    }
    
    _detailContent.frame=CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+5, _detailContent.frame.size.width, _detailContent.frame.size.height);

}








@end
