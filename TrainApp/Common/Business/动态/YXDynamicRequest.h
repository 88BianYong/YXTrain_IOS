//
//  YXDynamicRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol YXDynamicRequestItem_Data
@end
@interface YXDynamicRequestItem_Data:JSONModel
@property (nonatomic, copy) NSString<Optional> *msgId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *type;//1-通知  2-简报  3-打分  4-推优  5-任务到期提醒
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *projectName;
@property (nonatomic, copy) NSString<Optional> *receiverUid;
@property (nonatomic, copy) NSString<Optional> *linkUrl;//0-未读  1已读
@property (nonatomic, copy) NSString<Optional> *publishTime;
@property (nonatomic, copy) NSString<Optional> *timer;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *objectId;
@end

@interface YXDynamicRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) NSString<Optional> *total;
@property (nonatomic ,strong)NSMutableArray <YXDynamicRequestItem_Data, Optional>*body;
@end

@interface YXDynamicRequest : YXGetRequest
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@end
