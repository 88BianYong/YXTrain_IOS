//
//  YXWholeDatumFetcher.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXWholeDatumFetcher.h"
#import "YXDatumCellModel.h"

@interface YXWholeDatumFetcher()
@property (nonatomic, strong) YXDatumSearchRequest *request;
@end

@implementation YXWholeDatumFetcher

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    [self stop];
    self.request = [[YXDatumSearchRequest alloc] init];
    self.request.condition = self.condition;
    self.request.pageindex = [NSString stringWithFormat:@"%d", self.pageindex + 1];
    self.request.pagesize = [NSString stringWithFormat:@"%d", self.pagesize];
    @weakify(self);
    [self.request startRequestWithRetClass:[YXDatumSearchRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self); if (!self) return;
        if (error) {
            aCompleteBlock(0, nil, error);
            return;
        }
        if (self.pageindex == 0) {
            self.page0RetItem = retItem;
            [self saveToCache];
        }
        YXDatumSearchRequestItem *datumItem = retItem;
        NSMutableArray *array = [NSMutableArray array];
        for (YXDatumSearchRequestItem_data *data in datumItem.data) {
            YXDatumCellModel *model = [YXDatumCellModel modelFromSearchRequestItemData:data];
            [array addObject:model];
        }
        aCompleteBlock(datumItem.total.intValue, array, nil);
    }];
    
}

- (void)stop {
    [self.request stopRequest];
}

- (void)saveToCache {
    // 只cache第一页结果
    NSString *cachedJson = [self.page0RetItem toJSONString];
    [[NSUserDefaults standardUserDefaults] setObject:cachedJson forKey:@"全部资源 first page cache"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)cachedItemArray {
    NSString *cachedJson = [[NSUserDefaults standardUserDefaults] objectForKey:@"全部资源 first page cache"];
    YXDatumSearchRequestItem *item = [[YXDatumSearchRequestItem alloc] initWithString:cachedJson error:nil];
    self.page0RetItem = item;
    if (!item) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (YXDatumSearchRequestItem_data *data in item.data) {
        YXDatumCellModel *model = [YXDatumCellModel modelFromSearchRequestItemData:data];
        [array addObject:model];
    }
    
    return [NSArray arrayWithArray:array];
}

@end
