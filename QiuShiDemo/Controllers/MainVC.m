//
//  MainVC.m
//  QiuShiDemo
//
//  Created by lakkey on 13-5-22.
//
//

#import "MainVC.h"
#import "PullingRefreshTableView.h"


#define PAGECOUNT 20    // 一次加载的最大数据量

@interface MainVC () <PullingRefreshTableViewDelegate>

@property (nonatomic, assign) PullingRefreshTableView* refreshView;
@property (nonatomic, assign) NSInteger         nLoadedCount;
@property (nonatomic, strong) NSMutableArray*   arrDataSource;

@end

@implementation MainVC

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
    
    self.arrDataSource = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59", @"60", @"61", @"62", @"63", @"64", @"65", @"66", @"67", @"68", @"69", @"70", @"71", @"72", @"73", @"74", @"75", @"76", @"77", @"78", @"79", @"80", @"81", @"82", @"83", @"84", @"85", @"86", @"87", @"88", @"89", @"90", @"91", @"92", @"93", @"94", @"95", @"96", @"97", @"98", @"99", @"100", nil];
    
    // 将视图控制器的默认主视图替换为PullingRefreshTableView
    _refreshView = [[[PullingRefreshTableView alloc] initWithFrame:self.view.frame pullingDelegate:self] autorelease];
    self.tableView = _refreshView;
    [_refreshView launchRefreshing];
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
    return _nLoadedCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [_arrDataSource objectAtIndex:indexPath.row];
    
    return cell;
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
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.1];
}


// 上拉时的回调方法
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView {
    [self performSelector:@selector(loadMoveData) withObject:nil afterDelay:0.1];
}


#pragma mark - Private Method

- (void)refreshData {
    _nLoadedCount = MIN([_arrDataSource count], PAGECOUNT);
    if (_nLoadedCount == [_arrDataSource count]) {
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
    // 检查nLoadedCount是否小于arrDataSource中的元素个数
    // *是，加载
    if (_nLoadedCount < nAllDataCount) {
        if ((_nLoadedCount += PAGECOUNT) > nAllDataCount) {
            _nLoadedCount = nAllDataCount;
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


@end
