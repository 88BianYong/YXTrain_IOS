//
//  ShareResourcesFetcher.m
//  TrainApp
//
//  Created by ZLL on 2016/11/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ShareResourcesFetcher.h"
#import "YXDatumCellModel.h"
#import "ShareResourcesRequest.h"
@interface ShareResourcesFetcher ()
@property (nonatomic, strong) ShareResourcesRequest *request;
@end
@implementation ShareResourcesFetcher
- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[ShareResourcesRequest alloc] init];
    self.request.aid = self.aid;
    self.request.toolId = self.toolId;
    self.request.page = [NSString stringWithFormat:@"%d", self.pageindex + 1];
    self.request.pageSize = [NSString stringWithFormat:@"%d", self.pagesize];
    self.request.w = [YXTrainManager sharedInstance].trainHelper.w;
    WEAK_SELF
    [self.request startRequestWithRetClass:[ShareResourcesRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            aCompleteBlock(0, nil, error);
            return;
        }
        if (self.pageindex == 0) {
            self.page0RetItem = retItem;
            [self saveToCache];
        }
        ShareResourcesRequestItem *datumItem = retItem;
        NSMutableArray *array = [NSMutableArray array];
        for (ShareResourcesRequestItem_body_resource *resource in datumItem.body.resources) {
            YXDatumCellModel *model = [YXDatumCellModel modelFromShareResourceRequestItemBodyResource:resource];
            [array addObject:model];
        }
         BOOL isLastPage = [self.request.page isEqualToString:datumItem.body.totalPage];
         if (isLastPage) {
         BLOCK_EXEC(aCompleteBlock,0,array,nil);
         }else {
         BLOCK_EXEC(aCompleteBlock,(int)NSIntegerMax,array,nil);
         }
    }];
}
- (void)saveToCache {
    NSString *cachedJson = [self.page0RetItem toJSONString];
    NSString *cashedSign = [NSString stringWithFormat:@"%@%@",self.request.aid,self.request.toolId];
    NSDictionary *dict = @{cashedSign:cachedJson};
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"资源分享 first page cache"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)cachedItemArray {
    NSString *cashedSign = [NSString stringWithFormat:@"%@%@",self.aid,self.toolId];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"资源分享 first page cache"];
    NSString *cachedJson = dict[cashedSign];
        ShareResourcesRequestItem *item = [[ShareResourcesRequestItem alloc] initWithString:cachedJson error:nil];
    self.page0RetItem = item;
    if (!item) {
        return nil;
    }
     NSMutableArray *array = [NSMutableArray array];
    for (ShareResourcesRequestItem_body_resource *resource in item.body.resources) {
        YXDatumCellModel *model = [YXDatumCellModel modelFromShareResourceRequestItemBodyResource:resource];
        [array addObject:model];
    }
    return [NSArray arrayWithArray:array];
}

@end
