//
//  PhotoViewerVC.m
//  QiuShiDemo
//
//  Created by lakkey on 13-5-30.
//
//

#import "PhotoViewerVC.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>


@interface PhotoViewerVC () <UIScrollViewDelegate, EGOImageViewDelegate>

#define ANIMATION_DURATION 0.6f // 动画执行的时间

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UILabel*      label;
@property (nonatomic, assign) CGPoint       potCenter; // 保存图片的初始中心位置
@property (nonatomic, assign) CGAffineTransform trans; // 保存图片的初始变形
@property (nonatomic, assign) CGFloat       fScale;

@end

@implementation PhotoViewerVC

- (void)dealloc
{
    NSLog(@"%@ : dealloc", self);
    self.egoImageView = nil;
    self.scrollView = nil;
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
    
    // 背景色
    [self.view setBackgroundColor:[UIColor blackColor]];
    // 隐藏状态栏
    UIApplication* app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    //
    self.scrollView = [[[UIScrollView alloc] initWithFrame:app.keyWindow.bounds] autorelease];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, _scrollView.bounds.size.height);
    [self.view addSubview:_scrollView];
    
    // _scrollView加入轻击手势
    UITapGestureRecognizer* tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)] autorelease];
    [_scrollView addGestureRecognizer:tap];
    
    //
//    [_scrollView setBackgroundColor:[UIColor greenColor]];
    [_egoImageView setDelegate:self];
    [_egoImageView setFrame:_rectStart];
    [_scrollView addSubview:_egoImageView];
    [_scrollView setDelegate:self];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 为图片的中心点属性设置动画
    CABasicAnimation* animCenter = [CABasicAnimation animationWithKeyPath:@"position"];
    _potCenter = _egoImageView.center;
    animCenter.fromValue = [NSValue valueWithCGPoint:_potCenter];
    animCenter.toValue = [NSValue valueWithCGPoint:self.view.center];
    
    // 为图片的缩放属性设置动画
    CABasicAnimation* animScale = [CABasicAnimation animationWithKeyPath:@"transform"];
    self.trans = _egoImageView.transform;
    animScale.fromValue = [NSValue valueWithCGAffineTransform:_trans];
    float fWidthScale = 0;
    float fHeightScale = 0;
    fWidthScale = self.view.bounds.size.width / _egoImageView.bounds.size.width;
    fHeightScale = self.view.bounds.size.height / _egoImageView.bounds.size.height;
    _fScale = MIN(fWidthScale, fHeightScale);
    animScale.toValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(_fScale, _fScale)];
    
    // 设置_scrollView内容的缩放比率
    [_scrollView setMinimumZoomScale:_fScale];
    [_scrollView setMaximumZoomScale:_fScale * 4];
    [_scrollView setZoomScale:_fScale];
    
    //
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.duration = ANIMATION_DURATION;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.animations = @[animCenter, animScale];
    [_egoImageView.layer addAnimation:group forKey:nil];
    
    // 设置动画完成后的属性
    _egoImageView.center = [animCenter.toValue CGPointValue];
    _egoImageView.transform = [animScale.toValue CGAffineTransformValue];
    [_egoImageView setImageURL:[NSURL URLWithString:_strImageURL]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Orientation

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - EGOImageViewDelegate

- (void)imageViewLoadedImage:(EGOImageView *)imageView {

}


- (void)imageViewFailedToLoadImage:(EGOImageView *)imageView
                             error:(NSError *)error {
    [imageView cancelImageLoad];
}

#pragma mark - UIScrollViewDelegate

- (UIView* )viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _egoImageView;
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView
                          withView:(UIView *)view {

}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(float)scale {
    [scrollView setZoomScale:scrollView.zoomScale animated:NO];
//    _potCenter = CGPointMake(_potCenter.x * scrollView.zoomScale, _potCenter.y * scrollView.zoomScale);
}


#pragma mark - Gestrure Handle Method


- (void)handleTapGesture:(UITapGestureRecognizer* )tap {
    // 先缩放到最初的状态
    [_scrollView setZoomScale:_fScale];
    
    // 为图片的中心点属性设置动画
    CABasicAnimation* animCenter = [CABasicAnimation animationWithKeyPath:@"position"];
    animCenter.fromValue = [NSValue valueWithCGPoint:_egoImageView.center];
    animCenter.toValue = [NSValue valueWithCGPoint:_potCenter];
    
    // 为图片的缩放属性设置动画
    CABasicAnimation* animScale = [CABasicAnimation animationWithKeyPath:@"transform"];
    animScale.fromValue = [NSValue valueWithCGAffineTransform:_egoImageView.transform];
    animScale.toValue = [NSValue valueWithCGAffineTransform:_trans];
    
    // 
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.duration = ANIMATION_DURATION;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.animations = @[animCenter, animScale];
    [_egoImageView.layer addAnimation:group forKey:nil];
    
    // 设置动画完成后的属性
    _egoImageView.center = [animCenter.toValue CGPointValue];
    _egoImageView.transform = [animScale.toValue CGAffineTransformValue];
    
    // 延迟解除模态视图
    [self performSelector:@selector(dismissSelfWithTap:) withObject:tap afterDelay:ANIMATION_DURATION];
}


#pragma mark - Private Method

- (void)dismissSelfWithTap:(id)tap {
    UIApplication* app = [UIApplication sharedApplication];
    // 显示状态栏
    [app setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    // 解除手势
    [_scrollView removeGestureRecognizer:tap];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:NO completion:nil];
}




@end
