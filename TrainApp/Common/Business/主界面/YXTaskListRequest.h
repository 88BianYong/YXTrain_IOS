//
//  YXTaskListRequest.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol YXTaskListRequestItem_body_task <NSObject>

@end
@interface YXTaskListRequestItem_body_task : JSONModel
@property (nonatomic, strong) NSString *toolid;
@property (nonatomic, strong) NSString *name;
@end

@interface YXTaskListRequestItem_body : JSONModel
@property (nonatomic, strong) NSString<Optional> *w;
@property (nonatomic, strong) NSArray<YXTaskListRequestItem_body_task,Optional> *tasks;
@end

@interface YXTaskListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXTaskListRequestItem_body<Optional> *body;
@end

@interface YXTaskListRequest : YXGetRequest
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *w;
@end
