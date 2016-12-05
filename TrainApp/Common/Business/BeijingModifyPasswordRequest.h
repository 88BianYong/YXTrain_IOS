//
//  BeijingModifyPasswordRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface BeijingModifyPasswordRequestItem : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, copy) NSString<Optional> *status;
@end

@interface BeijingModifyPasswordRequest : YXGetRequest
@property (nonatomic, copy) NSString *truename;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *verifycode;
@end
