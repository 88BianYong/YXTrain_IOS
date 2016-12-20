//
//  ActivityDetailManger.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityDetailManger.h"
#import "ActivityStepListRequest.h"
@interface ActivityDetailManger ()
@property (nonatomic, strong) ActivityStepListRequest *stepListRequest;
@end

@implementation ActivityDetailManger
- (void)startRequestActivityListItem:(ActivityListRequestItem_body_activity *)listItem WithBlock:(void (^)(ActivityListDetailModel *, NSError *))aCompleteBlock {
    if (self.stepListRequest) {
        [self.stepListRequest stopRequest];
    }
    ActivityStepListRequest *request = [[ActivityStepListRequest alloc] init];
    request.aid = listItem.aid;
    request.source = listItem.source;
    WEAK_SELF
    [request startRequestWithRetClass:[ActivityStepListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF;
        if (error) {
            aCompleteBlock(nil,error);
        }else {
            ActivityStepListRequestItem *item = retItem;
            ActivityListDetailModel *model = [ActivityListDetailModel modelFromActivityDetailData:item.body.active];
            [model modelFromActivityListData:listItem];
            aCompleteBlock(model,nil);
        }
    }];
    self.stepListRequest = request;
}
@end
