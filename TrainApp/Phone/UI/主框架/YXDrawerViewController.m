//
//  YXDrawerViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDrawerViewController.h"
#import "YXSideMenuViewController.h"
#import "YXNavigationController.h"
#import "YXVideoRecordViewController.h"
static const CGFloat kAnimationDuration = 0.3;

@interface YXDrawerViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *gestureView;
@property (nonatomic, assign) BOOL isAnimating;
@end

@implementation YXDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.paneViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.paneViewController.view];
    [self.view addSubview:self.drawerViewController.view];
    [self.drawerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(self.view.mas_height);
    }];
    
    self.gestureView = [[UIView alloc]init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [self.gestureView addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    pan.maximumNumberOfTouches = 1;
    [self.gestureView addGestureRecognizer:pan];
}

- (void)showDrawer{
    self.isAnimating = YES;
    [((YXSideMenuViewController *)self.drawerViewController) displayShadowView];
    CGFloat x = self.drawerViewController.view.frame.origin.x+self.drawerViewController.view.frame.size.width;
    self.gestureView.frame = CGRectMake(x, 0, self.view.frame.size.width-x, self.view.frame.size.height);
    [self.view addSubview:self.gestureView];
    [UIView animateWithDuration:[self drawerDurationForShow:YES]
                     animations:^{
                         [self.drawerViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.left.equalTo(self.view.mas_left);
                             make.top.equalTo(self.view.mas_top);
                             make.height.equalTo(self.view.mas_height);
                         }];
                         self.gestureView.frame = CGRectMake(self.drawerWidth, 0, self.view.frame.size.width-self.drawerWidth, self.view.frame.size.height);
                         self.gestureView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.isAnimating = NO;
                     }];
    
}

- (void)hideDrawer{
    self.isAnimating = YES;
    [((YXSideMenuViewController *)self.drawerViewController) dismissShadowView];
    [UIView animateWithDuration:[self drawerDurationForShow:NO]
                     animations:^{
                         [self.drawerViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.right.equalTo(self.view.mas_left);
                             make.top.equalTo(self.view.mas_top);
                             make.height.equalTo(self.view.mas_height);
                         }];
                         [self.view layoutIfNeeded];
                         self.gestureView.frame = self.view.bounds;
                         self.gestureView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
                     }
                     completion:^(BOOL finished) {
                         [self.gestureView removeFromSuperview];
                         self.isAnimating = NO;
                     }];
}

- (CGFloat)drawerDurationForShow:(BOOL)isShow{
    CGFloat offset = self.drawerWidth-ABS(self.drawerViewController.view.frame.origin.x);
    if (isShow) {
        return kAnimationDuration * (1-offset/self.drawerWidth);
    }else{
        return kAnimationDuration * (offset/self.drawerWidth);
    }
}


#pragma mark - Gesture Handlers
- (void)tapAction:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        [self hideDrawer];
    }
}

- (void)panAction:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint p = [gesture translationInView:gesture.view];
        CGFloat offset = self.drawerViewController.view.frame.origin.x+self.drawerViewController.view.frame.size.width;
        offset += p.x;
        offset = MAX(offset, 0);
        offset = MIN(offset, self.drawerWidth);
        self.drawerViewController.view.frame = CGRectMake(-(self.drawerWidth-offset), 0, self.drawerWidth, self.view.frame.size.height);
        self.gestureView.frame = CGRectMake(offset, 0, self.view.frame.size.width-offset, self.view.frame.size.height);
        self.gestureView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5*offset/self.drawerWidth];
        [gesture setTranslation:CGPointZero inView:gesture.view];
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        CGFloat offset = self.drawerViewController.view.frame.origin.x+self.drawerViewController.view.frame.size.width;
        if (offset > self.drawerWidth/2) {
            [self showDrawer];
        }else{
            [self hideDrawer];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.isAnimating) {
        return NO;
    }
    return YES;
}
- (BOOL)shouldAutorotate {
    if ([self.presentedViewController isKindOfClass:[YXVideoRecordViewController class]]) {
        return self.presentedViewController.shouldAutorotate;
    }else {
        return ((YXNavigationController *)self.paneViewController).topViewController.shouldAutorotate;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    if ([self.presentedViewController isKindOfClass:[YXVideoRecordViewController class]]) {
        return self.presentedViewController.supportedInterfaceOrientations;
    }else {
        return ((YXNavigationController *)self.paneViewController).topViewController.supportedInterfaceOrientations;
    }
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if ([self.presentedViewController isKindOfClass:[YXVideoRecordViewController class]]) {
        [self.presentedViewController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    }else {
        [((YXNavigationController *)self.paneViewController).topViewController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    }
}
- (BOOL)prefersStatusBarHidden {
    if ([self.presentedViewController isKindOfClass:[YXVideoRecordViewController class]]) {
        return [self.presentedViewController prefersStatusBarHidden];
    }else {
        return [((YXNavigationController *)self.paneViewController).topViewController prefersStatusBarHidden];
    }
}
@end
