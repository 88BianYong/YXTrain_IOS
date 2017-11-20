//
//  MasterManageBriefFetcher_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "MasterNoticeBriefScheme.h"
@interface MasterManageBriefFetcher_17 : PagedListFetcherBase
@property (nonatomic, strong) void(^masterBriefSchemeBlock)(MasterNoticeBriefScheme *scheme);
@end
