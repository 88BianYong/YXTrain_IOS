//
//  LSTTrainHelper_DeYang.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LSTTrainHelper_DeYang.h"
#import "YXCourseViewController.h"
@implementation LSTTrainHelper_DeYang
- (LSTTrainPresentProject)presentProject {
    return LSTTrainPresentProject_Default;
}
- (NSString *)workshopListTitle {
    return @"我的工作坊";
}
- (NSString *)workshopDetailTitle {
    return @"工作坊详情";
}
- (NSString *)workshopDetailName {
    return @"坊主";
}
- (NSString *)activityStageName {
    return @"阶段";
}
- (NSString *)firstHomeworkImageName {
    return @"APP仅支持视频课例，其他作业-请到研修网完成～";
}
- (NSString *)w {
    return [LSTSharedInstance sharedInstance].trainManager.currentProject.w;
}
- (NSArray *)sideMenuArray {
    return  @[@{@"title":@"热点",@"normalIcon":@"热点icon-正常态",@"hightIcon":@"热点icon-点击态"},
              @{@"title":@"资源",@"normalIcon":@"资源icon正常态",@"hightIcon":@"资源icon点击态"},
              @{@"title":self.workshopListTitle,@"normalIcon":@"我的工作坊icon-正常态",@"hightIcon":@"我的工作坊icon-点击态"},
              @{@"title":@"消息动态",@"normalIcon":@"消息动态icon-正常态",@"hightIcon":@"消息动态icon-点击态"}];
}


#pragma mark - show project
- (UIViewController<YXTrackPageDataProtocol> *)showExamProject {
    return [[NSClassFromString(@"DeYangExamViewController") alloc] init];
}
- (void)courseInterfaceSkip:(UIViewController *)viewController {
    UIViewController *VC = [[NSClassFromString(@"DeYangCourseViewController") alloc] init];
    [viewController.navigationController pushViewController:VC animated:YES];
}
- (void)workshopInterfaceSkip:(UIViewController *)viewController {
    UIViewController *VC = [[NSClassFromString(@"YXHomeworkListViewController") alloc] init];
    [viewController.navigationController pushViewController:VC animated:YES];
    [YXDataStatisticsManger trackEvent:@"作业列表" label:@"任务跳转" parameters:nil];
}
- (void)activityInterfaceSkip:(UIViewController *)viewController {
    UIViewController *VC = [[NSClassFromString(@"ActivityListViewController") alloc] init];
    [viewController.navigationController pushViewController:VC animated:YES];
}
@end
