//
//  YXHotspotRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol YXHotspotRequestItem_Data
@end
@interface YXHotspotRequestItem_Data:JSONModel
@end


@interface YXHotspotRequestItem:HttpBaseRequest
@property (nonatomic, strong) NSString<Optional> *total;
@property (nonatomic ,strong)NSArray <YXHotspotRequestItem_Data, Optional>*data;

@end

@interface YXHotspotRequest : YXGetRequest
@property (nonatomic, copy) NSString *pageindex;
@property (nonatomic, copy) NSString *pagesize;
@end
