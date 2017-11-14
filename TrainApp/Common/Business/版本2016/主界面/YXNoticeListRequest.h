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
@property (nonatomic, copy) NSString<Optional> *nbID;
@property (nonatomic, copy) NSString<Optional> *itemId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *userId;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *createDate;
@property (nonatomic, copy) NSString<Optional> *url;
@property (nonatomic, copy) NSString<Optional> *isExtendUrl;

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
