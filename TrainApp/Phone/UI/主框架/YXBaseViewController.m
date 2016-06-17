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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UINavigationController *)navigationController{
    UINavigationController *navi = [super navigationController];
    if (!navi) {
        MSDynamicsDrawerViewController *drawerVC = [YXDrawerController drawer];
        if ([drawerVC.paneViewController isKindOfClass:[UINavigationController class]]) {
            navi = (UINavigationController *)drawerVC.paneViewController;
        }
    }
    return navi;
}

#pragma mark - 提示
- (void)startLoading{
    
}

- (void)stopLoading{
    
}

- (void)showToast:(NSString *)text{
    
}

@end
