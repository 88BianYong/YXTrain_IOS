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
#import "AppDelegate.h"
static  NSString *const trackLabelOfJumpFromTaskList = @"任务跳转";
@interface YXTrainManager()
@property (nonatomic, strong) YXTrainListRequest *request;
@end

@implementation YXTrainManager
@synthesize currentProjectIndex = _currentProjectIndex;
- (instancetype)init {
    if (self = [super init]) {
        [self loadFromCache];
    }
    return self;
}
- (LSTTrainHelper *)trainHelper {
    if (_trainHelper == nil) {
        _trainHelper = [LSTTrainHelper alloc];
    }
    return _trainHelper;
}



- (YXTrainListRequestItem_body_train *)currentProject {
    if (self.trainlistItem.body.trains.count ==  0) {
        return nil;
    }
    if (self.currentProjectIndex >= self.trainlistItem.body.trains.count) {
        return self.trainlistItem.body.trains[0];
    }
    return self.trainlistItem.body.trains[self.currentProjectIndex];
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
                [self chooseProjectWithChoosePid:self.trainlistItem.body.choosePid withBody:self.trainlistItem.body];
                BLOCK_EXEC(completeBlock,self.trainlistItem.body.trains,nil);
            }else {
                BLOCK_EXEC(completeBlock,nil,error);
            }
            return;
        }
        YXTrainListRequestItem *item = (YXTrainListRequestItem *)retItem;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (!isEmpty(appDelegate.appDelegateHelper.projectId)) {
            [self chooseProjectWithChoosePid:appDelegate.appDelegateHelper.projectId withBody:item.body];
            item.body.choosePid = appDelegate.appDelegateHelper.projectId;
        }else {
            [self chooseProjectWithChoosePid:self.trainlistItem.body.choosePid withBody:item.body];
            item.body.choosePid = self.trainlistItem.body.choosePid;
        }
        self.trainlistItem = item;
        [self saveToCache];
        BLOCK_EXEC(completeBlock,self.trainlistItem.body.trains,nil);
    }];
}

- (NSInteger)chooseProjectWithChoosePid:(NSString *)pid withBody:(YXTrainListRequestItem_body *)body{
    __block NSInteger chooseInteger = -1;
    [body.trains enumerateObjectsUsingBlock:^(YXTrainListRequestItem_body_train *train, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([pid isEqualToString:train.pid]) {
            chooseInteger = idx;
        }
    }];
    if (chooseInteger > 0) {
        self.currentProjectIndex = chooseInteger;
    }else {
        self.currentProjectIndex = 0;
    }
    return chooseInteger;
}
- (void)setTrainlistItem:(YXTrainListRequestItem *)trainlistItem {
    self.trainHelper = nil;
    _trainlistItem = trainlistItem;
    
}
- (void)setCurrentProjectIndex:(NSInteger)currentProjectIndex {
    BOOL isChangeBool = NO;
    if (self.trainlistItem.body.trains.count > 0) {
        YXTrainListRequestItem_body_train *oldTrain = self.trainlistItem.body.trains[_currentProjectIndex];
        YXTrainListRequestItem_body_train *newTrain = self.trainlistItem.body.trains[currentProjectIndex];
        if (newTrain.w.integerValue >= 5 || oldTrain.w.integerValue >= 5) {//只有同为16项目才不需要刷新
            isChangeBool = YES;
        }
        if ([LSTSharedInstance sharedInstance].geTuiManger.pushModel != nil) {//如果有待切换项目
            isChangeBool = YES;
            NSInteger typeInteger = [LSTSharedInstance sharedInstance].geTuiManger.pushModel.type.integerValue;
            if (typeInteger >= 31 && typeInteger <=35) {//坊主 1、2、31、32、33、34、35
                newTrain.role = @"99";
            }
            if (typeInteger >= 3 && typeInteger <= 6) {//学员 1、2、3、4、5、6
                newTrain.role = @"9";
            }
            if (typeInteger == 1 || typeInteger == 2) {//通知简报双身份,进入学员
                if(newTrain.isDoubel.boolValue){
                    newTrain.role = @"9";
                }
            }
        }
        if (_currentProjectIndex == currentProjectIndex) {//登录后首次选择通过这里今入主界面
            isChangeBool = YES;
        }
        oldTrain.role = nil;
    }
    _currentProjectIndex = currentProjectIndex;
    self.trainlistItem.body.choosePid = self.currentProject.pid;
    [self saveToCache];
    if (isChangeBool) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kXYTrainChangeProject object:@(self.trainStatus)];
    }
    
}
- (NSInteger)currentProjectIndex {
    return _currentProjectIndex;
}
- (LSTTrainProjectStatus)trainStatus {
    if (self.trainlistItem == nil) {
        return LSTTrainProjectStatus_unKnow;
    }
    if (self.currentProject.w.integerValue == 5) {
        return LSTTrainProjectStatus_2017;
    }
    return LSTTrainProjectStatus_2016;
}
- (BOOL)setupProjectId:(NSString *)projectId {
    NSInteger integer = [self chooseProjectWithChoosePid:projectId withBody:self.trainlistItem.body];
    if (integer >= 0) {
        return YES;
    }else {
        return NO;
    }
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
