//
//  YXCourseListFetcher.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "YXCourseListRequest.h"

@interface YXCourseListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *studyid; //学科id
@property (nonatomic, strong) NSString *segid;   //学段id
@property (nonatomic, strong) NSString *type;    //类型id
@property (nonatomic, strong) NSString *stageid; //阶段id
@property (nonatomic, strong) NSString *pid;

@property (nonatomic, strong) void(^filterBlock)(YXCourseListFilterModel *model);
@end
