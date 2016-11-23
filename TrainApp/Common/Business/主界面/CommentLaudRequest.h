//
//  CommentLaudRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface CommentLaudRequest : YXGetRequest
@property (nonatomic, copy) NSString *replyid;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *toolid;
@property (nonatomic, copy) NSString *topicid;
@property (nonatomic, copy) NSString *w;
@end
