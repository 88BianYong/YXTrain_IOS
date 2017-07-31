//
//  ActivityListFetcher.h
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "ActivityListRequest.h"
@interface ActivityListFetcher : PagedListFetcherBase
@property (nonatomic, copy) NSString *studyid; //学科id
@property (nonatomic, copy) NSString *segid;   //学段id
@property (nonatomic, copy) NSString *stageid; //阶段id
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) void(^listCompleteBlock)(ActivityListRequestItem_body_scheme *scheme);
@end
