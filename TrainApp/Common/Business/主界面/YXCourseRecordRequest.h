//
//  YXCourseRecordRequest.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol YXCourseRecordRequestItem_body_module_course <NSObject>
@end
@interface YXCourseRecordRequestItem_body_module_course : JSONModel
@property (nonatomic, copy) NSString<Optional> *courses_id;
@property (nonatomic, copy) NSString<Optional> *course_title;
@property (nonatomic, copy) NSString<Optional> *course_img;
@property (nonatomic, copy) NSString<Optional> *record;
@property (nonatomic, copy) NSString<Optional> *is_selected; //1走以前老的详情接口，0走新的详情接口

@property (nonatomic, strong) NSString<Optional> *module_id; //用于传参stageid
@end

@protocol YXCourseRecordRequestItem_body_module <NSObject>
@end
@interface YXCourseRecordRequestItem_body_module : JSONModel
@property (nonatomic, copy) NSString<Optional> *module_id;
@property (nonatomic, copy) NSString<Optional> *module_name;
@property (nonatomic, copy) NSString<Optional> *more;
@property (nonatomic, strong) NSMutableArray<YXCourseRecordRequestItem_body_module_course, Optional> *courses;
@end

@interface YXCourseRecordRequestItem_body : JSONModel
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSArray<YXCourseRecordRequestItem_body_module, Optional> *modules;
@end

@interface YXCourseRecordRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXCourseRecordRequestItem_body<Optional> *body;
@end

@interface YXCourseRecordRequest : YXGetRequest
@property (nonatomic, strong) NSString *w;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *pcode;
@end
