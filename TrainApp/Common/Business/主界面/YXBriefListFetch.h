//
//  YXBriefListFetch.h
//  TrainApp
//
//  Created by 李五民 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "YXBriefListRequest.h"

@interface YXBriefListFetch : PagedListFetcherBase

@property (nonatomic, strong) YXBriefListRequestItem *noticeListRequestItem;

@end
