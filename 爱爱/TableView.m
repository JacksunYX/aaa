//
//  TableView.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/26.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "TableView.h"

#import "IQKeyboardManager.h"

@implementation TableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        
    }
    
    return self;
}


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{

    [[IQKeyboardManager sharedManager] resignFirstResponder];
    return [super hitTest:point withEvent:event];
    
}

@end
