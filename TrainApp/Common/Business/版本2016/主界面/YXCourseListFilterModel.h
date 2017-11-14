//
//  YXCourseListFilterModel.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YXCourseListRequestItem;
@class YXCourseListRequestItem_body_stage_quiz;

@interface YXCourseFilter : NSObject
@property (nonatomic, strong) NSString *filterID;
@property (nonatomic, strong) NSString *name;
@end

@interface YXCourseFilterGroup : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *filterArray;
@end

@interface YXCourseListFilterModel : NSObject
@property (nonatomic, strong) NSArray *groupArray;

+ (YXCourseListFilterModel *)modelFromRawData:(YXCourseListRequestItem *)item;
+ (YXCourseListFilterModel *)beijingModelFromRawData:(YXCourseListRequestItem *)item;
+ (YXCourseListFilterModel *)deyangModelFromRawData:(YXCourseListRequestItem *)item;
+ (NSArray<__kindof YXCourseListRequestItem_body_stage_quiz *> *)deyangFilterStagesQuiz:(YXCourseListRequestItem *)item;
@end
