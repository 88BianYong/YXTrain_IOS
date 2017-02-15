//
//  YXProjectMainViewController+Master.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXProjectMainViewController+Master.h"
#import "MasterProjectContainerView.h"
#import "YXNoticeViewController.h"
#import "MasterHappeningViewController.h"
@implementation YXProjectMainViewController (Master)
- (void)showMasterInterface {
    MasterProjectContainerView *containerView = [[MasterProjectContainerView alloc]initWithFrame:self.view.bounds];
    UIViewController *happeningVC = [[NSClassFromString(@"MasterHappeningViewController") alloc] init];
    UIViewController *studentsVC = [[NSClassFromString(@"MasterManageViewController") alloc] init];
    YXNoticeViewController *bulletinVC = [[YXNoticeViewController alloc]init];
    bulletinVC.flag = YXFlag_Bulletin;
    containerView.viewControllers = @[happeningVC,studentsVC,bulletinVC];
    containerView.tag = 10001;
    [self.view addSubview:containerView];
    [self addChildViewController:happeningVC];
    [self addChildViewController:studentsVC];
    [self addChildViewController:bulletinVC];
    
    static NSString *staticString = @"ChangeProjectRoleView";
    UIView *roleView = [[NSClassFromString(staticString) alloc] init];
    [self.navigationController.view addSubview:roleView];
    [roleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
 
}
@end
