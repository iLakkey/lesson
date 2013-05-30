//
//  PhotoViewerVC.m
//  QiuShiDemo
//
//  Created by lakkey on 13-5-30.
//
//

#import "PhotoViewerVC.h"
#import "EGOImageView.h"

@interface PhotoViewerVC ()

#define ANIMATION_DURATION 0.3 // 动画执行的时间

@property (nonatomic, copy) NSString*       strImageURL;
@property (nonatomic, assign) CGFloat       fRotation;
@property (nonatomic, assign) CGFloat       fScale;

@end

@implementation PhotoViewerVC

- (void)dealloc
{
    NSLog(@"%@ : dealloc", self);
    self.egoImageView = nil;
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    // 隐藏状态栏
    UIApplication* app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 加入轻击手势
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tap];
    
    // 
    [self.view addSubview:_egoImageView];
    [_egoImageView setFrame:_rectStart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)handleTapGesture:(UITapGestureRecognizer* )tap {
    UIApplication* app = [UIApplication sharedApplication];
    // 显示状态栏
    [app setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    // 解除模态视图
    [[[app keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
