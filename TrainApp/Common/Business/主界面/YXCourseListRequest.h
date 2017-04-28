//
//  YXCourseListRequest.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXCourseListFilterModel.h"

@protocol YXCourseListRequestItem_body_stage <NSObject>
@end

@interface YXCourseListRequestItem_body_module_course_quiz : JSONModel
@property (nonatomic, copy) NSString<Optional> *finish;
@property (nonatomic, copy) NSString<Optional> *total;
@end


@interface YXCourseListRequestItem_body_stage_quiz : JSONModel
@property (nonatomic, copy) NSString<Optional> *finish;
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, copy) NSString<Ignore> *stageID;
@property (nonatomic, copy) NSString<Ignore> *isSelected;
@end
@interface YXCourseListRequestItem_body_stage : JSONModel
@property (nonatomic, strong) NSString<Optional> *stageID;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) YXCourseListRequestItem_body_stage_quiz<Optional> *quiz;//德阳项目专用
@end

@protocol YXCourseListRequestItem_body_study <NSObject>
@end
@interface YXCourseListRequestItem_body_study : JSONModel
@property (nonatomic, strong) NSString<Optional> *studyID;
@property (nonatomic, strong) NSString<Optional> *name;
@end

@protocol YXCourseListRequestItem_body_type <NSObject>
@end
@interface YXCourseListRequestItem_body_type : JSONModel
@property (nonatomic, strong) NSString<Optional> *typeID;
@property (nonatomic, strong) NSString<Optional> *name;
@end



@protocol YXCourseListRequestItem_body_segment <NSObject>
@end
@interface YXCourseListRequestItem_body_segment : JSONModel
@property (nonatomic, strong) NSString<Optional> *segmentID;
@property (nonatomic, strong) NSString<Optional> *name;
@end

@protocol YXCourseListRequestItem_body_module_course <NSObject>
@end
@interface YXCourseListRequestItem_body_module_course : JSONModel
@property (nonatomic, strong) NSString<Optional> *courses_id;
@property (nonatomic, strong) NSString<Optional> *course_title;
@property (nonatomic, strong) NSString<Optional> *course_img;
@property (nonatomic, strong) NSString<Optional> *record;
@property (nonatomic, strong) NSString<Optional> *is_selected;
@property (nonatomic, strong) NSString<Optional> *module_id;
@property (nonatomic, strong) NSString<Optional> *credit;//北京项目专用
@property (nonatomic, strong) NSString<Optional> *isSupportApp;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) YXCourseListRequestItem_body_module_course_quiz<Optional> *quiz;//德阳项目专用
@end

@protocol YXCourseListRequestItem_body_module <NSObject>
@end
@interface YXCourseListRequestItem_body_module : JSONModel
@property (nonatomic, strong) NSString<Optional> *module_id;
@property (nonatomic, strong) NSString<Optional> *module_name;
@property (nonatomic, strong) NSString<Optional> *more;
@property (nonatomic, strong) NSArray<YXCourseListRequestItem_body_module_course,Optional> *courses;
@end

@interface YXCourseListRequestItem_body : JSONModel
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *coursecount;
@property (nonatomic, strong) NSString<Optional> *total;
@property (nonatomic, strong) NSString<Optional> *progress;
@property (nonatomic, strong) NSArray<YXCourseListRequestItem_body_module,Optional> *modules;
@property (nonatomic, strong) NSArray<YXCourseListRequestItem_body_segment,Optional> *segments;
@property (nonatomic, strong) NSArray<YXCourseListRequestItem_body_stage,Optional> *stages;
@property (nonatomic, strong) NSArray<YXCourseListRequestItem_body_study,Optional> *studys;
@property (nonatomic, strong) NSArray<YXCourseListRequestItem_body_type,Optional> *types;
@end

@interface YXCourseListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXCourseListRequestItem_body<Optional> *body;

- (NSArray *)allCourses; // element is YXCourseListRequestItem_body_module_course type
- (YXCourseListFilterModel *)filterModel;
- (YXCourseListFilterModel *)beijingFilterModel;
- (YXCourseListFilterModel *)deyangFilterModel ;
- (NSArray<__kindof YXCourseListRequestItem_body_stage_quiz *> *)deyangFilterStagesQuiz;
@end

@interface YXCourseListRequest : YXGetRequest
@property (nonatomic, strong) NSString *stageid;
@property (nonatomic, strong) NSString *studyid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *segid;
@property (nonatomic, strong) NSString *pagesize;
@property (nonatomic, strong) NSString *pageindex;
@property (nonatomic, strong) NSString *w;
@end



