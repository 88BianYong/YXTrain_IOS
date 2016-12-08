//
//  YXTrainManager.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/1.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTrainManager.h"
#import "YXCourseViewController.h"
#import "YXHomeworkInfoViewController.h"
static  NSString *const trackLabelOfJumpFromTaskList = @"任务跳转";
@interface YXTrainManager()
@property (nonatomic, strong) YXTrainListRequest *request;

@end

@implementation YXTrainManager
@synthesize currentProjectIndexPath = _currentProjectIndexPath;
+ (instancetype)sharedInstance {
    static YXTrainManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXTrainManager alloc] init];
        [manager loadFromCache];
    });
    return manager;
}

- (YXTrainListRequestItem_body_train *)currentProject {
    NSArray *groups = [TrainListProjectGroup projectGroupsWithRawData:self.trainlistItem.body];
    if (isEmpty(groups)) {
        return nil;
    }
    TrainListProjectGroup *group = groups[self.currentProjectIndexPath.section];
    NSArray *items = group.items;
    return items[self.currentProjectIndexPath.row];
}
- (void)getProjectsWithCompleteBlock:(void(^)(NSArray *groups, NSError *error))completeBlock {
    if (self.trainlistItem) {
        BLOCK_EXEC(completeBlock,[TrainListProjectGroup projectGroupsWithRawData:self.trainlistItem.body],nil);
        return;
    }
    [self.request stopRequest];
    self.request = [[YXTrainListRequest alloc]init];
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXTrainListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        YXTrainListRequestItem *item = (YXTrainListRequestItem *)retItem;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        item.body.indexPathSection = [NSString stringWithFormat:@"%@",@(indexPath.section)];
        item.body.indexPathRow = [NSString stringWithFormat:@"%@",@(indexPath.row)];
        self.trainlistItem = item;
        [self saveToCache];
        NSArray *projectGroupArray = [TrainListProjectGroup projectGroupsWithRawData:item.body];
        BLOCK_EXEC(completeBlock,projectGroupArray,nil);
    }];
}
- (void)setCurrentProjectIndexPath:(NSIndexPath *)currentProjectIndexPath {
    self.trainlistItem.body.indexPathSection = [NSString stringWithFormat:@"%@",@(currentProjectIndexPath.section)];
    self.trainlistItem.body.indexPathRow = [NSString stringWithFormat:@"%@",@(currentProjectIndexPath.row)];
    [self saveToCache];
}
- (NSIndexPath *)currentProjectIndexPath {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.trainlistItem.body.indexPathRow.integerValue inSection:self.trainlistItem.body.indexPathSection.integerValue];
    return indexPath;
}
- (void)saveToCache {
    [[NSUserDefaults standardUserDefaults]setValue:[self.trainlistItem toJSONString] forKey:@"kTrainListItem"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainListDynamic object:nil];
}

- (void)loadFromCache {
    NSString *json = [[NSUserDefaults standardUserDefaults]valueForKey:@"kTrainListItem"];
    if (json) {
        self.trainlistItem = [[YXTrainListRequestItem alloc]initWithString:json error:nil];
    }
}
- (void)clear {
    self.trainlistItem = nil;
    [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"kTrainListItem"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (BOOL)isBeijingProject {
    return [self.currentProject.pid isEqualToString:YXTrainBeijingProjectId];
}


#pragma mark - show project
- (UIViewController<YXTrackPageDataProtocol> *)showExamProject {
    UIViewController<YXTrackPageDataProtocol> *examVC = nil;
    if ([YXTrainManager sharedInstance].isBeijingProject) {
        NSString *string = @"BeijingExamViewController";
        examVC = [[NSClassFromString(string) alloc] init];
    }else {
        NSString *string = @"YXExamViewController";
        examVC = [[NSClassFromString(string) alloc] init];
    }
    return examVC;
}
- (void)courseInterfaceSkip:(UIViewController *)viewController {
    if ([YXTrainManager sharedInstance].isBeijingProject) {
        NSString *string = @"BeijingCourseViewController";
        UIViewController *VC = [[NSClassFromString(string) alloc] init];
        [viewController.navigationController pushViewController:VC animated:YES];
    }else {
        YXCourseViewController *vc = [[YXCourseViewController alloc]init];
        vc.status = YXCourseFromStatus_Course;
        [viewController.navigationController pushViewController:vc animated:YES];
    }
    [YXDataStatisticsManger trackEvent:@"课程列表" label:trackLabelOfJumpFromTaskList parameters:nil];
}
- (void)workshopInterfaceSkip:(UIViewController *)viewController {
    if ([YXTrainManager sharedInstance].isBeijingProject) {
        YXHomeworkInfoViewController *VC = [[YXHomeworkInfoViewController alloc] init];
        YXHomeworkInfoRequestItem_Body *itemBody = [[YXHomeworkInfoRequestItem_Body alloc] init];
        itemBody.type = @"4";
        itemBody.requireId = [YXTrainManager sharedInstance].requireId;
        itemBody.homeworkid = [YXTrainManager sharedInstance].homeworkid;
        itemBody.pid = [YXTrainManager sharedInstance].currentProject.pid;
        VC.itemBody = itemBody;
        [viewController.navigationController pushViewController:VC animated:YES];
    }else {
        NSString *string = @"YXHomeworkListViewController";
        UIViewController *VC = [[NSClassFromString(string) alloc] init];
        [viewController.navigationController pushViewController:VC animated:YES];
        [YXDataStatisticsManger trackEvent:@"作业列表" label:trackLabelOfJumpFromTaskList parameters:nil];
    }
}
- (void)activityInterfaceSkip:(UIViewController *)viewController {
    if ([YXTrainManager sharedInstance].isBeijingProject) {
        NSString *string = @"BeijingActivityListViewController";
        UIViewController *VC = [[NSClassFromString(string) alloc] init];
        [viewController.navigationController pushViewController:VC animated:YES];
    }
    else{
        NSString *string = @"ActivityListViewController";
        UIViewController *VC = [[NSClassFromString(string) alloc] init];
        [viewController.navigationController pushViewController:VC animated:YES];
    }
    [YXDataStatisticsManger trackEvent:@"活动列表" label:trackLabelOfJumpFromTaskList parameters:nil];
}
@end
