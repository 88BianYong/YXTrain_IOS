//
//  ActivityListFetcher.h
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface ActivityListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *studyid; //学科id
@property (nonatomic, strong) NSString *segid;   //学段id
@property (nonatomic, strong) NSString *stageid; //阶段id
@property (nonatomic, strong) NSString *pid;

@end
