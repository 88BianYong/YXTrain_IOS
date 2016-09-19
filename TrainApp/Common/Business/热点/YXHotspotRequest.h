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
@property (nonatomic, copy) NSString<Optional> *hotspotId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *picUrl;
@property (nonatomic, copy) NSString<Optional> *linkUrl;
@property (nonatomic, copy) NSString<Optional> *status;//0-未读  1已读
@property (nonatomic, copy) NSString<Optional> *publishTime;
@property (nonatomic, copy) NSString<Optional> *timer;
@end

@interface YXHotspotRequestItem:HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic ,strong)NSMutableArray <YXHotspotRequestItem_Data, Optional>*body;

@end

@interface YXHotspotRequest : YXGetRequest
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@end
