//
//  ShareResourcesFetcher.h
//  TrainApp
//
//  Created by ZLL on 2016/11/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
@class ShareResourcesRequestItem;
@interface ShareResourcesFetcher : PagedListFetcherBase
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *toolId;
@property (nonatomic, copy) NSString *w;
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, strong) ShareResourcesRequestItem *page0RetItem;

@end
