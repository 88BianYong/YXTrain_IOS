//
//  BeijingModifyPasswordRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface BeijingModifyPasswordRequest : YXGetRequest
@property (nonatomic, strong) NSString *truename;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *mobile;
@end
