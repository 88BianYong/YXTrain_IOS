//
//  YXDatumSearchFetcher.h
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface YXDatumSearchFetcher : PagedListFetcherBase
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *condition;
@end
