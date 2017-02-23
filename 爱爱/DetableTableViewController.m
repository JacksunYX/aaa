//
//  DetableTableViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/11.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "DetableTableViewController+Methods.h"//引入分类
#import "DetableTableViewController.h"
#import "UIImageView+WebCache.h"//图片处理库

@interface DetableTableViewController ()<UIWebViewDelegate>

@end

@implementation DetableTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title=@"爱爱资讯";
    
    [self loadmyTableView];
    
    [self loadLogImage];//加载log
    
    [self loadHud];//加载指示器
    
    [self addBtn];//悬浮按钮
    
    [self addNavigationRightBtn];//导航栏右边按钮
    
    [self loadWebViewWithUrl:[NSURL URLWithString:self.myUrl]];//加载webView
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updataTheView];//修改显示
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView ------- datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return 1;
    }else{
        return tableData.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0){//新闻区
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell.contentView addSubview:_webView];
            /* 忽略点击效果 */
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    }else{
        CommentTableViewCell *cell =(CommentTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"commentcell"];
        
        if (cell == nil) {
            
            cell = [[CommentTableViewCell alloc]initWithReuseIdentifier:@"commentcell"];
            
        }
        
        
        
        CommendSourceModel *user = tableData[indexPath.row];
        
        //异步加载用户头像
        NSMutableString *ImageUrl=[MainUrl mutableCopy];
        [ImageUrl appendString:user.userImg];
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:nil];
        
        //点击用户头像查看信息
//        [cell.userbtn addTarget:self action:@selector(touchToSearch) forControlEvents:UIControlEventTouchUpInside];
        
        //评论内容创建内容并赋值
        [cell setContentWithCommentModle:user];
        
        [cell.zanBtn addTarget:self action:@selector(changeSelectState:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
        
        
        return cell;
    }
}

//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        /* 通过webview代理获取到内容高度后,将内容高度设置为cell的高 */
        return _webView.frame.size.height+20;
    }else{
        return 100;
    }
}

#pragma mark - tableView ----- delegate
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UIWebView Delegate Methods  -------- webView代理方法
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取到webview的高度
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, self.view.frame.size.width, height);//更新高度
    [self.mytableView reloadData];
    //当高度开始更新时,隐藏等待和log
    [_hud hide:YES];
    [_logImage setHidden:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"didFailLoadWithError===%@", error);
}

#pragma mark  ---YIPopupTextViewDelegate代理方法
- (void)popupTextView:(YIPopupTextView*)textView didDismissWithText:(NSString*)text cancelled:(BOOL)cancelled
{
    if (cancelled) {
        NSLog(@"取消");
        
    }else{
        
        //将输入框里的内容传入到方法里
        [self issueCommentWithString:text];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)showString:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    //    hud.margin = 10.f;
    //    hud.cornerRadius=20;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}
@end
