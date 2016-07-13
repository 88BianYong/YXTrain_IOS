//
//  YXModuleListRequest.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXCourseRecordRequest.h"

@interface YXModuleListRequestItem_body : JSONModel
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, copy) NSArray<YXCourseRecordRequestItem_body_module_course, Optional> *courses;
@end

@interface YXModuleListRequestItem : HttpBaseRequestItem
@property (nonatomic, copy) YXModuleListRequestItem_body<Optional> *body;
@end

@interface YXModuleListRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *pid;
@property (nonatomic, strong) NSString<Optional> *mid;
@property (nonatomic, strong) NSString<Optional> *w;
@end
