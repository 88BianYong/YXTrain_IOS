//
//  BeijingCheckedMobileUserRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface BeijingCheckedMobileUserRequestItem : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *isUpdatePwd;
@property (nonatomic, copy) NSString<Optional> *passport;
@property (nonatomic, copy) NSString<Optional> *isTest;
@end

@interface BeijingCheckedMobileUserRequest : YXGetRequest
@property (nonatomic, copy) NSString *pid;
@end
