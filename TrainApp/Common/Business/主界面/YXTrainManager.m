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
- (LSTTrainHelper *)trainHelper {
    if (_trainHelper == nil) {
        _trainHelper = [LSTTrainHelper alloc];
    }
    return _trainHelper;
}



- (YXTrainListRequestItem_body_train *)currentProject {
    NSArray *groups = [TrainListProjectGroup projectGroupsWithRawData:self.trainlistItem.body];
    if (isEmpty(groups)) {
        return nil;
    }
    if (self.currentProjectIndexPath.section >= groups.count) {
        self.currentProjectIndexPath = [NSIndexPath indexPathForRow:self.currentProjectIndexPath.row inSection:0];
    }
    TrainListProjectGroup *group = groups[self.currentProjectIndexPath.section];
    NSArray *items = group.items;
    if (self.currentProjectIndexPath.row >= items.count) {
        self.currentProjectIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentProjectIndexPath.section];
    }
    return items[self.currentProjectIndexPath.row];
}
- (void)getProjectsWithCompleteBlock:(void(^)(NSArray *groups, NSError *error))completeBlock {
    self.trainHelper = nil;
    [self.request stopRequest];
    self.request = [[YXTrainListRequest alloc]init];
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXTrainListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            if (self.trainlistItem) {
                self.currentProjectIndexPath = [self chooseProjectWithChoosePid:self.trainlistItem.body.choosePid];
                BLOCK_EXEC(completeBlock,[TrainListProjectGroup projectGroupsWithRawData:self.trainlistItem.body],nil);
            }else {
                BLOCK_EXEC(completeBlock,nil,error);
            }
            return;
        }
        YXTrainListRequestItem *item = (YXTrainListRequestItem *)retItem;
        self.currentProjectIndexPath = [self chooseProjectWithChoosePid:self.trainlistItem.body.choosePid];
        item.body.choosePid = self.trainlistItem.body.choosePid;
        self.trainlistItem = item;
        NSArray *projectGroupArray = [TrainListProjectGroup projectGroupsWithRawData:item.body];
        BLOCK_EXEC(completeBlock,projectGroupArray,nil);
        [self saveToCache];
    }];
}
- (NSIndexPath *)chooseProjectWithChoosePid:(NSString *)pid {
    NSArray<TrainListProjectGroup *> *groups = [TrainListProjectGroup projectGroupsWithRawData:self.trainlistItem.body];
    __block NSInteger sectionInteger = 0;
    __block NSInteger indexInteger = 0;
    [groups enumerateObjectsUsingBlock:^(TrainListProjectGroup * _Nonnull obj, NSUInteger section, BOOL * _Nonnull stop) {
        [obj.items enumerateObjectsUsingBlock:^(YXTrainListRequestItem_body_train * _Nonnull train, NSUInteger index, BOOL * _Nonnull stop) {
            if ([pid isEqualToString:train.pid]) {
                sectionInteger = section;
                indexInteger = index;
            }
        }];
    }];
    return [NSIndexPath indexPathForRow:indexInteger inSection:sectionInteger];
}
- (void)setTrainlistItem:(YXTrainListRequestItem *)trainlistItem {
    self.trainHelper = nil;
    _trainlistItem = trainlistItem;
    
}
- (void)setCurrentProjectIndexPath:(NSIndexPath *)currentProjectIndexPath {
    _currentProjectIndexPath = currentProjectIndexPath;
    self.trainlistItem.body.choosePid = self.currentProject.pid;
    [self saveToCache];
}
- (NSIndexPath *)currentProjectIndexPath {
    return _currentProjectIndexPath;
}
- (void)saveToCache {
    self.trainHelper = nil;
    NSString *json = [self.trainlistItem toJSONString] ;
    [[NSUserDefaults standardUserDefaults]setValue:json forKey:@"kTrainListItem"];
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
@end
