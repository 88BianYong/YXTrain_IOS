//
//  YXCourseDetailRequest.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXCourseDetailItem.h"

@interface YXCourseDetailRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXCourseDetailItem<Optional> *body;
@end

@interface YXCourseDetailRequest : YXGetRequest
@property (nonatomic, strong) NSString *stageid;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *courseType;
@property (nonatomic, strong) NSString<Optional> *w;

@end
