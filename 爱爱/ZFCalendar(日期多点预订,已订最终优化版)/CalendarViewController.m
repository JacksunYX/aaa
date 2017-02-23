//
//  CalendarViewController.m
//  Calendar
//
//  Created by 张凡 on 14-8-21.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarViewController.h"
//UI
#import "CalendarMonthCollectionViewLayout.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarDayCell.h"
//MODEL
#import "CalendarDayModel.h"

#define wid [UIScreen mainScreen].bounds.size.width


@interface CalendarViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate>
{

    NSTimer* timer;//定时器
    
    NSMutableArray *modelArr;   //用来保存多次选择的时间模型

}
@end

@implementation CalendarViewController

static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"DayCell";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        modelArr = [NSMutableArray new];    //初始化
        
        
        [self initData];
        [self initView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self addrightItem];
    
    [self creatFinishBtn];
    
}

-(void)addrightItem //给导航栏添加右按钮
{

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(touchToFinishSelect:)];

}

-(void)creatFinishBtn   //创建按钮
{
    
    self.navigationController.navigationBar.hidden=YES;
    UIButton *finishBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    finishBtn.frame=CGRectMake(wid-finishBtn.frame.size.width-15, self.collectionView.frame.origin.y-finishBtn.frame.size.height, finishBtn.frame.size.width, finishBtn.frame.size.height);
    finishBtn.layer.cornerRadius=finishBtn.frame.size.width/2;
    finishBtn.backgroundColor=[UIColor colorWithRed:230.0f/255.0f green:23/255.0f blue:115/255.0f alpha:1];
    [self.view addSubview:finishBtn];
    finishBtn.tag=1;
    [finishBtn addTarget:self action:@selector(touchToFinishSelect:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)touchToFinishSelect:(UIButton *)btn  //返回选择好的时间点
{
    
    // 利用block进行排序
    [modelArr sortUsingComparator:^NSComparisonResult(CalendarDayModel *obj1, CalendarDayModel *obj2) {
        
        /// 按照时间大小排序
        NSComparisonResult result = [obj1.toString compare:obj2.toString];
        
        return result;
        
    }];
    
    self.calendarArrblock(modelArr);
    
    if (btn.tag==1) {    //代表是从下方弹出的方式展示的界面
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
    
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initView{
    
    
    [self setTitle:@"选择日期"];
    
    CalendarMonthCollectionViewLayout *layout = [CalendarMonthCollectionViewLayout new];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, wid, [UIScreen mainScreen].bounds.size.height-64) collectionViewLayout:layout]; //初始化网格视图大小
    
    [self.collectionView registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    
    [self.collectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    
//    self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
    
    self.collectionView.delegate = self;//实现网格视图的delegate
    
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
}



-(void)initData{
    
    self.calendarMonth = [[NSMutableArray alloc]init];//每个月份的数组
    
}

-(void)setCannotSelectDates:(NSArray *)dateModelArr    //设置无法点击的日期
{
    
    for (CalendarDayModel *model in dateModelArr) {
        
        for (int i=0; i<self.calendarMonth.count; i++) {
            
            NSMutableArray *monthArray = self.calendarMonth[i]; //获取对应的月份数组
            
            //遍历此数组,看是否有需要置为无法点击状态的日期
            for (CalendarDayModel *dateModel in monthArray) {
                
                //此处判断
                if ([model.dateString isEqualToString:[dateModel toString]]) {
                    
                    dateModel.style=CellSelectedNotClick;    //显示为已订,且无法被点击
                    
                }
                
            }
            
        }
        
    }
    
    [self.collectionView reloadData];
    
}



#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.calendarMonth.count;
}


//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:section];
    
    return monthArray.count;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
    
    CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        CalendarDayModel *model = [month_Array objectAtIndex:15];

        CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%lu年 %lu月",(unsigned long)model.year,(unsigned long)model.month];//@"日期";
        monthHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        reusableview = monthHeader;
    }
    return reusableview;
    
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];

    if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek ||model.style == CellDayTypeClick||model.style == CellDayTypeNotClick) {
        
        if ([modelArr indexOfObject:model] != NSNotFound) { //说明已经点击过了
            
            [modelArr removeObject:model];
            
            model.style=CellDayTypeNotClick;
            
        }else{  //反之则没有点击过,添加进数组
            
            model.style=CellDayTypeClick;
        
            [modelArr addObject:model];
        
        }
        
        //重新遍历后选定
        for (int i=0; i<modelArr.count; i++) {
            
            CalendarLogic *Log =[[CalendarLogic alloc]init];
            
            [Log selectLogic:modelArr[i]];
            
        }
        
        
        [self.collectionView reloadData];
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}




//定时器方法
- (void)onTimer{
    
    [timer invalidate];//定时器无效
    
    timer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
