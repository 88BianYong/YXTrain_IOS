//
//  YXNoticeListRequest.h
//  TrainApp
//
//  Created by 李五民 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol YXNoticeAndBulletinItem <NSObject>

@end

@interface YXNoticeAndBulletinItem : JSONModel

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *url;

@end

@interface YXNoticeListRequestItem_body : JSONModel

@property (nonatomic ,strong) NSArray<YXNoticeAndBulletinItem,Optional> *notices;

@end

@interface YXNoticeListRequestItem : HttpBaseRequestItem

@property (nonatomic, strong)YXNoticeListRequestItem_body<Optional> *body;

@end

@interface YXNoticeListRequest : YXGetRequest

@property (nonatomic, strong) NSString *pid;

@end
