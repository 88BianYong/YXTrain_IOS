//
//  ExamineToolStatusRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface ExamineToolStatusRequest_17Item : HttpBaseRequestItem
@property (nonatomic, strong) NSMutableDictionary<Optional> *sts;
@property (nonatomic, strong) NSString<Optional> *time;
@end
@interface ExamineToolStatusRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectID;
@end
