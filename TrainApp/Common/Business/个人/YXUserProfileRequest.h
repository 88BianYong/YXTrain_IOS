//
//  YXUserProfileRequest.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/5.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//
#import "YXGetRequest.h"
#import "YXUserProfile.h"

typedef NS_ENUM(NSInteger, YXPickerType) {
    YXPickerTypeDefault,
    YXPickerTypeStageAndSubject,
    YXPickerTypeProvince
};

extern NSString *const YXUserProfileGetSuccessNotification;

@interface YXUserProfileItem : HttpBaseRequestItem

@property (nonatomic, strong) YXUserProfile<Optional> *editUserInfo;

@end

// 用户信息
@interface YXUserProfileRequest : YXGetRequest

@property (nonatomic, strong) NSString *targetuid;

@end
