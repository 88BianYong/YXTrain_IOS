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
@property (nonatomic, strong) YXNoticeListRequestItem *page0RetItem;

@end

@implementation YXBriefListFetch

- (void)startWithBlock:(void(^)(NSInteger total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    [self stop];
    self.request = [[YXBriefListRequest alloc] init];
    self.request.pid = [YXTrainManager sharedInstance].currentProject.pid;
    [self.request startRequestWithRetClass:[YXBriefListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
            aCompleteBlock(0, nil, error);
            return;
        }
        if (self.pageindex == 0) {
            self.page0RetItem = retItem;
            [self saveToCache];
        }
        YXBriefListRequestItem *item = retItem;
        aCompleteBlock((int)item.body.briefs.count, item.body.briefs, nil);
    }];
}

- (void)stop {
    [self.request stopRequest];
}

- (void)saveToCache {
    // 只cache第一页结果
    NSString *cachedJson = [self.page0RetItem toJSONString];
    [[NSUserDefaults standardUserDefaults] setObject:cachedJson forKey:@"简报 first page cache"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)cachedItemArray {
    NSString *cachedJson = [[NSUserDefaults standardUserDefaults] objectForKey:@"简报 first page cache"];
    YXNoticeListRequestItem *item = [[YXNoticeListRequestItem alloc] initWithString:cachedJson error:nil];
    self.page0RetItem = item;
    if (!item) {
        return nil;
    }
    return item.body.notices;
}

@end
