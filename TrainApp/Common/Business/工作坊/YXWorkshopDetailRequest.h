//
//  YXWorkshopDetailRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface YXWorkshopDetailRequestItem:HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *gname;
@property (nonatomic, copy) NSString<Optional> *master;
@property (nonatomic, copy) NSString<Optional> *subject;
@property (nonatomic, copy) NSString<Optional> *stage;
@property (nonatomic, copy) NSString<Optional> *grade;
@property (nonatomic, copy) NSString<Optional> *barDesc;
@property (nonatomic, copy) NSString<Optional> *memberNum;
@property (nonatomic, copy) NSString<Optional> *resNum;
@end

@interface YXWorkshopDetailRequest : YXGetRequest
@property (nonatomic, strong) NSString *barid;
@end
