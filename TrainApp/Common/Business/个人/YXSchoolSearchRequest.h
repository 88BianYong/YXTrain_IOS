//
//  YXSchoolSearchRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/7/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface YXSchool : JSONModel

@property (nonatomic, copy) NSString<Optional> *areaId;
@property (nonatomic, copy) NSString<Optional> *cityId;
@property (nonatomic, copy) NSString<Optional> *sid;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *provinceId;

@end

@protocol YXSchool
@end
@interface YXSchoolSearchItem : HttpBaseRequestItem
@property (nonatomic, copy) NSArray<YXSchool, Optional> *schools;

@end
@interface YXSchoolSearchRequest : YXGetRequest
@property (nonatomic, strong) NSString *schoolName;
@property (nonatomic, strong) NSString<Optional> *areaId;
@end
