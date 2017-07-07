//
//  YXUpdateProfileHelper.h
//  TrainApp
//
//  Created by 郑小龙 on 16/7/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXUserProfile.h"

typedef NS_ENUM(NSInteger, YXUpdateProfileType) {
    YXUpdateProfileTypeRealname, //姓名
    YXUpdateProfileTypeNickname, //昵称
    YXUpdateProfileTypeStage,    //学段学科
    YXUpdateProfileTypeArea,     //地区（省市区县）
    YXUpdateProfileTypeSchool,   //学校（Id或名称）
    
    YXUpdateProfileTypeAll
};

extern NSString *const YXUpdateProfileSuccessNotification;
extern NSString *const YXUpdateProfileTypeKey; // 值为NSNumber对象ern NSString *const YXUserProfileGetSuccessNotification;

@interface YXUpdateProfileItem : HttpBaseRequestItem

@property (nonatomic, strong) YXUserProfile<Optional> *editUserInfo;

@end

@interface YXUpdateProfileRequest : YXGetRequest

@property (nonatomic, strong) NSString *realName;   //真实姓名
@property (nonatomic, strong) NSString *nickName;   //昵称
@property (nonatomic, strong) NSString *stageId;    //学段id
@property (nonatomic, strong) NSString *subjectId;  //学科id
@property (nonatomic, strong) NSString *areaId;     //地区id
@property (nonatomic, strong) NSString *schoolName; //学校名
@property (nonatomic, strong) NSString<Optional> *schoolId; //学校id（学校ID或Name至少填写一个）

@end

@interface YXUpdateProfileHelper : NSObject

- (void)requestWithType:(YXUpdateProfileType)type
                  param:(NSDictionary *)param
             completion:(void(^)(NSError *error))completion;

- (void)stopRequest;

@end
