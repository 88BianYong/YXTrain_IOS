//
//  YXDynamicRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol YXDynamicRequestItem_Data
@end
@interface YXDynamicRequestItem_Data:JSONModel
@end

@interface YXDynamicRequestItem: HttpBaseRequest
@property (nonatomic, strong) NSString<Optional> *total;
@property (nonatomic ,strong)NSArray <YXDynamicRequestItem_Data, Optional>*data;
@end

@interface YXDynamicRequest : YXGetRequest
@property (nonatomic, copy) NSString *pageindex;
@property (nonatomic, copy) NSString *pagesize;
@end
