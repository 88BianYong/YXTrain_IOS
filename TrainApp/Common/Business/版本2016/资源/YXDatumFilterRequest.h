//
//  YXDatumFilterRequest.h
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/6.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
@class YXDatumFilterRequestItem_data_cataele,YXDatumFilterRequestItem_data,YXDatumFilterRequestItem;
@protocol YXDatumFilterRequestItem_data_cataele <NSObject>
@end
@interface YXDatumFilterRequestItem_data_cataele : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *elementId;
@property (nonatomic, copy) NSString<Optional> *name;
@end

@protocol YXDatumFilterRequestItem_data <NSObject>
@end
@interface YXDatumFilterRequestItem_data : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *cataName;
@property (nonatomic, copy) NSString<Optional> *cataCodeName;
@property (nonatomic, strong) NSArray<YXDatumFilterRequestItem_data_cataele,Optional> *cataele;
@end
@protocol YXDatumFilterRequestItem <NSObject>
@end
@interface YXDatumFilterRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<YXDatumFilterRequestItem_data,Optional> *data;
@end


@interface YXDatumFilterRequest : YXGetRequest

@property (nonatomic, strong) NSString *pageindex;  // non sense
@property (nonatomic, strong) NSString *pagesize;   // non sense
@property (nonatomic, strong) NSString *stage;

@end
