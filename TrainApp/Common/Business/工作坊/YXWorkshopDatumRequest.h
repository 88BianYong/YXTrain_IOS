//
//  YXWorkshopDatumRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface YXWorkshopDatumRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *pagesize;
@property (nonatomic, strong) NSString<Optional> *pageindex;
@property (nonatomic, strong) NSString<Optional> *condition;
@property (nonatomic, strong) NSString<Ignore> *barid;
@end
