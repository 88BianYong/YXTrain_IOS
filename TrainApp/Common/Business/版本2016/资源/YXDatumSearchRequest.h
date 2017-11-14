//
//  YXDatumSearchRequest.h
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@protocol YXDatumSearchRequestItem_data <NSObject>
@end
@interface YXDatumSearchRequestItem_data : JSONModel
@property (nonatomic, copy) NSString<Optional> *BaseBeanCreateTime;
@property (nonatomic, copy) NSString<Optional> *datumId;
@property (nonatomic, copy) NSString<Optional> *filename;
@property (nonatomic, copy) NSString<Optional> *filetype;
@property (nonatomic, copy) NSString<Optional> *filesize;
@property (nonatomic, copy) NSString<Optional> *time;
@property (nonatomic, copy) NSString<Optional> *uid;
@property (nonatomic, copy) NSString<Optional> *uname;
@property (nonatomic, copy) NSString<Optional> *pointstr;
@property (nonatomic, copy) NSString<Optional> *downnum;
@property (nonatomic, copy) NSString<Optional> *area;
@property (nonatomic, copy) NSString<Optional> *readnum;
@property (nonatomic, copy) NSString<Optional> *makercount;
@property (nonatomic, copy) NSString<Optional> *sharetype;
@property (nonatomic, copy) NSString<Optional> *point;
@property (nonatomic, copy) NSString<Optional> *reviewCnt;
@property (nonatomic, copy) NSString<Optional> *shareCnt;
@property (nonatomic, copy) NSString<Optional> *typeId;
@property (nonatomic, copy) NSString<Optional> *url;
@property (nonatomic, copy) NSString<Optional> *isCollection;
@property (nonatomic, copy) NSString<Optional> *is_translated;
@property (nonatomic, copy) NSString<Optional> *pointCount;
@end

@interface YXDatumSearchRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<YXDatumSearchRequestItem_data,Optional> *data;
@property (nonatomic, copy) NSString<Optional> *total;
@end

@interface YXDatumSearchRequest : YXGetRequest
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *pageindex;
@property (nonatomic, copy) NSString *pagesize;
@property (nonatomic, copy) NSString *condition;
@end


