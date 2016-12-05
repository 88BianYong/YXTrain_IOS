//
//  BeijingSendSmsRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface BeijingSendSmsRequestItem : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *ret;
@property (nonatomic, copy) NSString<Optional> *msg;
@end
@interface BeijingSendSmsRequest : YXGetRequest
@property (nonatomic, copy) NSString *mobile;
@end
