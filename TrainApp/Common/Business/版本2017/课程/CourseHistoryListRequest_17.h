//
//  CourseHistoryListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface CourseHistoryListRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectID;
@property (nonatomic, copy) NSString<Optional> *thame;//主题 id，有主题时必填，默认为0
@property (nonatomic, copy) NSString<Optional> *page;//页数
@property (nonatomic, copy) NSString<Optional> *limit;//每页数量
@end
