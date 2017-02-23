//
//  NewsTableViewCell.m
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/10.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.
//
//当前设备的屏幕宽度


#import "NewsTableViewCell.h"

#import "TFHpple.h"
#import "UIImageView+WebCache.h"
@implementation NewsTableViewCell

- (void)awakeFromNib {
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
        
        
        
        [self initLayuot];
        
    }
    return self;
}   //创建方法



-(void)setIntroductionText:(NSString*)text{
    
    //获得当前cell高度
    
    CGRect frame = [self frame];
    
    //文本赋值
    
    self.introduction.text = text;
    
    //设置label的最大行数
    
    self.introduction.numberOfLines = 0;
    
    self.introduction.frame = CGRectMake(self.introduction.frame.origin.x, self.introduction.frame.origin.y, Width-10*2, 0);
    
    
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_introduction.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行距
    [paragraphStyle setLineSpacing:10];
    //添加行距(添加范围为整个文本长度)
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_introduction.text length])];
    
    [_introduction setAttributedText:attributedString];
    [_introduction sizeToFit];//提醒将当前textView的大小调整到改变后的大小(自动适应)
    //整个cell的高度要算上所有自适应高度的控件
    frame.size.height = _introduction.frame.size.height+_backImage.frame.origin.y+_backImage.frame.size.height+50;
    //更新cell的高度
    self.frame = frame;
}   //赋值 and 自动换行,计算出cell的高度

#pragma mark --- 视图创建

-(void)initLayuot   //初始化控件
{

//    for(int i = 0;i<=[_backView.subviews count];i++){   //避免已经存在的控件被循环创建,先移除
//        
//        [_backView.subviews[i] removeFromSuperview];
//    }
    
    NSLog(@"创建新闻详情~~~~~");
    
    _backView =[[UIView alloc]initWithFrame:CGRectMake(10, 10, Width-10*2, 0)];
    
    
    //标题
    _title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, Width-20*2, 50)];
    _title.numberOfLines=0;         //自动换行
    [_title setTextAlignment:0];    //置左
    
    _title.dk_textColorPicker = DKColorWithColors([UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0], [UIColor colorWithRed:218.0f/255.0f green:218.0f/255.0f blue:218.0f/255.0f alpha:1.0f]);
    [_backView addSubview:_title];
    
    
    //新闻来源
    _source =[[UILabel alloc]initWithFrame:CGRectMake(20, _title.frame.origin.y+_title.frame.size.height+20, Width/4, 30)];
    _source.textAlignment = 0;
    _source.font =[UIFont systemFontOfSize:10];
    _source.dk_textColorPicker = DKColorWithColors([UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1], [UIColor colorWithRed:218.0f/255.0f green:218.0f/255.0f blue:218.0f/255.0f alpha:1.0f]);
    [_backView addSubview:_source];
    
    
    //发布时间
    _issueTime =[[UILabel alloc]initWithFrame:CGRectMake(_source.frame.origin.x+_source.frame.size.width+20,_source.frame.origin.y,  Width/4, 30)];
    _issueTime.font =[UIFont systemFontOfSize:10];
    _issueTime.textAlignment = 0;
    _issueTime.dk_textColorPicker = DKColorWithColors([UIColor colorWithRed:144.0f/255.0f green:144.0f/255.0f blue:144.0f/255.0f alpha:1], [UIColor colorWithRed:218.0f/255.0f green:218.0f/255.0f blue:218.0f/255.0f alpha:1.0f]);
    [_backView addSubview:_issueTime];
    
    
    
    
    
    UILabel *line =[[UILabel alloc]initWithFrame:CGRectMake(0, _source.frame.origin.y+_source.frame.size.height+10, _backView.frame.size.width, 0.3)];
    line.backgroundColor=[UIColor blackColor];
    [_backView addSubview:line];
    
    //配图
    _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, line.frame.size.height+line.frame.origin.y+20, _backView.frame.size.width, _backView.frame.size.width*2/3)];
    [_backView addSubview:_backImage];
    
    //新闻数据
    //    _introduction = [[UILabel alloc] initWithFrame:CGRectMake(10, _backImage.frame.origin.y+210, Width-10*2, 0)];
    //    _introduction.dk_textColorPicker = DKColorWithColors([UIColor blackColor], [UIColor colorWithRed:218.0f/255.0f green:218.0f/255.0f blue:218.0f/255.0f alpha:1.0f]);
    //    [_backView addSubview:_introduction];
    
//    标题字体适配
        if (Width==414&&Height==736) {
            _title.font =[UIFont systemFontOfSize:20];
            _introduction.font =[UIFont systemFontOfSize:16];
        }else if(Width==375&&Height==667){
            _title.font =[UIFont systemFontOfSize:18];
            _introduction.font =[UIFont systemFontOfSize:14];
        }else{
            _title.font =[UIFont systemFontOfSize:16];
            _introduction.font =[UIFont systemFontOfSize:14];
        }
    
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor grayColor], [UIColor colorWithRed:40.0f/255.0f green:85.0f/255.0f blue:109.0f/255.0f alpha:1.0]);
    
    _backView.layer.shadowOpacity=0.3;
    _backView.layer.shadowOffset=CGSizeMake(0, 1);
    _backView.layer.shadowColor=[UIColor blackColor].CGColor;
    
    _backView.backgroundColor=[UIColor whiteColor];
    
    _backView.layer.cornerRadius=5;

        
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

-(void)setLabelOfCellWith:(NSString *)content   //处理新闻内容
{
        
    
    _label = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(0, _backImage.frame.origin.y+_backImage.frame.size.height+50, _backView.frame.size.width, 0)];
    _label.delegate = self;
    
    CGRect frame = CGRectMake(0, 0, Width, 0);
    
    NSData *htmlData = [content dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//p"];
    for (TFHppleElement *element in elements) {
        
        if (element.text) { //纯文本用textview接收
            
            //背景
            UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, _label.frame.origin.y+_label.frame.size.height, _label.frame.size.width, 0)];
            
            CGRect frame =view.frame;   //大小记录下来
            
            UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, _backView.frame.size.width-20, 0)];
            label.font=[UIFont systemFontOfSize:16];
            label.numberOfLines=0;
            [label setText:[NSString stringWithFormat:@"    %@",element.text]];
            [label setTextColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0]];
            [label sizeToFit];
            
            frame.size.height=label.frame.size.height;
            [view addSubview:label];
            
            view.frame=frame;//更新背景高度
            
            [self.label appendView:view];
            [self.label appendText:@"\n"];//换行
            
            [self.label sizeToFit];//自适应
            
            
        }else{
            
            TFHppleElement *sss =(TFHppleElement *) [[element searchWithXPathQuery:@"//img"] firstObject];
            NSMutableString *img =[MainUrl mutableCopy];
            
            if ([sss objectForKey:@"src"]) {
                [img appendString:[sss objectForKey:@"src"]];
                
                //背景
                //                UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, _label.frame.origin.y+_label.frame.size.height, _label.frame.size.width, 0)];
                
                
                
                //                TYImageStorage *imageUrlStorage = [[TYImageStorage alloc]init];
                //
                //                imageUrlStorage.imageURL = [NSURL URLWithString:img];
                //                imageUrlStorage.imageAlignment=TYImageAlignmentCenter;
                //                CGFloat wid =Width-30*2;
                //                imageUrlStorage.cacheImageOnMemory=YES;
                //                imageUrlStorage.size = CGSizeMake(wid, wid/4*3);//比例为4:3
                //
                //                [self.label appendTextStorage:imageUrlStorage];
                
                UIImageView *imgView  =[[UIImageView alloc]initWithFrame:CGRectMake(0, _label.frame.origin.y+_label.frame.size.height, _label.frame.size.width, _label.frame.size.width*2/3)];
                [imgView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:nil];
                
                [self.label appendView:imgView];
                
                [self.label appendText:@"\n"];//仍然换行
                [self.label sizeToFit];
                
            }
        }
        
    }
    [self.label sizeToFit];
    
    [_backView addSubview:self.label];
    
    self.label.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], [UIColor colorWithRed:40.0f/255.0f green:85.0f/255.0f blue:109.0f/255.0f alpha:1.0]);
    
    self.label.dk_tintColorPicker =DKColorWithColors([UIColor blackColor], [UIColor colorWithRed:218.0f/255.0f green:218.0f/255.0f blue:218.0f/255.0f alpha:1.0f]);
    
    //下方分享
    UILabel *share =[[UILabel alloc]init];
    [share setText:@"分 享"];
    [share setTextAlignment:1];
    [share setTextColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0]];
    [share sizeToFit];
    share.frame = CGRectMake(_label.frame.size.width/2-share.frame.size.width/2, _label.frame.origin.y+_label.frame.size.height+20, share.frame.size.width, share.frame.size.height);
    
    CGFloat wid = (_backView.frame.size.width-share.frame.size.width-40)/2;
    
    UILabel *left =[[UILabel alloc]initWithFrame:CGRectMake(share.frame.origin.x-10-wid, share.frame.origin.y+share.frame.size.height/2, wid, 0.3)];
    left.backgroundColor=[UIColor blackColor];
    UILabel *right =[[UILabel alloc]initWithFrame:CGRectMake(share.frame.origin.x+share.frame.size.width+10, share.frame.origin.y+share.frame.size.height/2, wid, 0.3)];
    right.backgroundColor=[UIColor blackColor];
    
    [_backView addSubview:share];
    [_backView addSubview:left];
    [_backView addSubview:right];
    
    
    
    
    UIView *buttonView =[[UIView alloc]initWithFrame:CGRectMake(0, share.frame.origin.y+share.frame.size.height+20, _backView.frame.size.width, 40)];
    
    [self creatShareBtn];    //创建分享按钮
    
    [buttonView addSubview:_qqshare];
    [buttonView addSubview:_friendshare];
    [buttonView addSubview:_weiboshare];
    [buttonView addSubview:_moreshare];
    
    
    [_backView addSubview:buttonView];
    
    
    //更新背景框的高度
    _backView.frame=CGRectMake(_backView.frame.origin.x, _backView.frame.origin.y, _backView.frame.size.width, buttonView.frame.size.height+buttonView.frame.origin.y+20);
    
    [self.contentView addSubview:_backView];
    
    
    frame.size.height=self.backView.frame.size.height+self.backView.frame.origin.y+10;
    
    self.frame=frame;

}

-(void)creatShareBtn //创建分享按钮
{
    
    CGFloat spacewidth = (_backView.frame.size.width-40*4)/5;   //按钮间距
    
    _qqshare=[[UIButton alloc]initWithFrame:CGRectMake(spacewidth, 0, 40, 40)];
    _friendshare=[[UIButton alloc]initWithFrame:CGRectMake(spacewidth*2+40, 0, 40, 40)];
    _weiboshare=[[UIButton alloc]initWithFrame:CGRectMake(spacewidth*3+40*2, 0, 40, 40)];
    _moreshare=[[UIButton alloc]initWithFrame:CGRectMake(spacewidth*4+40*3, 0, 40, 40)];
    
    //设置图片
    [_qqshare setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [_friendshare setBackgroundImage:[UIImage imageNamed:@"friends"] forState:UIControlStateNormal];
    [_weiboshare setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    [_moreshare setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    
}

@end
