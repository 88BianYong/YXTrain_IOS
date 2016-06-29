//
//  YXModuleDetailRequest.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXCourseDetailItem.h"

@interface YXModuleDetailRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXCourseDetailItem<Optional> *body;
@end

@interface YXModuleDetailRequest : YXGetRequest
@property (nonatomic, strong) NSString *w;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *pcode;
@end
