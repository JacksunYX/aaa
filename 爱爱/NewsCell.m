//
//  NewsCell.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/21.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define TopSpace  10     //最上面的控件离顶部的距离
#define BottomSpace  20  //最下面的控件离底部的距离
#define EdgeSpace 10    //左右边距

#define TitleFontSize  20       //标题字体大小
#define DescriptionFontSize 16  //摘要字体大小
#define ViewsFontSize  12       //观看及评论的字体大小

#import "NewsCell.h"

#import "UIImageView+ProgressView.h"
#import "UIImageView+Animation.h"

#import "DACircularProgressView.h"

///
//#import "ZCThrownLabel.h"
//#import "ZCShapeshiftLabel.h"
//#import "ZCDuangLabel.h"
//#import "ZCFallLabel.h"
//#import "ZCTransparencyLabel.h"
//#import "ZCFlyinLabel.h"
//#import "ZCFocusLabel.h"
//#import "ZCRevealLabel.h"
//#import "ZCSpinLabel.h"
//#import "ZCDashLabel.h"
//
//#import <objc/runtime.h>
///

@interface NewsCell ()

@property(nonatomic,strong)NSString    *imageUrl;    //图片地址

@end

@implementation NewsCell

{
    int finishcount;    //需要更新字体的控件个数
    
    UIImageView *imageBackView; //配图
 
    UIView      *downsideView;  //图片下方整体视图
    
    UILabel     *titleLabel;    //标题
    
    UILabel     *description;   //摘要
    
    UIImageView *viewsIcon;     //观看数量图标
    
    UIImageView *commentsIcon;  //评论数量图标
    
    UILabel     *viewsLabel;    //观看数量标签
    
    UILabel     *commentsLabel; //评论数量标签
    
    DACircularProgressView *progressView;   //用于展示图片加载情况的进度圈
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
        
        [self setUpView];
        
//        NSLog(@"cell被重新创建了");
        
    }
    
    return self;

}

//加载基本视图
-(void)setUpView
{

    imageBackView = [UIImageView new];
    
    downsideView = [UIView new];
    
    [self.contentView sd_addSubviews:@[imageBackView,downsideView]];
    
    progressView = [DACircularProgressView new];
    progressView.roundedCorners = YES;
    progressView.progressTintColor = MainThemeColor;
    progressView.trackTintColor = [UIColor whiteColor];
    
    [imageBackView sd_addSubviews:@[progressView]];

    //标题
    titleLabel = [UILabel new];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = TitleTextColorNormal;
    
    //摘要
    description = [UILabel new];
    description.numberOfLines = 0;
    description.textColor = ContentTextColorNormal;
    
    //观看数量和评论数量
    viewsIcon = [UIImageView new];
    [viewsIcon setImage:[UIImage imageNamed:@"eye_icon"]];
    [viewsIcon sizeToFit];
    
    viewsLabel = [UILabel new];
    viewsLabel.textColor = TitleTextColorNormal;
    
    commentsIcon = [UIImageView new];
    [commentsIcon setImage:[UIImage imageNamed:@"reply_icon"]];
    [commentsIcon sizeToFit];
    
    commentsLabel = [UILabel new];
    commentsLabel.textColor = TitleTextColorNormal;
    
    
    
    [downsideView sd_addSubviews:@[titleLabel,description,viewsIcon,viewsLabel,commentsIcon,commentsLabel]];
    
}

//加载图片
-(void) setImageUrl:(NSString *)imageUrl
{
    if (imageUrl) {
        _imageUrl = imageUrl;

        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
//        NSLog(@"imageUrl:%@  cachedImage:%@",imageUrl,cachedImage);
        // 没有缓存图片
        if (!cachedImage) {
            [progressView setHidden:NO];
            [progressView setProgress:0 animated:NO];
            progressView.frame = CGRectMake(imageBackView.frame.size.width/2-15, imageBackView.frame.size.height/2-15, 30, 30);
//            [imageBackView setImage:[UIImage imageNamed:@"placeholder.png"]];
            __weak typeof(self) weakSelf = self;
            NSString *imageUrlStr = [MainUrl stringByAppendingString:imageUrl];
//            NSLog(@"imageUrlStr:%@",imageUrlStr);
            // 利用 SDWebImage 框架提供的功能下载图片
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrlStr] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                float percentage = (float)receivedSize/expectedSize;
//                NSString *percentStr = [NSString stringWithFormat:@"%.2f",percentage];
//                NSLog(@"percentStr:%@",percentStr);
                [progressView setProgress:percentage animated:YES];
                if (progressView.progress==1) {
                    
                    [progressView setHidden:YES];
                    
                }
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                
//                NSLog(@"image:%@",image);
                
                // 保存图片
                if (image) {
                    
                    [[SDImageCache sharedImageCache] storeImage:image forKey:imageUrl toDisk:YES]; // 保存到磁盘
                    if (imageUrl == weakSelf.imageUrl) {
                        [weakSelf configPreviewImageViewWithImage:image];
                    }
                    //此时触发代理方法
                    if ([self.delegate respondsToSelector:@selector(reloadCellAtIndexPathWithUrl:)]) {
                        [self.delegate reloadCellAtIndexPathWithUrl:imageUrl];
                    }
                    
                }else{  //对于标题图不存在的新闻，回调代理方法直接移除
                
                    //触发代理方法
                    if ([self.delegate respondsToSelector:@selector(deleteCellAtIndexPathWithUrl:)]) {
                        [self.delegate deleteCellAtIndexPathWithUrl:imageUrl];
                    }
                
                }
                
            }];
        }else
        {
            [self configPreviewImageViewWithImage:cachedImage];
        }
        
    }
    
}


/**
 * 加载图片成功后设置image's frame
 */
- (void)configPreviewImageViewWithImage:(UIImage *)image
{
    CGFloat previewWidth = Width;   //宽度参照为屏幕宽度
    CGFloat previewHeight =  image.size.height * previewWidth/image.size.width;
    
    //重新设置图片视图的大小和方位
    [UIView animateWithDuration:0.5f animations:^{
        
        
       imageBackView.frame = CGRectMake(0, 0, previewWidth, previewHeight);
        

    }];
    
    [self loadNewImageAnimationWith:image];
    
//    [imageBackView animateImageWithURL:[NSURL URLWithString:[MainUrl stringByAppendingString:_imageUrl]]];
    
}

//图片视图里的过度动画
-(void)loadNewImageAnimationWith:(UIImage *)image
{
    
    imageBackView.image = image;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [imageBackView.layer addAnimation:transition forKey:nil];
    
}

//设置视图
-(void)setModel:(NSMutableDictionary *)model
{
    [progressView setHidden:YES];
    
    finishcount = 0;
    
    _model = model;
    
    imageBackView.image = nil;
    
    imageBackView.frame = CGRectMake(imageBackView.frame.origin.x, imageBackView.frame.origin.y, Width, Width*2/3);

    //设置背景图片
    [self setImageUrl:[model objectForKey:@"imageSrc"]];
    
    //加载下方整体视图
    downsideView.frame = CGRectMake(0, imageBackView.frame.size.height, Width, 0);
    
    [self setUpdownSideViewWithTopSpace:TopSpace];  //设置图片下方控件
    
//    [self useSDAutoLayeroutWithTopSpace:topSpace AndBottomSpace:bottomSpace];  //使用自动布局库进行布局
    
}

//手动布局下方视图控件
-(void)setUpdownSideViewWithTopSpace:(CGFloat)topSpace
{
    
    //设置标题(修改字体的前后字体大小一致才能保证不会出框)
    titleLabel.frame = CGRectMake(EdgeSpace, topSpace, Width-EdgeSpace*2, 0);
    //    titleLabel.font = [UIFont systemFontOfSize:TitleFontSize];
    titleLabel.font = [UIFont fontWithName:PingFangSCX size:TitleFontSize];
    [titleLabel setText:[_model objectForKey:@"title"]];
    [titleLabel sizeToFit]; //自适应宽高
//    [self setTextLabel:titleLabel AndPostScriptName:@"FZLTXHK--GBK1-0" AndFontSize:TitleFontSize];
    
    //摘要
    description.frame = CGRectMake(EdgeSpace, titleLabel.frame.origin.y+titleLabel.frame.size.height+10, Width-EdgeSpace*2, 0);
    //    description.font = [UIFont systemFontOfSize:DescriptionFontSize];
    description.font = [UIFont fontWithName:PingFangSCQ size:DescriptionFontSize];
    [description setText:[_model objectForKey:@"contentDescription"]];
    [description sizeToFit]; //自适应宽高
    //    [self setTextLabel:description AndPostScriptName:@"FZLTXHK--GBK1-0" AndFontSize:DescriptionFontSize];
    
    
    //浏览数量
    viewsLabel.frame = CGRectMake(0, 0,0, 0);
    //    viewsLabel.font = [UIFont systemFontOfSize:ViewsFontSize];
    viewsLabel.font = [UIFont fontWithName:PingFangSCJ size:ViewsFontSize];
    //    [self setTextLabel:viewsLabel AndPostScriptName:@"STFangsong" AndFontSize:ViewsFontSize];
    [viewsLabel setText:[NSString stringWithFormat:@"%@",[_model objectForKey:@"views"]]];
    [viewsLabel sizeToFit]; //自适应宽高
    
    
    
    //评论数量
    commentsLabel.frame = CGRectMake(0, 0,0, 0);
    //    commentsLabel.font = [UIFont systemFontOfSize:ViewsFontSize];
    commentsLabel.font = [UIFont fontWithName:PingFangSCJ size:ViewsFontSize];
    //    [self setTextLabel:commentsLabel AndPostScriptName:@"STFangsong" AndFontSize:ViewsFontSize];
    [commentsLabel setText:[NSString stringWithFormat:@"%@",[_model objectForKey:@"commentNum"]]];
    [commentsLabel sizeToFit]; //自适应宽高
    
    
    [self LayeroutWithBottomSpace:BottomSpace];
}

//重用布局
-(void)LayeroutWithBottomSpace:(CGFloat)bottomSpace
{
    //标题
    titleLabel.frame = CGRectMake(EdgeSpace, TopSpace, Width-EdgeSpace*2, titleLabel.frame.size.height);
    
    //摘要
    description.frame = CGRectMake(EdgeSpace, titleLabel.frame.origin.y+titleLabel.frame.size.height+10, description.frame.size.width, description.frame.size.height);
    
    //浏览图标
    viewsIcon.frame = CGRectMake(EdgeSpace, description.frame.origin.y + description.frame.size.height+10, viewsIcon.frame.size.width, viewsIcon.frame.size.height);
    
    //浏览数量
    viewsLabel.frame = CGRectMake(viewsIcon.frame.origin.x+viewsIcon.frame.size.width+5, viewsIcon.frame.origin.y+viewsIcon.frame.size.height/2-viewsLabel.frame.size.height/2, viewsLabel.frame.size.width , viewsLabel.frame.size.height);
    
    //评论图标
    commentsIcon.frame = CGRectMake(viewsLabel.frame.origin.x+viewsLabel.frame.size.width+20, viewsIcon.frame.origin.y+viewsIcon.frame.size.height/2-commentsIcon.frame.size.height/2, commentsIcon.frame.size.width, commentsIcon.frame.size.height);
    
    //评论数量
    commentsLabel.frame = CGRectMake(commentsIcon.frame.origin.x+commentsIcon.frame.size.width+5, commentsIcon.frame.origin.y+commentsIcon.frame.size.height/2-commentsLabel.frame.size.height/2, commentsLabel.frame.size.width , commentsLabel.frame.size.height);
    
    
    //修正下方整体布局
    [UIView animateWithDuration:0.3 animations:^{
        
        downsideView.frame = CGRectMake(0, imageBackView.frame.size.height, Width, viewsLabel.frame.origin.y + viewsLabel.frame.size.height + bottomSpace);
        
    }];
    
    [_model setValue:@(downsideView.frame.origin.y+downsideView.frame.size.height) forKey:@"otherControllHeight"];
    
}



#pragma mark ----- 暂未使用的方法
//给传过来的label添加新的字体(没有就下载，有就直接拿过来用)
-(void)setTextLabel:(UILabel *)label AndPostScriptName:(NSString *)postScriptName AndFontSize:(CGFloat)size
{

    [[FontManager sharedManager]downloadFontWithPostScriptName:postScriptName fontSize:size complete:^(UIFont *font) {
        
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, Width-EdgeSpace*2, 0);
        
        label.font = font;
        [label sizeToFit];
        
        finishcount ++;
        
        [self LayeroutWithBottomSpace:BottomSpace];
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"字体下载失败");
        
    }];

}



//使用自动布局库
-(void)useSDAutoLayeroutWithTopSpace:(CGFloat)topSpace AndBottomSpace:(CGFloat)bottomSpace
{
    [self sd_clearSubviewsAutoLayoutFrameCaches];
    
    downsideView.sd_layout
    .topSpaceToView(imageBackView,0)
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .autoHeightRatio(0)
    ;

    titleLabel.sd_layout
    .topSpaceToView(downsideView,topSpace)
    .leftSpaceToView(downsideView,EdgeSpace)
    .rightSpaceToView(downsideView,EdgeSpace)
    .autoHeightRatio(0)
    ;
    
    viewsIcon.sd_layout
    .widthIs(viewsIcon.frame.size.width)
    .heightIs(viewsIcon.frame.size.height)
    .topSpaceToView(titleLabel,5)
    .leftSpaceToView(downsideView,EdgeSpace)
    ;
    
    viewsLabel.sd_layout
    .leftSpaceToView(viewsIcon,5)
    .centerYEqualToView(viewsIcon)
    .autoHeightRatio(0)
    ;

    
    commentsIcon.sd_layout
    .widthIs(commentsIcon.frame.size.width)
    .heightIs(commentsIcon.frame.size.height)
    .leftSpaceToView(viewsLabel,20)
    .centerYEqualToView(viewsIcon)
    ;
    
    commentsLabel.sd_layout
    .leftSpaceToView(commentsIcon,5)
    .centerYEqualToView(commentsIcon)
    .autoHeightRatio(0)
    ;
    
    
    [downsideView setupAutoHeightWithBottomViewsArray:@[titleLabel,viewsIcon,viewsLabel,commentsIcon,commentsLabel] bottomMargin:bottomSpace];
    
    
    
    //赋值
    titleLabel.font = [UIFont systemFontOfSize:TitleFontSize];
    [self setTextLabel:titleLabel AndPostScriptName:@"FZLTXHK--GBK1-0" AndFontSize:TitleFontSize];
    [titleLabel setText:[_model objectForKey:@"title"]];
    
    viewsLabel.font = [UIFont systemFontOfSize:ViewsFontSize];
    [self setTextLabel:viewsLabel AndPostScriptName:@"STFangsong" AndFontSize:ViewsFontSize];
    [viewsLabel setText:[NSString stringWithFormat:@"%@",[_model objectForKey:@"views"]]];
    
    commentsLabel.font = [UIFont systemFontOfSize:ViewsFontSize];
    [self setTextLabel:commentsLabel AndPostScriptName:@"STFangsong" AndFontSize:ViewsFontSize];
    [commentsLabel setText:[NSString stringWithFormat:@"%@",[_model objectForKey:@"commentNum"]]];
    
//    [self.contentView updateLayout];
    
}









@end
