//
//  TableViewCell9.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/1.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "TableViewCell9.h"

@implementation TableViewCell9

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.cancelbtn =[[UIButton alloc]initWithFrame:CGRectMake(20, 20, Width-20*2, 40)];
        
        [self.cancelbtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        
        [self.cancelbtn setBackgroundColor:RGBA(255, 151, 203, 1)];
        
        [self.cancelbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.cancelbtn.layer.cornerRadius = self.cancelbtn.frame.size.height/2;
        
        [self.contentView addSubview:self.cancelbtn];
        
        self.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    }
    
    return self;

}

@end
