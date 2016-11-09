//
//  ActivityFilterModel.m
//  TrainApp
//
//  Created by ZLL on 2016/11/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityFilterModel.h"
#import "ActivityFilterRequest.h"
@implementation ActivityFilter
@end

@implementation ActivityFilterGroup
@end

@implementation ActivityFilterModel
+ (ActivityFilterModel *)modelFromRawData:(ActivityFilterRequestItem *)item {
    // 学段
    NSMutableArray *segmentArray = [NSMutableArray array];
    ActivityFilter *segmentWholeItem = [[ActivityFilter alloc]init];
    segmentWholeItem.name = @"全部";
    [segmentArray addObject:segmentWholeItem];
    for (ActivityFilterRequestItem_body_segment *segment in item.body.segments) {
        ActivityFilter *item = [[ActivityFilter alloc]init];
        item.filterID = segment.segmentID;
        item.name = segment.name;
        [segmentArray addObject:item];
    }
    ActivityFilterGroup *segmentGroup = [[ActivityFilterGroup alloc]init];
    segmentGroup.name = @"学段";
    segmentGroup.filterArray = segmentArray;
    // 学科
    NSMutableArray *studyArray = [NSMutableArray array];
    ActivityFilter *studyWholeItem = [[ActivityFilter alloc]init];
    studyWholeItem.name = @"全部";
    [studyArray addObject:studyWholeItem];
    for (ActivityFilterRequestItem_body_study *study in item.body.studys) {
        ActivityFilter *item = [[ActivityFilter alloc]init];
        item.filterID = study.studyID;
        item.name = study.name;
        [studyArray addObject:item];
    }
    ActivityFilterGroup *studyGroup = [[ActivityFilterGroup alloc]init];
    studyGroup.name = @"学科";
    studyGroup.filterArray = studyArray;
    // 阶段
    NSMutableArray *stageArray = [NSMutableArray array];
    ActivityFilter *stageWholeItem = [[ActivityFilter alloc]init];
    stageWholeItem.name = @"全部";
    [stageArray addObject:stageWholeItem];
    for (ActivityFilterRequestItem_body_stage *stage in item.body.stages) {
        ActivityFilter *item = [[ActivityFilter alloc]init];
        item.filterID = stage.stageID;
        item.name = stage.name;
        [stageArray addObject:item];
    }
    ActivityFilterGroup *stageGroup = [[ActivityFilterGroup alloc]init];
    stageGroup.name = @"阶段";
    stageGroup.filterArray = stageArray;
    
    ActivityFilterModel *model = [[ActivityFilterModel alloc]init];
    model.groupArray = @[segmentGroup,studyGroup,stageGroup];
    return model;
}
@end
