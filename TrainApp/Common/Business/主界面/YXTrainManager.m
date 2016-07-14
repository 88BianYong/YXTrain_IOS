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
@property (nonatomic, strong) YXTrainListRequestItem *trainlistItem;
@end

@implementation YXTrainManager
@synthesize currentProjectIndex = _currentProjectIndex;

+ (instancetype)sharedInstance{
    static YXTrainManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXTrainManager alloc] init];
        [manager loadFromCache];
    });
    return manager;
}

- (YXTrainListRequestItem_body_train *)currentProject{
    if (isEmpty(self.trainlistItem.body.trains)) {
        return nil;
    }
    return self.trainlistItem.body.trains[self.currentProjectIndex];
}

- (void)getProjectsWithCompleteBlock:(void(^)(NSArray *projects, NSError *error))completeBlock{
    if (self.trainlistItem) {
        BLOCK_EXEC(completeBlock,self.trainlistItem.body.trains,nil);
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
        item.body.index = @"0";
        self.trainlistItem = item;
        [self saveToCache];
        BLOCK_EXEC(completeBlock,item.body.trains,nil);
    }];
}

- (void)setCurrentProjectIndex:(NSInteger)currentProjectIndex{
    self.trainlistItem.body.index = [NSString stringWithFormat:@"%@",@(currentProjectIndex)];
    [self saveToCache];
}

- (NSInteger)currentProjectIndex{
    return self.trainlistItem.body.index.integerValue;
}

- (void)saveToCache{
    [[NSUserDefaults standardUserDefaults]setValue:[self.trainlistItem toJSONString] forKey:@"kTrainListItem"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)loadFromCache{
    NSString *json = [[NSUserDefaults standardUserDefaults]valueForKey:@"kTrainListItem"];
    if (json) {
        self.trainlistItem = [[YXTrainListRequestItem alloc]initWithString:json error:nil];
    }
}

- (void)clear{
    [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"kTrainListItem"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
