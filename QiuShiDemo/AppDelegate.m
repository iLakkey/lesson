//
//  AppDelegate.m
//  QiuShiDemo
//
//  Created by lakkey on 13-5-22.
//
//

#import "AppDelegate.h"
#import "MainVC.h"
#import "MenuVC.h"


@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 为所有的ASIHTTPRequest设定相同的默认缓存位置
    // 默认的缓存策略为：ASIAskServerIfModifiedWhenStaleCachePolicy
    // 默认的缓存周期为：ASICacheForSessionDurationCacheStoragePolicy
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
    // 设置初始的糗事类型
    self.qsType = QiuShiTypeNew;
    
    // 初始化PPRevealSideViewController，并使用MenuVC、MainVC对象进行设置
    MenuVC* leftVC = [[[MenuVC alloc] init] autorelease];
    MainVC* mainVC = [[[MainVC alloc] init] autorelease];
    UINavigationController* centerVC = [[[UINavigationController alloc] initWithRootViewController:mainVC] autorelease];
    PPRevealSideViewController* rsViewController = [[[PPRevealSideViewController alloc] initWithRootViewController:centerVC] autorelease];
    // 预加载MenuVC为PPRevealSideViewController的左侧视图控制器
    [rsViewController preloadViewController:leftVC forSide:PPRevealSideDirectionLeft];
    // 设置左侧可滑动
    [rsViewController setPanInteractionsWhenClosed:PPRevealSideInteractionContentView | PPRevealSideInteractionNavigationBar];
    // 设置弹跳方向
    [rsViewController setDirectionsToShowBounce:PPRevealSideDirectionTop];
    
    [self.window setRootViewController:rsViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
