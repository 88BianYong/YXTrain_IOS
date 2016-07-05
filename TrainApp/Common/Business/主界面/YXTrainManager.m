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

+ (instancetype)sharedInstance{
    static YXTrainManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXTrainManager alloc] init];
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
        self.trainlistItem = item;
        BLOCK_EXEC(completeBlock,item.body.trains,nil);
    }];
}



@end
