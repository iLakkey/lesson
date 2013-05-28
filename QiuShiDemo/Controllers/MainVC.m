//
//  MainVC.m
//  QiuShiDemo
//
//  Created by lakkey on 13-5-22.
//
//

#import "MainVC.h"
#import "PullingRefreshTableView.h"
#import "AppDelegate.h"
#import "QiuShi.h"
#import "ContentCell.h"


#define PAGECOUNT 20    // 一次加载的最大数据量

@interface MainVC () <PullingRefreshTableViewDelegate>

@property (nonatomic, assign) PullingRefreshTableView* refreshView;
@property (nonatomic, assign) NSInteger         nPage;
@property (nonatomic, strong) NSMutableArray*   arrDataSource;
@property (nonatomic, assign) BOOL              bIsRefreshing; // 是否在refresh状态？

@property (nonatomic, strong) ASIHTTPRequest*   asiRequest;

@end

@implementation MainVC

- (void)dealloc {
    self.arrDataSource = nil;
    self.asiRequest = nil;
    
    [super dealloc];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    self.arrDataSource = [[[NSMutableArray alloc] initWithCapacity:40] autorelease];
    
    // 将视图控制器的默认主视图替换为PullingRefreshTableView
    self.refreshView = [[[PullingRefreshTableView alloc] initWithFrame:self.view.frame pullingDelegate:self] autorelease];
    [_refreshView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView = _refreshView;
    _refreshView.delegate = self;
    _refreshView.dataSource = self;
    // 设置背景色
    UIImage* img = [UIImage imageNamed:@"main_background.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:img]];
    
    // 第一次进入刷新数据
    if (self.nPage == 0) {
        [_refreshView launchRefreshing];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    QiuShi* qs = [_arrDataSource objectAtIndex:indexPath.row];
//    NSLog(@"qs in cell = %@", [qs description]);
    if ((qs.strAuthor != nil) && (![qs.strAuthor isEqualToString:@""])) {
        cell.lblAuthor.text = qs.strAuthor;
    }
    
    cell.lblContent.text = qs.strContent;
    
    [cell resizeCellHeight];
    return cell;
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCellHeightWithIndexPath:indexPath];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


#pragma mark - UIScrollViewDelegate
// 下面两个方法必须重写以实现刷新加载动画

// 当scrollView开始滚动时调用该方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshView tableViewDidScroll:scrollView];
}


// 当scrollView开始回弹时调用该方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    /* 下面的方法调用最终会调用pullingTableViewDidStartRefreshing刷新或pullingTableViewDidStartLoading加载 */
    [_refreshView tableViewDidEndDragging:scrollView];
}

#pragma mark - PullingRefreshTableView Delegate
// 下拉时回调的方法
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView {
    _bIsRefreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
}


// 上拉时的回调方法
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView {
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
}


#pragma mark - Private Method

- (QiuShiType)currentQiuShiType {
    return ((AppDelegate* )[UIApplication sharedApplication].delegate).qsType;
}


- (void)loadData {
    self.nPage++;
    if (_nPage > 20) {
        [_refreshView tableViewDidFinishedLoadingWithMessage:@"下面木有了.."];
        _refreshView.reachedTheEnd = YES;
        return;
    }
    _refreshView.reachedTheEnd = NO;
    
    NSURL* url = nil;

    switch ([self currentQiuShiType]) {
        case QiuShiTypeTop: // 干货
            break;
            
        case QiuShiTypeNew: // 嫩草
            url = [NSURL URLWithString:LastestURLString(10, _nPage)];
            break;
            
        case QiuShiTypePhoto: // 有图有真相
            url = [NSURL URLWithString:ImageURLString(10, _nPage)];
            break;
            
        case QiuShiTimeDay: // 精华－每天
            url = [NSURL URLWithString:DayURLString(10, _nPage)];
            break;
            
        case QiuShiTimeWeek: // 精华－每周
            url = [NSURL URLWithString:WeakURlString(10, _nPage)];
            break;
            
        case QiuShiTimeMonth: // 精华－每月
            url = [NSURL URLWithString:MonthURLString(10, _nPage)];
            break;
            
        case QiuShiTimeRandom: // 穿越
            url = [NSURL URLWithString:SuggestURLString(10, _nPage)];
            break;
            
        default:
            break;
    }
    
    // 发起网络请求
    if (url == nil) {
        return;
    }
    
    self.asiRequest = [ASIHTTPRequest requestWithURL:url];
    // 网络请求成功的回调
    [_asiRequest setCompletionBlock:^{
        if (_bIsRefreshing) {
            _nPage = 1; // 重置page为1
            [_arrDataSource removeAllObjects]; // 清空所有数组元素
            _bIsRefreshing = NO;
        }
        
        NSError* error = nil;
        NSData* data = [_asiRequest responseData];
        NSDictionary* dicData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error) {
            NSLog(@"JSON parser error: %@", [error localizedDescription]);
            return;
        }
        
        NSArray* arrList = nil;
        if ((arrList = [dicData objectForKey:@"items"])) {
            for (NSDictionary* dicQiuShi in arrList) {
                QiuShi* qs = [[[QiuShi alloc] initWithDictionary:dicQiuShi] autorelease];
                [_arrDataSource addObject:qs];
//                NSLog(@"qs = %@", [qs description]);
            }
        }
        
        //
        [_refreshView tableViewDidFinishedLoading];
        [_refreshView reloadData];
    }];
    
    // 由于网络问题，失败后的回调
    [_asiRequest setFailedBlock:^{
        _bIsRefreshing = NO;
        [_refreshView tableViewDidFinishedLoading];
        [Ultilities showMessage:@"连接网络失败，请检查网络是否可用"];
    }];
    
    // 开始异步请求
    [_asiRequest startAsynchronous];
}


- (void)refreshData {
    _nPage = MIN([_arrDataSource count], PAGECOUNT);
    if (_nPage == [_arrDataSource count]) {
        _refreshView.reachedTheEnd = YES;
        [_refreshView tableViewDidFinishedLoading];
        return;
    }
    
    _refreshView.reachedTheEnd = NO;
    [_refreshView reloadData]; // 重新显示数据
    [_refreshView tableViewDidFinishedLoading];
}


- (void)loadMoveData {
    NSInteger nAllDataCount = [_arrDataSource count];
    // 检查nPage是否小于arrDataSource中的元素个数
    // *是，加载
    if (_nPage < nAllDataCount) {
        if ((_nPage += PAGECOUNT) > nAllDataCount) {
            _nPage = nAllDataCount;
            [_refreshView tableViewDidFinishedLoadingWithMessage:@"下面米有了"];
            _refreshView.reachedTheEnd = YES; // 设置数据到头标示
            [_refreshView reloadData]; // 重新显示数据
            return;
        }
        else {
            [_refreshView tableViewDidFinishedLoading];
            _refreshView.reachedTheEnd = NO;
            [_refreshView reloadData]; // 重新显示数据
        }
    }
    else {
        [_refreshView tableViewDidFinishedLoadingWithMessage:@"下面米有了"];
        _refreshView.reachedTheEnd = YES; // 设置数据到头标示
    }
}


//
- (CGFloat)getCellHeightWithIndexPath:(NSIndexPath* )ip {
    CGFloat contentWidth = 280;
    UIFont* font = [UIFont fontWithName:@"Arial" size:14];
    QiuShi* qs = [_arrDataSource objectAtIndex:ip.row];
    CGSize size = [qs.strContent sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat rtnHeight = 0;
//    if ((qs.strSmallImageURL == nil) || ([qs.strSmallImageURL isEqualToString:@""])) {
        rtnHeight = size.height + 110;
//    }
//    else {
//        rtnHeight = size.height + 190;
//    }
    
    return rtnHeight;
}

@end
