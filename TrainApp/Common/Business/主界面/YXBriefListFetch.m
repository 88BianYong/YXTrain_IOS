//
//  YXBriefListFetch.m
//  TrainApp
//
//  Created by 李五民 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBriefListFetch.h"

@interface YXBriefListFetch ()

@property (nonatomic, strong) YXBriefListRequest *request;

@end

@implementation YXBriefListFetch

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    [self stop];
    self.request = [[YXBriefListRequest alloc] init];
    self.request.pid = [YXTrainManager sharedInstance].currentProject.pid;
    [self.request startRequestWithRetClass:[YXBriefListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
            aCompleteBlock(0, nil, error);
            return;
        }
        YXBriefListRequestItem *item = retItem;
        aCompleteBlock((int)item.body.briefs.count, item.body.briefs, nil);
    }];
}

- (void)stop {
    [self.request stopRequest];
}

@end
