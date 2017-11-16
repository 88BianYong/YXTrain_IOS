//
//  MasterRemindStudyRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface MasterRemindStudyRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *barId;//坊id，barId与userIds二选一
@property (nonatomic, copy) NSString<Optional> *userIds;//用户id集合，以逗号分隔，  1,3,4,5
@end
