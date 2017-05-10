//
//  YXBaseViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXDrawerController.h"

@interface YXBaseViewController ()
@end
@implementation YXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSArray *vcArray = self.navigationController.viewControllers;
    if (!isEmpty(vcArray)) {
        if (vcArray[0] != self) {
            [self setupLeftBack];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"334466"], NSForegroundColorAttributeName,[UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                     nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UINavigationController *)navigationController{
    UINavigationController *navi = [super navigationController];
    if (!navi) {
        YXDrawerViewController *drawerVC = [YXDrawerController drawer];
        if ([drawerVC.paneViewController isKindOfClass:[UINavigationController class]]) {
            navi = (UINavigationController *)drawerVC.paneViewController;
        }
    }
    return navi;
}

#pragma mark - Navi Left
- (void)setupLeftBack{
    [self setupLeftWithImageNamed:@"返回按钮" highlightImageNamed:@"返回按钮点击态"];
}

- (void)setupLeftWithImageNamed:(NSString *)imageName highlightImageNamed:(NSString *)highlightImageName{
    WEAK_SELF
    [YXNavigationBarController setLeftWithNavigationItem:self.navigationItem imageName:imageName highlightImageName:highlightImageName action:^{
        STRONG_SELF
        [self naviLeftAction];
    }];
}

- (void)setupLeftWithCustomView:(UIView *)view{
    [YXNavigationBarController setLeftWithNavigationItem:self.navigationItem customView:view];
}

- (void)naviLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navi Right
- (void)setupRightWithImageNamed:(NSString *)imageName highlightImageNamed:(NSString *)highlightImageName{
    WEAK_SELF
    [YXNavigationBarController setRightWithNavigationItem:self.navigationItem imageName:imageName highlightImageName:highlightImageName action:^{
        STRONG_SELF
        [self naviRightAction];
    }];
}

- (void)setupRightWithCustomView:(UIView *)view{
    [YXNavigationBarController setRightWithNavigationItem:self.navigationItem customView:view];
}

- (void)setupRightWithTitle:(NSString *)title{
    WEAK_SELF
    [YXNavigationBarController setRightWithNavigationItem:self.navigationItem title:title action:^{
        STRONG_SELF
        [self naviRightAction];
    }];
}

- (void)naviRightAction{
    
}

#pragma mark - 提示
- (void)startLoading{
    [YXNavigationBarController disableRightNavigationItem:self.navigationItem];
    [YXPromtController startLoadingInView:self.view];
}

- (void)stopLoading{
    [YXNavigationBarController enableRightNavigationItem:self.navigationItem];
    [YXPromtController stopLoadingInView:self.view];
    dispatch_async(dispatch_get_main_queue(), ^{//fix bug 367
        NSArray *subviews = [self.view subviews];
        for (UIView *view in subviews) {
            if ([view isKindOfClass:[MBProgressHUD class]]) {
                [self.view bringSubviewToFront:view];
                break;
            }
        }
    });
}

- (void)showToast:(NSString *)text{
    [YXPromtController showToast:text inView:self.view];
}
#pragma mark - 网络数据处理
- (BOOL)handleRequestData:(UnhandledRequestData *)data {
    return [self handleRequestData:data inView:self.view];
}
- (BOOL)handleRequestData:(UnhandledRequestData *)data inView:(UIView *)view {
    [self.emptyView removeFromSuperview];
    [self.errorView removeFromSuperview];
    [self.dataErrorView removeFromSuperview];
    
    BOOL handled = NO;
    if (data.error) {
        if (data.localDataExist) {
            [YXPromtController showToast:data.error.localizedDescription inView:view];
        }else {
            if (data.error.code == ASIConnectionFailureErrorType || data.error.code == ASIRequestTimedOutErrorType) {//网络错误/请求超时
                [view addSubview:self.errorView];
                [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                }];
            }else {
                [view addSubview:self.dataErrorView];
                [self.dataErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                }];
            }
        }
        handled = YES;
    }else {
        if (!data.requestDataExist) {
            [view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
            handled = YES;
        }
    }
    return handled;
    
}

@end
