//
//  CourseCenterListRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "CourseListRequest_17.h"
@interface CourseCenterListRequest_17Item_Summary : JSONModel
@property (nonatomic, copy) NSString<Optional> *courseNum;
@property (nonatomic, copy) NSString<Optional> *studyNum;
@property (nonatomic, copy) NSString<Optional> *finishNum;
@property (nonatomic, copy) NSString<Optional> *courseTime;
@property (nonatomic, copy) NSString<Optional> *type;
@end

@interface CourseCenterListRequest_17Item : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<CourseListRequest_17Item_Objs,Optional> *courses;
@property (nonatomic, strong) CourseCenterListRequest_17Item_Summary<Optional> *summary;
@property (nonatomic, copy) NSString<Optional> *count;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *totalPage;
@property (nonatomic, copy) NSString<Optional> *stageStatus;
@end



@interface CourseCenterListRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectID;
@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, copy) NSString<Optional> *study;//学科id，默认值0
@property (nonatomic, copy) NSString<Optional> *segment;//学段id，默认值0
@property (nonatomic, copy) NSString<Optional> *status;//0:全部， 1：已选， 2：未选
@property (nonatomic, copy) NSString<Optional> *tab;//my:我的， all: 全部
@property (nonatomic, copy) NSString<Optional> *page;//页数
@property (nonatomic, copy) NSString<Optional> *limit;//每页数量
@property (nonatomic, copy) NSString<Optional> *themeid;
@property (nonatomic, copy) NSString<Optional> *layerid;
@end
