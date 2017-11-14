//
//  YXNoticeListFetch.h
//  TrainApp
//
//  Created by 李五民 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "YXNoticeListRequest.h"

@interface YXNoticeListFetch : PagedListFetcherBase

@property (nonatomic, strong) YXNoticeListRequestItem *noticeListRequestItem;

@end
