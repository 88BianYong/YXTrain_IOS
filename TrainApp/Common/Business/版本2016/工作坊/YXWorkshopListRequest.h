//
//  YXWorkshopListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
@interface YXWorkshopListRequestItem_group : JSONModel
@property (nonatomic, copy) NSString<Optional> *barid;
@property (nonatomic, copy) NSString<Optional> *gname;
@property (nonatomic, copy) NSString<Optional> *head;
@property (nonatomic, copy) NSString<Optional> *barDesc;
@end

@protocol YXWorkshopListRequestItem_group
@end

@interface YXWorkshopListRequestItem :HttpBaseRequestItem
@property (nonatomic, copy) NSArray<YXWorkshopListRequestItem_group, Optional> *group;
@end

#import "YXGetRequest.h"
@interface YXWorkshopListRequest : YXGetRequest

@end
