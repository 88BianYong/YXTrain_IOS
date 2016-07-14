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
@property (nonatomic, strong) YXNoticeListRequestItem *page0RetItem;

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
- (void)saveToCache {
    // 只cache第一页结果
    NSString *cachedJson = [self.page0RetItem toJSONString];
    [[NSUserDefaults standardUserDefaults] setObject:cachedJson forKey:@"通知 first page cache"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)cachedItemArray {
    NSString *cachedJson = [[NSUserDefaults standardUserDefaults] objectForKey:@"通知 first page cache"];
    YXNoticeListRequestItem *item = [[YXNoticeListRequestItem alloc] initWithString:cachedJson error:nil];
    self.page0RetItem = item;
    if (!item) {
        return nil;
    }
    return item.body.notices;
}

@end
