//
//  YXRecordContent.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YXCourseDetailItem.h"

@protocol YXRecordContent_k
@end
@interface YXRecordContent_k : JSONModel
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSArray *pd;
@end

@interface YXRecordContent : JSONModel
@property (nonatomic, strong) NSString<Optional> *ac;
@property (nonatomic, strong) NSString<Optional> *tc;
@property (nonatomic, strong) NSString<Optional> *rc;
@property (nonatomic, strong) NSString<Optional> *t;
@property (nonatomic, strong) NSString<Optional> *c;
@property (nonatomic, strong) NSString<Optional> *p;
@property (nonatomic, strong) NSString<Optional> *i;
@property (nonatomic, strong) NSString<Optional> *md5;
@property (nonatomic, strong) NSString<Optional> *mxt;
@property (nonatomic, strong) NSArray<Optional, YXRecordContent_k> *k;

+ (YXRecordContent *)contentFromCourseDetailItem:(YXCourseDetailItem *)courseItem;

@end
