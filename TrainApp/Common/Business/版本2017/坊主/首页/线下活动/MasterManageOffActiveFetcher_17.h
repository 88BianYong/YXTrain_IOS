//
//  MasterManageOffActiveFetcher_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "MasterManagerSchemeItem.h"
#import "LSTCollectionFilterDefaultProtocol.h"
@interface MasterManageOffActiveFetcher_17 : PagedListFetcherBase
@property (nonatomic, copy) void(^masterManageOffActiveBlock)(MasterManagerSchemeItem * scheme);
@end
