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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    return NO;
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
    [self setupLeftWithImageNamed:@"返回" highlightImageNamed:@"返回"];
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
}

- (void)showToast:(NSString *)text{
    [YXPromtController showToast:text inView:self.view];
}

@end
