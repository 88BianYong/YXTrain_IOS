//
//  BeijingCourseListFetcher.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "BeijingCourseListRequest.h"
@interface BeijingCourseListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *studyid; //学科id
@property (nonatomic, strong) NSString *segid;   //学段id
@property (nonatomic, strong) NSString *stageid; //阶段id
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *urlHead;
@property (nonatomic, strong) NSString *w;

@property (nonatomic, copy) void(^filterBlock)(YXCourseListFilterModel *model);
@end
