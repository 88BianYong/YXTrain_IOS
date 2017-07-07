//
//  BeijingActivityFilterModel.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/26.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingActivityFilterManager.h"
#import "BeijingActivityFilterRequest.h"
@interface BeijingActivityFilterManager ()
@property (nonatomic, strong) BeijingActivityFilterRequest *filterRequest;
@end
@implementation BeijingActivityFilter
@end

@implementation BeijingActivityFilterModel
- (NSArray<BeijingActivityFilter *> *)study {
    return self.segment[self.chooseInteger].filterArray;
}
+ (BeijingActivityFilterModel *)modelFromRawData:(BeijingActivityFilterRequestItem *)item {
    BeijingActivityFilterModel *model = [[BeijingActivityFilterModel alloc] init];
    //类别
    model.stageName = @"类别";
    NSMutableArray *stageMutableArray = [[NSMutableArray alloc] init];
    for (BeijingActivityFilterRequestItem_Filter *filter in item.body.stage) {
        BeijingActivityFilter *item = [[BeijingActivityFilter alloc]init];
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
    for (BeijingActivityFilterRequestItem_Body_Segment *segment in item.body.segment) {
        BeijingActivityFilter *segmentFilter = [[BeijingActivityFilter alloc]init];
        segmentFilter.filterID = segment.segmentID;
        segmentFilter.name = segment.name;
        NSMutableArray *studyArray = [[NSMutableArray alloc] init];
        for (BeijingActivityFilterRequestItem_Filter *filter in segment.study) {
            BeijingActivityFilter *item = [[BeijingActivityFilter alloc]init];
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

@implementation BeijingActivityFilterManager
- (void)startRequestActivityFilterItemWithBlock:(void (^)(BeijingActivityFilterModel *, NSError *))aCompleteBlock {
    if (self.filterRequest) {
        [self.filterRequest stopRequest];
    }
    BeijingActivityFilterRequest *request = [[BeijingActivityFilterRequest alloc]init];
    request.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    WEAK_SELF
    [request startRequestWithRetClass:[BeijingActivityFilterRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            aCompleteBlock(nil,error);
            return;
        }
        BeijingActivityFilterRequestItem *item = (BeijingActivityFilterRequestItem *)retItem;
        aCompleteBlock ([BeijingActivityFilterModel modelFromRawData:item],nil);
    }];
    self.filterRequest = request;
}
@end


