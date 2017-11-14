//
//  YXMyDatumFetcher.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMyDatumFetcher.h"
#import "YXDatumCellModel.h"
#import "YXDatumGlobalSingleton.h"

@interface YXMyDatumFetcher()
@property (nonatomic, strong) YXMyDatumRequest *request;
@end

@implementation YXMyDatumFetcher

- (void)startWithBlock:(void(^)(NSInteger total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    [self stop];
    self.request = [[YXMyDatumRequest alloc] init];
    self.request.order = @"createtime";
    self.request.pageindex = [NSString stringWithFormat:@"%d", self.pageindex + 1];
    self.request.pagesize = [NSString stringWithFormat:@"%d", self.pagesize];
    if (self.pageindex  == 0) {
        self.request.myOffset = @"0";
        self.request.slOffset = @"0";
    }else{
        self.request.myOffset = [LSTSharedInstance sharedInstance].globalSingleton.myOffset;
        self.request.slOffset = [LSTSharedInstance sharedInstance].globalSingleton.slOffset;
    }
    @weakify(self);
    [self.request startRequestWithRetClass:[YXMyDatumRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self); if (!self) return;
        if (error) {
            aCompleteBlock(0, nil, error);
            return;
        }
        if (self.pageindex == 0) {
            self.page0RetItem = retItem;
            [self saveToCache];
        }
        YXMyDatumRequestItem *item = retItem;
        [LSTSharedInstance sharedInstance].globalSingleton.myOffset = item.myOffset;
        [LSTSharedInstance sharedInstance].globalSingleton.slOffset = item.slOffset;
        NSMutableArray *array = [NSMutableArray array];
        for (YXMyDatumRequestItem_result_list *list in item.result.list) {
            YXDatumCellModel *model = [YXDatumCellModel modelFromMyDatumRequestResultList:list];
            [array addObject:model];
        }
        aCompleteBlock(item.result.total.intValue, array, nil);
    }];
    
}

- (void)stop {
    [self.request stopRequest];
}
- (void)saveToCache {
    // 只cache第一页结果
    NSString *cachedJson = [self.page0RetItem toJSONString];
    [[NSUserDefaults standardUserDefaults] setObject:cachedJson forKey:@"我的资源 first page cache"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)cachedItemArray {
    NSString *cachedJson = [[NSUserDefaults standardUserDefaults] objectForKey:@"我的资源 first page cache"];
    YXMyDatumRequestItem *item = [[YXMyDatumRequestItem alloc] initWithString:cachedJson error:nil];
    self.page0RetItem = item;
    if (!item) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (YXMyDatumRequestItem_result_list *list in item.result.list) {
        YXDatumCellModel *model = [YXDatumCellModel modelFromMyDatumRequestResultList:list];
        [array addObject:model];
    }
    
    return [NSArray arrayWithArray:array];
}
@end
