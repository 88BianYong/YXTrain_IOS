//
//  YXDatumGlobalSingleton.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/6.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXDatumGlobalSingleton.h"
#import "YXDatumFilterRequest.h"
#import "YXUserManager.h"
#import "YXUserProfile.h"

@interface YXDatumGlobalSingleton ()

@property (nonatomic, strong) YXDatumFilterRequest *request;

@end

@implementation YXDatumGlobalSingleton
- (instancetype)init {
    if (self = [super init]) {
        self.myOffset = @"0";
        self.slOffset = @"0";
    }
    return self;
}

// 获取资源筛选目录
- (void)getDatumFilterData:(void(^)(NSError *))completion
{
    [self.request stopRequest];
    self.request = [[YXDatumFilterRequest alloc]init];
    self.request.stage = [LSTSharedInstance sharedInstance].userManger.userModel.profile.stageId;
    @weakify(self);
    [self.request startRequestWithRetClass:[YXDatumFilterRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self);
        if (!self) {
            return;
        }
        if (!retItem || error) {
            self.filterModel = [YXFilterModel modelFromFilterRequestItem:nil];
            if (completion) {
                completion(error);
            }
            return;
        }
        YXDatumFilterRequestItem *item = retItem;
        self.filterModel = [YXFilterModel modelFromFilterRequestItem:item];
        if (completion) {
            completion(nil);
        }
    }];
}

@end
