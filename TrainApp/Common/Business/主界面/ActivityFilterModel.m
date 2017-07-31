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
    __block NSInteger section = -1;
    __block NSInteger row = -1;
    [item.body.segments  enumerateObjectsUsingBlock:^(ActivityFilterRequestItem_body_segment *segment, NSUInteger idx, BOOL * _Nonnull stop) {
        ActivityFilter *temp = [[ActivityFilter alloc]init];
        temp.filterID = segment.segmentID;
        temp.name = segment.name;
        [segmentArray addObject:temp];
        if (item.body.defaultChoose.segmentId.integerValue == segment.segmentID.integerValue) {
            section = idx;
        }
    }];
    ActivityFilterGroup *segmentGroup = [[ActivityFilterGroup alloc]init];
    segmentGroup.name = @"学段";
    segmentGroup.filterArray = segmentArray;
    
    // 学科
    NSMutableArray *studyArray = [NSMutableArray array];
    [item.body.studys  enumerateObjectsUsingBlock:^(ActivityFilterRequestItem_body_study *study, NSUInteger idx, BOOL * _Nonnull stop) {
        ActivityFilter *temp = [[ActivityFilter alloc]init];
        temp.filterID = study.studyID;
        temp.name = study.name;
        [studyArray addObject:temp];
        if (item.body.defaultChoose.studyId.integerValue == study.studyID.integerValue) {
            row = idx;
        }
    }];

    ActivityFilterGroup *studyGroup = [[ActivityFilterGroup alloc]init];
    studyGroup.name = @"学科";
    studyGroup.filterArray = studyArray;
    // 阶段
    NSMutableArray *stageArray = [NSMutableArray array];
    for (ActivityFilterRequestItem_body_stage *stage in item.body.stages) {
        ActivityFilter *item = [[ActivityFilter alloc]init];
        item.filterID = stage.stageID;
        item.name = stage.name;
        if (stage.stageID.integerValue == 2179) {//TD: 12-08 产品要求写死
            item.name = @"专业发展类";
        }
        [stageArray addObject:item];
    }
    ActivityFilterGroup *stageGroup = [[ActivityFilterGroup alloc]init];
    stageGroup.name = [LSTSharedInstance sharedInstance].trainManager.trainHelper.activityStageName;
    stageGroup.filterArray = stageArray;
    
    ActivityFilterModel *model = [[ActivityFilterModel alloc]init];
    model.groupArray = @[stageGroup,segmentGroup,studyGroup];
    model.selectedMutableArray = [@[@(section),@(row)] mutableCopy];
    return model;
}
@end
