//
//  ActivityListFetcher.m
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityListFetcher.h"
#import "ActivityListRequest.h"
#import "ActivityFilterRequest.h"
@interface ActivityListFetcher()
@property (nonatomic, strong) ActivityListRequest *request;
@end
@implementation ActivityListFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock
{
    [self.request stopRequest];
    self.request = [[ActivityListRequest alloc] init];
    self.request.projectId = self.pid;
    self.request.page = [NSString stringWithFormat:@"%d", self.pageindex + 1];
    self.request.pagesize = [NSString stringWithFormat:@"%d", self.pagesize];
    self.request.studyId = self.studyid;
    self.request.segmentId = self.segid;
    self.request.stageId = self.stageid;
     WEAK_SELF
    [self.request startRequestWithRetClass:[ActivityListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        ActivityListRequestItem *item = (ActivityListRequestItem *)retItem;
        BLOCK_EXEC(self.listCompleteBlock,nil);
        BOOL isLastPage = [self.request.page isEqualToString:item.body.totalPage];
        if (isLastPage) {
            BLOCK_EXEC(aCompleteBlock,0,[item allActivities],nil);
        }else {
            BLOCK_EXEC(aCompleteBlock,(int)NSIntegerMax,[item allActivities],nil);
        }
    }];
}
@end
