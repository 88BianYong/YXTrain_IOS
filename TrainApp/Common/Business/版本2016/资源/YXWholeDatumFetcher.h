//
//  YXWholeDatumFetcher.h
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "YXDatumSearchRequest.h"

@interface YXWholeDatumFetcher : PagedListFetcherBase
@property (nonatomic, copy) NSString *condition;

@property (nonatomic, strong) YXDatumSearchRequestItem *page0RetItem;
@end
