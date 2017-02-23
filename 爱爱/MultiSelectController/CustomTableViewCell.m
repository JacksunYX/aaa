//
//  CustomTableViewCell.m
//  MultiSelectExample
//
//  Created by 薇薇一笑 on 16/4/12.
//  Copyright © 2016年 Darshan Patel. All rights reserved.
//

#import "CustomTableViewCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation CustomTableViewCell

{
    
    UILabel *titleLabel;    //标题

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self customCellView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;

}

//自定义cell内容控件
-(void)customCellView
{
    
    UIView *contentView = self.contentView;

    //配图
    _backView = [UIImageView new];
    
    //提示
    UILabel *notice = [UILabel new];
    notice.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:0.4];
    notice.numberOfLines = 0;
    notice.font = [UIFont systemFontOfSize:14];
    notice.textAlignment = 1;
    notice.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0];
    
    //标题
    titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0];
    
    NSArray *viewArr = @[_backView,notice,titleLabel];
    
    [contentView sd_addSubviews:viewArr];
    
    //开始布局
    _backView.sd_layout
    .topSpaceToView(contentView,10)
    .leftSpaceToView(contentView,10)
    .widthIs(ScreenWidth/4)
    .heightEqualToWidth()
    ;
    
    notice.sd_layout
    .topEqualToView(_backView)
    .leftEqualToView(_backView)
    .widthRatioToView(_backView,1.0)
    .heightRatioToView(_backView,1.0)
    ;
    
    titleLabel.sd_layout
    .topEqualToView(_backView)
    .leftSpaceToView(_backView,10)
    .autoHeightRatio(0)
    ;
    
    [notice setText:@"点击查看详情"];
    
    //单行文本自适应
    [titleLabel setSingleLineAutoResizeWithMaxWidth:ScreenWidth/3];
    
    //整体高度自适应
    [self setupAutoHeightWithBottomViewsArray:viewArr bottomMargin:10];
    
}

-(void)setModel:(NSDictionary *)model
{

    _model = model;
    
    NSString *imageName = [model objectForKey:@"image"];
    
    NSString *title = [model objectForKey:@"title"];
    
    [_backView setImage:[UIImage imageNamed:imageName]];
    
    [titleLabel setText:title];
    
    _backView.tag = [[model objectForKey:@"serviceId"]integerValue];
    
}























@end
