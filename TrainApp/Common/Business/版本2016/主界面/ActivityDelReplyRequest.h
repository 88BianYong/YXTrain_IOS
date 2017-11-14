//
//  ActivityDelReplyRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 17/1/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface ActivityDelReplyRequest : YXGetRequest
@property (nonatomic, copy) NSString *replyid;
@property (nonatomic, copy) NSString *toolid;
@property (nonatomic, copy) NSString *topicid;
@end
