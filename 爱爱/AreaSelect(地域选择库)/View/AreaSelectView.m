//
//  AreaSelectView.m
//  AreaSelect
//
//  Created by xhw on 16/3/16.
//  Copyright © 2016年 xhw. All rights reserved.
//

#import "AreaSelectView.h"
#import "AreaModel.h"

#import "HotelReservationVC.h"  //酒店首页


//模拟定位城市
#define DEFAULT_CITY @"北京市"

//记录的城市最大数量
#define RECORD_MAX_COUNT 5

//存入userDefault的key
#define RECORD_CITY @"record_city"

@interface AreaSelectView()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) UISearchBar *searchBar;//搜索框
@property(nonatomic, assign) BOOL isSearch;//是否是search状态
@property(nonatomic, strong) NSMutableArray * searchArray;//中间数组,搜索结果

@property(nonatomic, strong) UIView *navigationView;    //虚拟导航栏

@end

@implementation AreaSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        self.backgroundColor=[UIColor whiteColor];
        [self initializeData];
        
        [self addSubview:self.navigationView];
        
        [self addSubview:self.searchBar];
        
        [self addSubview:self.tableView];
        
    }
    return self;
}

#pragma mark - 初始化数据

- (void)initializeData
{
    self.isSearch = NO;
    
    self.searchArray = [NSMutableArray array];
    
    self.cities = [NSMutableDictionary dictionaryWithDictionary:[DBUtil getAllCity]];
    
    self.keys = [NSMutableArray arrayWithArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //历史记录
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *recordStrings = [userDefault objectForKey:RECORD_CITY];
    NSMutableArray *recordCity = [NSMutableArray array];
    for(NSString *cityName in recordStrings)
    {
        AreaModel *model = [DBUtil getCityWithName:cityName];
        if(model)
        {
            [recordCity addObject:model];
        }
    }
    [self.cities setObject:recordCity forKey:@"历"];
    [self.keys insertObject:@"历" atIndex:0];
    
    //定位城市
//    AreaModel *model = [DBUtil getCityWithName:DEFAULT_CITY];
//    if(model)
//    {
//        [self.cities setObject:[NSArray arrayWithObject:model] forKey:@"定"];
//    }
//    [self.keys insertObject:@"定" atIndex:0];
}

#pragma mark - 懒加载

-(UIView *)navigationView   
{

    if (!_navigationView) {
        
        _navigationView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 64)];
        _navigationView.backgroundColor=[UIColor whiteColor];
        
        //添加一个标题
        UILabel *title =[[UILabel alloc]init];
        title.font=[UIFont boldSystemFontOfSize:16];
        [title setTextAlignment:1];
        [title setText:@"城市选择"];
        [title setTextColor:[UIColor blackColor]];
        [title sizeToFit];
        title.frame=CGRectMake(_navigationView.frame.size.width/2-title.frame.size.width/2, (_navigationView.frame.size.height-20)/2-title.frame.size.height/2+20, title.frame.size.width, title.frame.size.height);
        [_navigationView addSubview:title];
        
        //添加一个左按键
        UIButton *backBtn =[[UIButton alloc]init];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [backBtn sizeToFit];
        backBtn.frame=CGRectMake(20, (_navigationView.frame.size.height-20)/2-backBtn.frame.size.height/2+20, backBtn.frame.size.width,backBtn.frame.size.height );
        [backBtn addTarget:self action:@selector(touchTodismiss) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView addSubview:backBtn];
        
    }
    
    return _navigationView;

}

-(void)touchTodismiss   //点击左上角按钮返回
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame =CGRectMake(self.bounds.origin.x, [UIScreen mainScreen].bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview]; //移除
        
        AppDelegate *delegate =[UIApplication sharedApplication].delegate;
        UITabBarController *tabbarVC =[delegate tabbarController];
        JTNavigationController *jv =tabbarVC.selectedViewController;
        HotelReservationVC *hVC =jv.jt_viewControllers[0];
        
        [hVC.navigationController setNavigationBarHidden:NO animated:YES];
        [hVC.tabBarController.tabBar setHidden:NO];
        
    }];

}

- (UISearchBar *)searchBar  //搜索栏
{
    if(!_searchBar)
    {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, _navigationView.frame.origin.y+_navigationView.frame.size.height, CGRectGetWidth(self.bounds), 44)];
        _searchBar.barStyle     = UIBarStyleDefault;
        _searchBar.translucent  = YES;
        _searchBar.delegate     = self;
        _searchBar.placeholder  = @"城市/拼音";
        _searchBar.keyboardType = UIKeyboardTypeDefault;
    }
    
    return _searchBar;
}

- (UITableView *)tableView  //表视图
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.frame.origin.y+_searchBar.frame.size.height, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - ( _searchBar.frame.origin.y+_searchBar.frame.size.height)) style:UITableViewStylePlain];
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isSearch) {
        return 0.0;
    }
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isSearch) {
        return nil;
    }
    
    //简单写下，未复用
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30.0)];
    bgView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, [UIScreen mainScreen].bounds.size.width - 13, 30.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:@"定"].location != NSNotFound) {
        titleLabel.text = @"定位城市";
    }
    else if ([key rangeOfString:@"历"].location != NSNotFound) {
        titleLabel.text = @"历史记录";
    }
    else
        titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AreaModel *model = nil;
    if (self.isSearch) {
        model = [self.searchArray objectAtIndex:indexPath.row];
    }
    else
    {
        NSString *key = [_keys objectAtIndex:indexPath.section];
        model = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    }
    
    //更新历史记录
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *cityStrings = [NSMutableArray arrayWithArray:[userDefault objectForKey:RECORD_CITY]];
    if([cityStrings containsObject:model.areaName])
    {
        [cityStrings removeObject:model.areaName];
        [cityStrings insertObject:model.areaName atIndex:0];
    }
    else
    {
        [cityStrings insertObject:model.areaName atIndex:0];
        if(cityStrings.count > RECORD_MAX_COUNT)
        {
            [cityStrings removeLastObject];
        }
    }
    [userDefault setObject:cityStrings forKey:RECORD_CITY];
    [userDefault synchronize];
    
    if(self.selectedCityBlock)
    {
        self.selectedCityBlock(model);
    }
    
//    [self.viewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.isSearch) {
        return [NSArray array];
    }

    return self.keys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isSearch) {
        return 1;
    }
    
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch) {
        return self.searchArray.count;
    }

    NSString *key = [_keys objectAtIndex:section];
    NSArray *citySection = [_cities objectForKey:key];
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
    AreaModel *model = nil;
    if (self.isSearch) {
        model = [self.searchArray objectAtIndex:indexPath.row];
    }
    else
    {
        NSString *key = [_keys objectAtIndex:indexPath.section];
        model = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = model.areaName;
    
    return cell;
}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchArray removeAllObjects];
    
    if (searchText.length == 0) {
        self.isSearch = NO;
        self.tableView.tableFooterView = nil;
    }else{
        self.isSearch = YES;
        self.tableView.tableFooterView = [UIView new];
        [self.searchArray addObjectsFromArray:[DBUtil getCitysWithKey:searchText]];
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
