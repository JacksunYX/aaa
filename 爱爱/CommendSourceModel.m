//
//  CommendSourceModel.m
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/10.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.
//

#import "CommendSourceModel.h"
#import "NewsSourceModel.h"

@implementation CommendSourceModel
-(instancetype)init
{

    self = [super init];
    
    if (self) {
        
        _contentAbstruct = [NSDictionary new];
        _newsModel =[[NewsSourceModel alloc]init];
        _parentComment=[NSDictionary new];
    }
    
    return self;

}

-(NSString *)description
{
    return [NSString stringWithFormat:@"nickname:%@,commentId:%@,commentContent:%@,createTime:%@,userImg:%@,ups:%@,isUps:%d",self.nickname,self.commentId,self.commentContent,self.createTime,self.userImg,self.ups,self.isUps];
}
@end
