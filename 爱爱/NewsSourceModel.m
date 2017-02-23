//
//  NewsSourceModel.m
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/10.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.
//



#import "NewsSourceModel.h"

@implementation NewsSourceModel
-(NSString *)description
{
    return [NSString stringWithFormat:@"titleImg:%@,title:%@,content:%@,imageSrc:%@,source:%@,publishTime:%@,views:%@,newsId:%@,commentNum:%@,ups:%@,isStore:%d,contentType:%@,contentPictures:%@,browsTime:%@,pictures:%@",self.titleImg,self.title,self.content,self.imageSrc,self.source,self.publishTime,self.views,self.newsId,self.commentNum,self.ups,self.isStore,self.contentType,self.contentPictures,self.browsTime,self.pictures];
}
-(instancetype)init
{
    self =[super init];
    if (self) {
        self.pictures=[NSMutableArray new];
        self.contentPictures =[NSMutableArray new];
    }
    return self;
}

@end
