//
//  YXUserProfileRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/5.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXUserProfileRequest.h"
#import "YXUserManager.h"

NSString *const YXUserProfileGetSuccessNotification = @"kYXUserProfileGetSuccessNotification";

@implementation YXUserProfileItem

@end

@implementation YXUserProfileRequest

- (instancetype)init
{
    if (self = [super init]) {
//        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"psprofile"];
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"psprofile/getEditUserInfo"];
    }
    return self;
}

@end

@interface YXUserProfileHelper ()

@property (nonatomic, strong) YXUserProfileRequest *request;

@end

@implementation YXUserProfileHelper

- (void)dealloc
{
    [self.request stopRequest];
}

+ (instancetype)sharedHelper
{
    static YXUserProfileHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

- (void)requestCompeletion:(void(^)(NSError *error))completion
{
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXUserProfileRequest alloc] init];
    self.request.targetuid = [YXUserManager sharedManager].userModel.uid;
    [self.request startRequestWithRetClass:[YXUserProfileItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            YXUserProfileItem *item = retItem;
            if (item) {
                [YXUserManager sharedManager].userModel.profile = item.editUserInfo;
                [[YXUserManager sharedManager] saveUserData];
                [[NSNotificationCenter defaultCenter] postNotificationName:YXUserProfileGetSuccessNotification object:nil];
            }
            if (completion) {
                completion(error);
            }
        });
    }];
}

@end