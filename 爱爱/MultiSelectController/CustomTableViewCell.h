//
//  CustomTableViewCell.h
//  MultiSelectExample
//
//  Created by 薇薇一笑 on 16/4/12.
//  Copyright © 2016年 Darshan Patel. All rights reserved.
//
/*
 
 根据项目需求自定义的表视图cell 
 
 */






#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *model;

@property (nonatomic,strong) UIImageView *backView;  //配图


@end
