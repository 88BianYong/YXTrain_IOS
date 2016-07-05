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
    // 类型
    NSMutableArray *typeArray = [NSMutableArray array];
    YXCourseFilter *typeWholeItem = [[YXCourseFilter alloc]init];
    typeWholeItem.name = @"全部";
    [typeArray addObject:typeWholeItem];
    for (YXCourseListRequestItem_body_type *type in item.body.types) {
        YXCourseFilter *item = [[YXCourseFilter alloc]init];
        item.filterID = type.typeID;
        item.name = type.name;
        [typeArray addObject:item];
    }
    YXCourseFilterGroup *g3 = [[YXCourseFilterGroup alloc]init];
    g3.name = @"类型";
    g3.filterArray = typeArray;
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
    YXCourseFilterGroup *g4 = [[YXCourseFilterGroup alloc]init];
    g4.name = @"阶段";
    g4.filterArray = stageArray;
    
    YXCourseListFilterModel *model = [[YXCourseListFilterModel alloc]init];
    model.groupArray = @[g2,g1,g3,g4];
    return model;
}
@end
