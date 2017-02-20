//
//  YXProjectMainViewController+Student.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXProjectMainViewController+Student.h"
#import "YXProjectContainerView.h"
#import "YXTaskViewController.h"
#import "YXNoticeViewController.h"
#import "YXCourseRecordViewController.h"
@implementation YXProjectMainViewController (Student)
- (void)showStudentInterface {
    if ([YXTrainManager sharedInstance].currentProject.w.integerValue >= 3) {
        YXProjectContainerView *containerView = [[YXProjectContainerView alloc]initWithFrame:self.view.bounds];
        WEAK_SELF
        containerView.selectedViewContrller = ^(UIViewController<YXTrackPageDataProtocol> *vc){
            STRONG_SELF
            [self.selectedViewController report:NO];
            self.selectedViewController = vc;
            [self.selectedViewController report:YES];
        };
        UIViewController<YXTrackPageDataProtocol> *examVC = [[YXTrainManager sharedInstance].trainHelper showExamProject];
        YXTaskViewController *taskVC = [[YXTaskViewController alloc]init];
        YXNoticeViewController *notiVC = [[YXNoticeViewController alloc]init];
        notiVC.flag = YXFlag_Notice;
        YXNoticeViewController *bulletinVC = [[YXNoticeViewController alloc]init];
        bulletinVC.flag = YXFlag_Bulletin;
        containerView.viewControllers = @[examVC,taskVC,notiVC,bulletinVC];
        self.selectedViewController = examVC;
        containerView.tag = 10001;
        [self.view addSubview:containerView];
        [self addChildViewController:examVC];
        [self addChildViewController:taskVC];
        [self addChildViewController:notiVC];
        [self addChildViewController:bulletinVC];
        [self showSwitchGuideView];
    }else{
        YXCourseRecordViewController *recordVc = [[YXCourseRecordViewController alloc]init];
        recordVc.view.frame = self.view.bounds;
        [self.view addSubview:recordVc.view];
        [self addChildViewController:recordVc];
    }

}
@end
