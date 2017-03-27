//
//  LSTTrainHelper_Beijing.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "LSTTrainHelper_Beijing.h"
#import "YXTrackPageDataProtocol.h"
#import "BeijingHomeworkInfoViewController.h"
@interface LSTTrainHelper_Beijing ()
{
    NSString *_requireId;
    NSString *_homeworkid;
}
@end
@implementation LSTTrainHelper_Beijing
#pragma mark - get
- (LSTTrainPresentProject)presentProject {
    return LSTTrainPresentProject_Beijing;
}
- (NSString *)workshopListTitle {
    return @"我的班级";
}
- (NSString *)workshopDetailTitle {
    return @"班级详情";
}
- (NSString *)workshopDetailName {
    return @"辅导教师";
}
- (NSString *)activityStageName {
    return  @"类别";
}
- (NSString *)firstHomeworkImageName {
    return @"APP仅支持查看作业信息，请用-电脑登录研修网完成作业～";
}
- (NSString *)w {
    return @"4";
}

- (NSArray *)sideMenuArray {
    return  @[@{@"title":@"热点",@"normalIcon":@"热点icon-正常态",@"hightIcon":@"热点icon-点击态"},
              @{@"title":@"资源",@"normalIcon":@"资源icon正常态",@"hightIcon":@"资源icon点击态"},
              @{@"title":self.workshopListTitle,@"normalIcon":@"我的工作坊icon-正常态",@"hightIcon":@"我的工作坊icon-点击态"}];
}
#pragma mark - show project
- (UIViewController<YXTrackPageDataProtocol> *)showExamProject {
    return [[NSClassFromString(@"BeijingExamViewController") alloc] init];
}
- (void)courseInterfaceSkip:(UIViewController *)viewController {
    UIViewController *VC = [[NSClassFromString(@"BeijingCourseViewController") alloc] init];
    [viewController.navigationController pushViewController:VC animated:YES];
    [super courseInterfaceSkip:viewController];
}
- (void)workshopInterfaceSkip:(UIViewController *)viewController {
    BeijingHomeworkInfoViewController *VC = [[BeijingHomeworkInfoViewController alloc] init];
    YXHomeworkInfoRequestItem_Body *itemBody = [[YXHomeworkInfoRequestItem_Body alloc] init];
    itemBody.type = @"4";
    itemBody.requireId = self.requireId;
    itemBody.homeworkid = self.homeworkid;
    itemBody.pid = [YXTrainManager sharedInstance].currentProject.pid;
    VC.itemBody = itemBody;
    [viewController.navigationController pushViewController:VC animated:YES];
}
- (void)activityInterfaceSkip:(UIViewController *)viewController {
    UIViewController *VC = [[NSClassFromString(@"BeijingActivityListViewController") alloc] init];
    [viewController.navigationController pushViewController:VC animated:YES];
}
@end
