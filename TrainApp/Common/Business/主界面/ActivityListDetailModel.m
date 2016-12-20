//
//  ActivityListDetailModel.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityListDetailModel.h"

@implementation ActivityListDetailModel
//活动详情model转换
+ (ActivityListDetailModel *)modelFromActivityDetailData:(ActivityStepListRequestItem_body_Active *)item {
    ActivityListDetailModel *model = [[ActivityListDetailModel alloc] init];
    model.aid = item.aid;
    model.title = item.title;
    model.createUsername = item.createUsername;
    model.desc = item.desc;
    model.status = item.status;
    model.steps = [[NSMutableArray alloc] initWithArray:item.steps];
    return model;
}

- (ActivityListDetailModel *)modelFromActivityListData:(ActivityListRequestItem_body_activity *)item {
    self.joinUserCount = item.joinUserCount;
    self.studyName = item.studyName;
    self.segmentName = item.segmentName;
    return self;
}
@end
