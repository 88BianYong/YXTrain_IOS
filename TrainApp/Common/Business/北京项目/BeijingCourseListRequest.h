//
//  BeijingCourseListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXCourseListRequest.h"
@interface BeijingCourseListRequest : YXGetRequest
@property (nonatomic, strong) NSString *stageid;
@property (nonatomic, strong) NSString *studyid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *segid;
@property (nonatomic, strong) NSString *pagesize;
@property (nonatomic, strong) NSString *pageno;
@property (nonatomic, strong) NSString *w;
@end
