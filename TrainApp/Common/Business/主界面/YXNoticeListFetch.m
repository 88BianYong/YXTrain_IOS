//
//  YXNoticeListFetch.m
//  TrainApp
//
//  Created by 李五民 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXNoticeListFetch.h"

@interface YXNoticeListFetch ()

@property (nonatomic, strong) YXNoticeListRequest *request;

@end

@implementation YXNoticeListFetch

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    [self stop];
    self.request = [[YXNoticeListRequest alloc] init];
    self.request.pid = [YXTrainManager sharedInstance].currentProject.pid;
    [self.request startRequestWithRetClass:[YXNoticeListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
            aCompleteBlock(0, nil, error);
            return;
        }
        YXNoticeListRequestItem *item = retItem;
        aCompleteBlock((int)item.body.notices.count, item.body.notices, nil);
    }];
    
}

- (void)stop {
    [self.request stopRequest];
}

@end
