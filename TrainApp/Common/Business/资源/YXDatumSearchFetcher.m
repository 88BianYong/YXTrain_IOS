//
//  YXDatumSearchFetcher.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXDatumSearchFetcher.h"
#import "YXDatumSearchRequest.h"
#import "YXDatumCellModel.h"

@interface YXDatumSearchFetcher()
@property (nonatomic, strong) YXDatumSearchRequest *request;
@end

@implementation YXDatumSearchFetcher

- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    [self stop];
    self.request = [[YXDatumSearchRequest alloc] init];
    self.request.condition = self.condition;
    self.request.keyWord = self.keyWord;
    self.request.pageindex = [NSString stringWithFormat:@"%d", self.pageindex + 1];
    self.request.pagesize = [NSString stringWithFormat:@"%d", self.pagesize];
    
    [self.request startRequestWithRetClass:[YXDatumSearchRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
            aCompleteBlock(0, nil, error);
            return;
        }
        
        YXDatumSearchRequestItem *item = retItem;
        NSMutableArray *array = [NSMutableArray array];
        for (YXDatumSearchRequestItem_data *data in item.data) {
            YXDatumCellModel *model = [YXDatumCellModel modelFromSearchRequestItemData:data];
            [array addObject:model];
        }
        aCompleteBlock(item.total.intValue, array, nil);
    }];
    
}

- (void)stop {
    [self.request stopRequest];
}

@end
