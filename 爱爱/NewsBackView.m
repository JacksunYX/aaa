//
//  NewsBackView.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/18.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "NewsBackView.h"
#import "TFHpple.h"
//#import "UIImageView+WebCache.h"
#import "UIImageView+ProgressView.h"
#import "NewsSourceModel.h"

#import "WyzAlbumViewController.h"  //多图展示库

@implementation NewsBackView

static int imgIndex;    //用于图片下标的标识

-(instancetype)initWithFrame:(CGRect)frame   //初始化控件
{
    
    self = [super initWithFrame:frame];
    
    _backView =[[UIView alloc]initWithFrame:CGRectMake(10, 10, Width-10*2, 0)];
    
    _imgArr=[NSMutableArray new];    //初始化
    _imageViewArr=[NSMutableArray new];
    
    //标题
    _title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, Width-20*2, 0)];
    _title.numberOfLines=0;         //自动换行
    [_title setTextAlignment:0];    //置左
    
    _title.dk_textColorPicker = DKColorWithColors(RGBA(50, 50, 50, 1), TitleTextColorNight);
    [_backView addSubview:_title];
    
    
    //新闻来源
    _source =[[UILabel alloc]init];
    _source.textAlignment = 0;
    _source.font =[UIFont systemFontOfSize:12];
    _source.dk_textColorPicker = DKColorWithColors(RGBA(144, 144, 144, 1), UnimportantContentTextColorNight);
    [_backView addSubview:_source];
    
    
    //发布时间
    _issueTime =[[UILabel alloc]init];
    _issueTime.font =[UIFont systemFontOfSize:12];
    _issueTime.textAlignment = 0;
    _issueTime.dk_textColorPicker = DKColorWithColors(RGBA(144, 144, 144, 1), UnimportantContentTextColorNight);
    [_backView addSubview:_issueTime];
    
    
    _line =[[UILabel alloc]init];
    _line.backgroundColor=[UIColor blackColor];
    [_backView addSubview:_line];
    
    //配图
    _backImage = [[UIImageView alloc] init];
    [_backView addSubview:_backImage];
    
    //    标题字体适配
    if (Width==414&&Height==736) {
        _title.font =[UIFont systemFontOfSize:20];
        
    }else if(Width==375&&Height==667){
        _title.font =[UIFont systemFontOfSize:18];
        
    }else{
        _title.font =[UIFont systemFontOfSize:16];
        
    }
    
//    _backView.layer.shadowOpacity=0.3;
//    _backView.layer.shadowOffset=CGSizeMake(0, 1);
//    _backView.layer.shadowColor=[UIColor blackColor].CGColor;
    
    _backView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
//    _backView.layer.cornerRadius=5;
    
//    self.layer.shouldRasterize = YES;
//    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return self;
}

-(void)setLabelOfCellWithNewsModel:(NewsSourceModel *)newsModel  //处理新闻内容
{
    
    imgIndex=0;
    
    self.title.text= newsModel.title;
    [self.title sizeToFit];
    self.source.text=newsModel.source;
    [self.source sizeToFit];
    self.source.frame=CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y+self.title.frame.size.height+20, self.source.frame.size.width, self.source.frame.size.height);
    self.issueTime.text=newsModel.publishTime;
    [self.issueTime sizeToFit];
    self.issueTime.frame=CGRectMake(self.source.frame.origin.x+self.source.frame.size.width+10, self.source.frame.origin.y, self.issueTime.frame.size.width, self.issueTime.frame.size.height);
    
    _line.frame=CGRectMake(0, _issueTime.frame.origin.y+_issueTime.frame.size.height+10, _backView.frame.size.width, 0.3);
    _backImage.frame=CGRectMake(0, _line.frame.size.height+_line.frame.origin.y+10, _backView.frame.size.width, 0);
    
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
//        
//        [_backImage setImage:newsModel.titleImg];
//        
//    }else{
//    
//        if (newsModel.imageSrc) {
//            
//            NSMutableString *ImageUrl=[MainUrl mutableCopy];
//            [ImageUrl appendString:newsModel.imageSrc];
//            
////            [_imgArr addObject:ImageUrl];    //将地址添加进全局数组
//            
////            imgIndex=0;
//            
////            self.backImage.tag=imgIndex;    //标记
//            
//            [_imageViewArr addObject:self.backImage];
//            
//            [self.backImage sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
//            
//            [self.backImage setUserInteractionEnabled:YES];
//            
//        }else{
//            
//            
//            
//        }
//    
//    }
    //隐藏标题图
//    self.backImage.frame=CGRectMake(_backImage.frame.origin.x, _backImage.frame.origin.y, _backImage.frame.size.width, 0);
    
    
//    _label = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(0, _backImage.frame.origin.y+_backImage.frame.size.height+50, _backView.frame.size.width, 0)];
//    _label.delegate = self;
    
    //背景视图(取代第三方库,直接在上面添加控件)
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, _backImage.frame.origin.y+_backImage.frame.size.height, _backView.frame.size.width, 0)];
    
    CGRect frame = CGRectMake(0, 0, backView.frame.size.width, 0);
    
    NSData *htmlData = [newsModel.content dataUsingEncoding:NSUTF8StringEncoding];
    
    //处理数据
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//p"]; //分解节点
    
    for (TFHppleElement *element in elements) { //遍历数组
        
        if ([(NSString *)[element.node objectForKey:@"nodeContent"] length]>0) { //纯文本用textview接收
            
            NSString *contentText = [element.node objectForKey:@"nodeContent"];
            
//            NSLog(@"contentText:%@",contentText);
            
            //背景
            UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, backView.frame.size.height+10, backView.frame.size.width, 0)];
            
            CGRect viewFrame =view.frame;   //方位和大小记录下来
            
            UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, _backView.frame.size.width-20, 0)];
            label.font=[UIFont systemFontOfSize:16];
            label.numberOfLines=0;
            label.dk_textColorPicker=DKColorWithColors([UIColor blackColor], ContentTextColorNight);
            [label setText:[NSString stringWithFormat:@"%@",contentText]];
            
            
            // 调整行间距
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            //行距
            [paragraphStyle setLineSpacing:5];
            [paragraphStyle setFirstLineHeadIndent :label.font.pointSize*2 ];    //首行缩进
            //需要添加行距的范围(添加范围为整个文本长度)
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
            
            
            [label setAttributedText:attributedString];
            [label sizeToFit];
            
            viewFrame.size.height=label.frame.size.height+10;
            
            [view addSubview:label];
            
            view.frame=viewFrame;//更新背景高度
            
            [backView addSubview:view];

            backView.frame=CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width, backView.frame.size.height+view.frame.size.height+10);
            
//            [self.label appendView:view];
//            [self.label appendText:@"\n"];//换行
            
        }else{
            
            TFHppleElement *sss =(TFHppleElement *) [[element searchWithXPathQuery:@"//img"] firstObject];
            NSMutableString *img =[MainUrl mutableCopy];
            
            if ([sss objectForKey:@"src"]) {
                
                [img appendString:[sss objectForKey:@"src"]];
                
//                NSLog(@"图片地址:%@",img);
                
                UIImageView *imgView  =[[UIImageView alloc]initWithFrame:CGRectMake(0, backView.frame.size.height+10, backView.frame.size.width, backView.frame.size.width*2/3)];
                
                imgView.tag=imgIndex;
                
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"])
                {
                    
                    [imgView setImage:[newsModel.pictures[imgView.tag] objectForKey:@"image"]];
                    
                    [_imgArr addObject:[newsModel.pictures[imgView.tag] objectForKey:@"image"]];    //将地址添加进全局数组
                    
                }else{
                    
                    [_imgArr addObject:img];    //将地址添加进全局数组
                    
                    [imgView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(40, 40)];
                
                }
                
                [_imageViewArr addObject:imgView];
                
                
                imgView.userInteractionEnabled=YES;
                
                [backView addSubview:imgView];
                
                backView.frame=CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width, backView.frame.size.height+imgView.frame.size.height+30);
                
                imgIndex++;
                
//                [self.label appendView:imgView];
//                
//                [self.label appendText:@"\n"];//仍然换行
              
            }
        }
        
    }
    
    [_backView addSubview:backView];
    
//    self.label.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], [UIColor colorWithRed:40.0f/255.0f green:85.0f/255.0f blue:109.0f/255.0f alpha:1.0]);
//    
//    self.label.dk_tintColorPicker =DKColorWithColors([UIColor blackColor], [UIColor colorWithRed:218.0f/255.0f green:218.0f/255.0f blue:218.0f/255.0f alpha:1.0f]);
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
        
        _backView.frame=CGRectMake(_backView.frame.origin.x, _backView.frame.origin.y, _backView.frame.size.width, backView.frame.origin.y+backView.frame.size.height);
        
    }else{  //有网状态加载分享按钮
    
        //下方分享
        UILabel *share =[[UILabel alloc]init];
        [share setText:@"分 享"];
        [share setTextAlignment:1];
        share.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), UnimportantContentTextColorNight);
        [share sizeToFit];
        share.frame = CGRectMake(backView.frame.size.width/2-share.frame.size.width/2, backView.frame.origin.y+backView.frame.size.height+20, share.frame.size.width, share.frame.size.height);
        
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
        
        
    
    }
    
    [self addSubview:_backView];
    
    
    frame.size.height=_backView.frame.size.height+_backView.frame.origin.y+10;
    
    self.frame=frame;
    
//    NSLog(@"W:%f,H:%f",self.frame.size.width,self.frame.size.height);
    
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
