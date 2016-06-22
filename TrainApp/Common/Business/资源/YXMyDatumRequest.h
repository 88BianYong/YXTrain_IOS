//
//  YXMyDatumRequest.h
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@protocol YXMyDatumRequestItem_result_list <NSObject>
@end
@interface YXMyDatumRequestItem_result_list : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *BaseBeanCreateTime;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *group;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *aid;
@property (nonatomic, copy) NSString<Optional> *pubTime;
@property (nonatomic, copy) NSString<Optional> *uid;
@property (nonatomic, copy) NSString<Optional> *linkUrl;
@property (nonatomic, copy) NSString<Optional> *previewUrl;
@property (nonatomic, copy) NSString<Optional> *isCollection;
@property (nonatomic, copy) NSString<Optional> *canshare;
@property (nonatomic, copy) NSString<Optional> *thumbnail;
@property (nonatomic, copy) NSString<Optional> *fileSize;
@end

@interface YXMyDatumRequestItem_result : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *BaseBeanCreateTime;
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, strong) NSArray<YXMyDatumRequestItem_result_list,Optional> *list;
@end

@interface YXMyDatumRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXMyDatumRequestItem_result<Optional> *result;
@property (nonatomic, copy) NSString<Optional> *myOffset;
@property (nonatomic, copy) NSString<Optional> *slOffset;
@end

@interface YXMyDatumRequest : YXGetRequest
@property (nonatomic, copy) NSString *pageindex;
@property (nonatomic, copy) NSString *pagesize;
@property (nonatomic, copy) NSString *order;

@property (nonatomic, copy) NSString *myOffset;
@property (nonatomic, copy) NSString *slOffset;
@end


