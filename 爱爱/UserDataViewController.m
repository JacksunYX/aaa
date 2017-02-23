//
//  UserDataViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/1.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "UserDataViewController.h"
#import "UserDataViewController+Methods.h"  //引入分类

#import "TableViewCell8.h"  //自定义cell
#import "TableViewCell9.h"  //自定义cell2

#import "ZHPickView.h"  //地域选择器库


#import "PhoneNumberBandingViewController.h"    //绑定手机号页面
#import "UpdataPasswordViewController.h"        //修改密码界面



@interface UserDataViewController ()<ZHPickViewDelegate>

@end

@implementation UserDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMainView];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    
    //关闭侧边栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    
    [self loadLocationUserData];    //加载本地用户数据
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [myPickView remove];
    
    myPickView=nil;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [myPickView remove];
    
    myPickView=nil;
    
}


#pragma mark ----- TableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        return section1Arr.count;
        
    }else if (section==1){
        
        return section2Arr.count;
        
    }
    
    return 1;
    
}

//cell填充
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        
        TableViewCell8 *cell =(TableViewCell8 *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell==nil) {
            
            cell = [[TableViewCell8 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        
        [cell settitleWithText:section1Arr[indexPath.row]];
        
        switch (indexPath.row) {    //昵称
            case 0:
            {
                [cell setintrodictionWithText:self.userModel.nickname];
            }
                break;
            case 1:                 //性别
            {
                
                NSString* str;
                if (self.userModel.gender) {    //不为空需要做一下转化
                    
                    switch ([self.userModel.gender integerValue]) {
                        case 0:
                            
                            str =@"女";
                            
                            break;
                        case 1:
                            
                            str =@"男";
                            
                            break;
                            
                    }
                    [cell setintrodictionWithText:str];
                    
                }else{          //为空就直接传
                    
                    [cell setintrodictionWithText:self.userModel.gender];
                    
                }
                
                
            }
                break;
            case 2:                 //年龄
            {
                [cell setintrodictionWithText:self.userModel.birthday];
            }
                break;
            case 3:                 //所在地
            {
                [cell setintrodictionWithText:self.userModel.location];
            }
                break;
                
        }
        
        return cell;
        
    }else if (indexPath.section==1){
        
        TableViewCell8 *cell =(TableViewCell8 *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell==nil) {
            
            cell = [[TableViewCell8 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        
        [cell settitleWithText:section2Arr[indexPath.row]];
        
        switch (indexPath.row) {
            case 0:                 //爱爱号
            {
                [cell setintrodictionWithText:@"aiai_12365"];
                cell.contentLabel.frame=CGRectMake(Width-20-cell.contentLabel.frame.size.width, cell.contentLabel.frame.origin.y, cell.contentLabel.frame.size.width, cell.contentLabel.frame.size.height);
                [cell.assistView setHidden:YES];
            }
                break;
            case 1:                 //修改登录密码
            {
                [cell setintrodictionWithText:@"修改"];
            }
                break;
            case 2:                 //绑定手机
            {
                if (self.userModel.phoneNum.length>0) {
                    
                    NSString *phoneNum = [self.userModel.phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"xxxx"];
                    
                    [cell setintrodictionWithText:phoneNum];
                    
                }else{
                    
                    [cell setintrodictionWithText:@"保密"];
                    
                }
                
            }
                break;
                
        }
        
        return cell;
        
    }else{
        
        TableViewCell9 *cell =(TableViewCell9 *)[tableView dequeueReusableCellWithIdentifier:@"cnacleCell"];
        
        if (cell==nil) {
            
            cell = [[TableViewCell9 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cnacleCell"];
            
            cell.cancelbtn.titleLabel.font = [UIFont fontWithName:PingFangSCX size:16];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.cancelbtn addTarget:self action:@selector(touchToCancel) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==2) {
        
        return 80;
        
    }else{
        
        return 66;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section==2) {
        
        return 0;
        
    }else{
        
        return 10;
        
    }
    
}


#pragma mark --- TableView delegate

//cell的点击反馈
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==0){
        
        
        
        switch (indexPath.row) {
                
            case 0:         //昵称
            {
                [myPickView remove];
                nicknameAlert=[[UIAlertView alloc]initWithTitle:@"修改昵称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                nicknameAlert.alertViewStyle =UIAlertViewStylePlainTextInput;
                [nicknameAlert show];
                
            }
                break;
            case 1:         //性别
            {
                
                [myPickView remove];
                userSex =[[UIActionSheet alloc]initWithTitle:@"更改性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",@"保密", nil];
                [userSex showInView:self.view];
            }
                break;
            case 2:         //出生年月
            {
                
                if (myPickView.tag==2) {    //如果是3说明已存在地域选择器,不需要重构
                    
                    return;
                    
                }
                
                [myPickView remove];  //先移除
                
                NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000];
                myPickView=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
                
                myPickView.delegate=self;
                
                myPickView.tag=2; //标记
                
                [myPickView show];
                
                if (![self.userModel.birthday isEqualToString:@"保密"]&&self.userModel.birthday) {
                    
//                   将字符串dateStr转化为nsdate
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    
                    NSDate *date=[dateFormatter dateFromString:self.userModel.birthday];
                    
//                    NSLog(@"date:%@",date);
                    
                    [myPickView.datePicker setDate:date animated:YES];
                    
                }
                
            }
                break;
            case 3:         //所在地
            {
                
                if (myPickView.tag==3) {    //如果是3说明已存在地域选择器,不需要重构
                    
                    return;
                
                }
                
                [myPickView remove];  //先移除
                
                myPickView=[[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
                
                myPickView.delegate=self;
                
                myPickView.tag=3; //标记
                
                NSInteger stateIndex = 0 ;  //省市的下标
                NSInteger cityIndex  = 0 ;  //对应的城市的下标
                
                if (![self.userModel.location isEqualToString:@"保密"]&&self.userModel.location) {
                    
                    //以'－'为分隔符对字符串进行切割
                    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
                    NSArray *strArr = [self.userModel.location componentsSeparatedByCharactersInSet:characterSet];
                    
                    NSString *province  = strArr[0];    //省(市)
                    NSString *city      = strArr[1];    //区
                    
                    //计算出当前省市的下标
                    for (NSArray *stateArr in myPickView.dicKeyArray) {
                        
                        NSString *stateStr = stateArr[0];
                        
                        if ([province isEqualToString:stateStr]) {
                            
                             stateIndex = [myPickView.dicKeyArray indexOfObject:stateArr];
                            
                        }
                        
                    }
                    
                    //计算出当前城市的下标
                    NSDictionary *dict = myPickView.plistArray[stateIndex]; //获取对应省市的字典
                    NSArray *valuesArr =[dict allValues][0];   //获取对应的所有值
                    for (NSString *cityStr in valuesArr) {  //遍历值
                        
                        if ([city isEqualToString:cityStr]) {   //得到对应的城市
                            
                            cityIndex = [valuesArr indexOfObject:cityStr];
                            
                        }
                        
                    }
                    
                    [myPickView setState:[@[province]mutableCopy][0]];
                    [myPickView setCity:[@[city]mutableCopy][0]];
                }
                
                [myPickView show];
                
                [myPickView.pickerView selectRow:stateIndex inComponent:0 animated:YES];
                [myPickView.pickerView selectRow:cityIndex inComponent:1 animated:YES];
                
                
                
            }
                break;
                
            default:
                break;
        }
        
        
        
    }else if (indexPath.section==1) {
        
        switch (indexPath.row) {
                
            case 0:     //爱爱号
            {
                
                
                
            }
                break;
                
            case 1:     //修改密码
            {
                
                self.hidesBottomBarWhenPushed=YES;
                
                UpdataPasswordViewController *uv =[[UpdataPasswordViewController alloc]init];
                [self.navigationController pushViewController:uv animated:YES];
                
            }
                break;
                
            case 2:     //绑定手机
            {
                
                if (self.userModel.phoneNum.length>0) {
                    
//                    phoneNumAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要解绑手机嘛?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                    [phoneNumAlert show];
                    
                }else{
                    
                    self.hidesBottomBarWhenPushed=YES;
                    
                    PhoneNumberBandingViewController *pv =[[PhoneNumberBandingViewController alloc]init];
                    [self.navigationController pushViewController:pv animated:YES];
                    
                }
                
                
                
            }
                break;
                
            default:
                break;
        }
        
    }
    
}



#pragma mark ZhpickVIewDelegate
//地域选择器的代理方法
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    self.navigationItem.rightBarButtonItem.enabled=YES; //开启上传功能
    
    if (pickView.tag==2) {
        
        NSString *birthday =[resultString substringToIndex:10];
        
        [self.userModel setValue:birthday forKey:@"birthday"];
        
        [self.myTableView reloadData];
        
    }else if (pickView.tag==3){
        
        
        
        [self.userModel setValue:resultString forKey:@"location"];
        
        [self.myTableView reloadData];
        
    }
    
    myPickView=nil;
    
}


@end
