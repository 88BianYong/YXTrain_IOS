//
//  DeYangCourseListFetcher.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "YXCourseListRequest.h"

@interface DeYangCourseListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *studyid; //学科id
@property (nonatomic, strong) NSString *segid;   //学段id
@property (nonatomic, strong) NSString *type;    //类型id
@property (nonatomic, strong) NSString *stageid; //阶段id
@property (nonatomic, strong) NSString *pid;

@property (nonatomic, strong) void(^filterBlock)(YXCourseListFilterModel *model);
@property (nonatomic, strong) void(^filterQuizBlock)(NSArray<__kindof YXCourseListRequestItem_body_stage_quiz *> *model);

@end
