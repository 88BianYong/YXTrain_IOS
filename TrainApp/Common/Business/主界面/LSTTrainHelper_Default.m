//
//  LSTTrainHelper_Default.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "LSTTrainHelper_Default.h"
#import "YXCourseViewController.h"
@implementation LSTTrainHelper_Default
#pragma mark - get
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


#pragma mark - show project
- (UIViewController<YXTrackPageDataProtocol> *)showExamProject {
    return [[NSClassFromString(@"YXExamViewController") alloc] init];;
}
- (void)courseInterfaceSkip:(UIViewController *)viewController {
    YXCourseViewController *vc = [[YXCourseViewController alloc]init];
    vc.status = YXCourseFromStatus_Course;
    [viewController.navigationController pushViewController:vc animated:YES];
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
