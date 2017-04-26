//
//  YXCourseListFilterModel.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseListFilterModel.h"
#import "YXCourseListRequest.h"

@implementation YXCourseFilterGroup

@end

@implementation YXCourseFilter

@end

@implementation YXCourseListFilterModel
+ (YXCourseListFilterModel *)modelFromRawData:(YXCourseListRequestItem *)item{
    // 学科
    NSMutableArray *studyArray = [NSMutableArray array];
    YXCourseFilter *studyWholeItem = [[YXCourseFilter alloc]init];
    studyWholeItem.name = @"全部";
    [studyArray addObject:studyWholeItem];
    for (YXCourseListRequestItem_body_study *study in item.body.studys) {
        YXCourseFilter *item = [[YXCourseFilter alloc]init];
        item.filterID = study.studyID;
        item.name = study.name;
        [studyArray addObject:item];
    }
    YXCourseFilterGroup *g1 = [[YXCourseFilterGroup alloc]init];
    g1.name = @"学科";
    g1.filterArray = studyArray;
    // 学段
    NSMutableArray *segmentArray = [NSMutableArray array];
    YXCourseFilter *segmentWholeItem = [[YXCourseFilter alloc]init];
    segmentWholeItem.name = @"全部";
    [segmentArray addObject:segmentWholeItem];
    for (YXCourseListRequestItem_body_segment *segment in item.body.segments) {
        YXCourseFilter *item = [[YXCourseFilter alloc]init];
        item.filterID = segment.segmentID;
        item.name = segment.name;
        [segmentArray addObject:item];
    }
    YXCourseFilterGroup *g2 = [[YXCourseFilterGroup alloc]init];
    g2.name = @"学段";
    g2.filterArray = segmentArray;
    // 阶段
    NSMutableArray *stageArray = [NSMutableArray array];
    YXCourseFilter *stageWholeItem = [[YXCourseFilter alloc]init];
    stageWholeItem.name = @"全部";
    [stageArray addObject:stageWholeItem];
    for (YXCourseListRequestItem_body_stage *stage in item.body.stages) {
        YXCourseFilter *item = [[YXCourseFilter alloc]init];
        item.filterID = stage.stageID;
        item.name = stage.name;
        [stageArray addObject:item];
    }
    YXCourseFilterGroup *g3 = [[YXCourseFilterGroup alloc]init];
    g3.name = @"阶段";
    g3.filterArray = stageArray;
    
    YXCourseListFilterModel *model = [[YXCourseListFilterModel alloc]init];
    model.groupArray = @[g3,g2,g1];
    return model;
}

+ (YXCourseListFilterModel *)beijingModelFromRawData:(YXCourseListRequestItem *)item {
    // 学科
    NSMutableArray *studyArray = [NSMutableArray array];
    for (YXCourseListRequestItem_body_study *study in item.body.studys) {
        YXCourseFilter *item = [[YXCourseFilter alloc]init];
        item.filterID = study.studyID;
        item.name = study.name;
        [studyArray addObject:item];
    }
    YXCourseFilterGroup *g1 = [[YXCourseFilterGroup alloc]init];
    g1.name = @"学科";
    g1.filterArray = studyArray;
    // 学段
    NSMutableArray *segmentArray = [NSMutableArray array];
    for (YXCourseListRequestItem_body_segment *segment in item.body.segments) {
        YXCourseFilter *item = [[YXCourseFilter alloc]init];
        item.filterID = segment.segmentID;
        item.name = segment.name;
        [segmentArray addObject:item];
    }
    YXCourseFilterGroup *g2 = [[YXCourseFilterGroup alloc]init];
    g2.name = @"学段";
    g2.filterArray = segmentArray;
    // 阶段
    NSMutableArray *stageArray = [NSMutableArray array];
    for (YXCourseListRequestItem_body_stage *stage in item.body.stages) {
        YXCourseFilter *item = [[YXCourseFilter alloc]init];
        item.filterID = stage.stageID;
        item.name = stage.name;
        if (stage.stageID.integerValue == 2179) {//TD: 12-08 产品要求写死
           item.name = @"专业发展类";
        }
        [stageArray addObject:item];
    }
    YXCourseFilterGroup *g3 = [[YXCourseFilterGroup alloc]init];
    g3.name = @"类别";
    g3.filterArray = stageArray;
    
    YXCourseListFilterModel *model = [[YXCourseListFilterModel alloc]init];
    model.groupArray = @[g2,g1,g3];
    return model;
}
@end
