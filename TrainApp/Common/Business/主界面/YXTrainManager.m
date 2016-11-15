//
//  YXTrainManager.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/1.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTrainManager.h"

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
    if (isEmpty(self.trainlistItem.body.training) && isEmpty(self.trainlistItem.body.trained)) {
        return nil;
    }
    NSInteger section = self.currentProjectIndexPath.section;
    NSInteger currentProjectIndex = self.currentProjectIndexPath.row;
    if (section== 0) {
        return self.trainlistItem.body.training[currentProjectIndex];
    }else{
        return self.trainlistItem.body.trained[currentProjectIndex];
    }
}
- (void)getProjectsWithCompleteBlock:(void(^)(YXTrainListRequestItem_body *body, NSError *error))completeBlock {
    if (self.trainlistItem) {
        BLOCK_EXEC(completeBlock,self.trainlistItem.body,nil);
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
        self.trainlistItem.token = [YXUserManager sharedManager].userModel.token;
        [self saveToCache];
        BLOCK_EXEC(completeBlock,item.body,nil);
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
- (BOOL)isShowCMSView:(NSArray *)rotate {
    BOOL isShow = NO;
    for (YXTrainListRequestItem_body_train *p in self.trainlistItem.body.trains) {
        for (NSString *string in rotate) {
            if ([p.pid isEqualToString:string]) {
                isShow = YES;
                return isShow;
            }
        }
    }
    return isShow;
}

@end
