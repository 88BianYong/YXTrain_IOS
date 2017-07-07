//
//  YXUpdateProfileRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXUpdateProfileRequest.h"
NSString *const YXUpdateProfileSuccessNotification = @"kYXUpdateProfileSuccessNotification";
NSString *const YXUpdateProfileTypeKey = @"kYXUpdateProfileTypeKey";

@implementation YXUpdateProfileItem

@end
@implementation YXUpdateProfileRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"psprofile/update"];
    }
    return self;
}
@end
@interface YXUpdateProfileHelper ()

@property (nonatomic, strong) YXUpdateProfileRequest *request;

@end
@implementation YXUpdateProfileHelper
- (void)requestWithType:(YXUpdateProfileType)type
                  param:(NSDictionary *)param
             completion:(void (^)(NSError *))completion
{
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXUpdateProfileRequest alloc] init];
    NSMutableDictionary *allParam = [self defaultParamters];
    [allParam addEntriesFromDictionary:param];
    [self setRequestWithParam:allParam];
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXUpdateProfileItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (retItem && !error) {
            [self saveDataWithParam:param type:type];
        }
        if (completion) {
            completion(error);
        }
    }];
}

- (void)stopRequest
{
    [self.request stopRequest];
}

#pragma mark -

- (NSMutableDictionary *)defaultParamters
{
    YXUserProfile *profile = [YXUserManager sharedManager].userModel.profile;
    NSDictionary *dictionary = @{@"realName": profile.realName?:@"",
                                 @"nickName": profile.nickName?:@"",
                                 @"stageId": profile.stageId?:@"",
                                 @"subjectId": profile.subjectId?:@"",
                                 @"areaId": profile.regionId?:@"",
                                 @"schoolId": profile.schoolId?:@"",
                                 @"schoolName": profile.school?:@""};
    NSMutableDictionary *defaultParamters = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    return defaultParamters;
}

- (void)setRequestWithParam:(NSDictionary *)param
{
    self.request.realName = [param objectForKey:@"realName"];
    self.request.nickName = [param objectForKey:@"nickName"];
    self.request.stageId = [param objectForKey:@"stageId"];
    self.request.subjectId = [param objectForKey:@"subjectId"];
    self.request.areaId = [param objectForKey:@"areaId"];
    self.request.schoolId = [param objectForKey:@"schoolId"];
    self.request.schoolName = [param objectForKey:@"schoolName"];
}

- (void)saveDataWithParam:(NSDictionary *)param type:(YXUpdateProfileType)type
{
    YXUserProfile *profile = [YXUserManager sharedManager].userModel.profile;
    switch (type) {
        case YXUpdateProfileTypeRealname:
            profile.realName = [param objectForKey:@"realName"];
            break;
        case YXUpdateProfileTypeNickname:
            profile.nickName = [param objectForKey:@"nickName"];
            break;
        case YXUpdateProfileTypeStage:
            profile.stageId = [param objectForKey:@"stageId"];
            profile.subjectId = [param objectForKey:@"subjectId"];
            
            profile.stage = [param objectForKey:@"stage"];
            profile.subject = [param objectForKey:@"subject"];
            break;
        case YXUpdateProfileTypeArea:
            profile.regionId = [param objectForKey:@"areaId"];
            
            //            profile.provinceId = [param objectForKey:@"provinceId"];
            profile.province = [param objectForKey:@"province"];
            //            profile.cityId = [param objectForKey:@"cityId"];
            profile.city = [param objectForKey:@"city"];
            profile.region = [param objectForKey:@"region"];
            profile.area = [NSString stringWithFormat:@"%@%@%@", profile.province, profile.city, profile.region];
            break;
        case YXUpdateProfileTypeSchool:
            profile.schoolId = [param objectForKey:@"schoolId"];
            profile.school = [param objectForKey:@"schoolName"];
            break;
        default:
            break;
    }
    [YXUserManager sharedManager].userModel.profile = profile;
    [[YXUserManager sharedManager] saveUserData];
}

@end
