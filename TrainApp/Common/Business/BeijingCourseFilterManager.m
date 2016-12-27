//
//  BeijingCourseFilterManager.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingCourseFilterManager.h"
#import "BeijingCourseFilterRequest.h"
@interface BeijingCourseFilterManager ()
@property (nonatomic, strong) BeijingCourseFilterRequest *filterRequest;
@end
@implementation BeijingCourseFilter
@end

@implementation BeijingCourseFilterModel
- (NSArray<BeijingCourseFilter *> *)study {
    return self.segment[self.chooseInteger].filterArray;
}
+ (BeijingCourseFilterModel *)modelFromRawData:(BeijingCourseFilterRequestItem *)item {
    BeijingCourseFilterModel *model = [[BeijingCourseFilterModel alloc] init];
    //类别
    model.stageName = @"类别";
    NSMutableArray *stageMutableArray = [[NSMutableArray alloc] init];
    for (BeijingCourseFilterRequestItem_Filter *filter in item.body.stage) {
        BeijingCourseFilter *item = [[BeijingCourseFilter alloc]init];
        item.filterID = filter.filterID;
        item.name = filter.name;
        if (filter.filterID.integerValue == 2179) {//TD: 12-08 产品要求写死
            item.name = @"专业发展类";
        }
        [stageMutableArray addObject:item];
    }
    model.stage = stageMutableArray;
    //学段
    NSMutableArray *segmentArray = [[NSMutableArray alloc] init];
    for (BeijingCourseFilterRequestItem_Body_Segment *segment in item.body.segment) {
        BeijingCourseFilter *segmentFilter = [[BeijingCourseFilter alloc]init];
        segmentFilter.filterID = segment.segmentID;
        segmentFilter.name = segment.name;
        NSMutableArray *studyArray = [[NSMutableArray alloc] init];
        for (BeijingCourseFilterRequestItem_Filter *filter in segment.study) {
            BeijingCourseFilter *item = [[BeijingCourseFilter alloc]init];
            item.filterID = filter.filterID;
            item.name = filter.name;
            [studyArray addObject:item];
        }
        segmentFilter.filterArray = studyArray;
        [segmentArray addObject:segmentFilter];
    }
    model.segmentName = @"学段";
    model.segment = segmentArray;
    model.studyName = @"学科";
    model.chooseInteger = 0;
    return model;
}
@end

@implementation BeijingCourseFilterManager
- (void)startRequestCourseFilterItemWithBlock:(void (^)(BeijingCourseFilterModel *, NSError *))aCompleteBlock {
    if (self.filterRequest) {
        [self.filterRequest stopRequest];
    }
    BeijingCourseFilterRequest *request = [[BeijingCourseFilterRequest alloc]init];
    request.pid = [YXTrainManager sharedInstance].currentProject.pid;
    WEAK_SELF
    [request startRequestWithRetClass:[BeijingCourseFilterRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            aCompleteBlock(nil,error);
            return;
        }
        BeijingCourseFilterRequestItem *item = (BeijingCourseFilterRequestItem *)retItem;
        aCompleteBlock ([BeijingCourseFilterModel modelFromRawData:item],nil);
    }];
    self.filterRequest = request;
}
@end
