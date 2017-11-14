//
//  CourseCenterListFetcher.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCenterListFetcher_17.h"
@interface CourseCenterListFetcher_17 ()
@property (nonatomic, strong) CourseCenterListRequest_17 *listRequest;
@end
@implementation CourseCenterListFetcher_17
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.listRequest stopRequest];
    CourseCenterListRequest_17 *request = [[CourseCenterListRequest_17 alloc] init];
    request.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.page = [NSString stringWithFormat:@"%d",self.pageindex + 1];
    request.limit = [NSString stringWithFormat:@"%d",self.pagesize];
    request.stageID = self.stageID;
    request.study =  self.study;
    request.segment = self.segment;
    request.tab = self.tab;
    request.status = self.status;
    WEAK_SELF
    [request startRequestWithRetClass:[CourseCenterListRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        CourseCenterListRequest_17Item *item = retItem;
        BLOCK_EXEC(self.courseCenterItemBlock,item.summary);
        BOOL isLastPage = [request.page isEqualToString:item.totalPage];
        if (isLastPage) {
            BLOCK_EXEC(aCompleteBlock,0,item.courses,nil);
        }else {
            BLOCK_EXEC(aCompleteBlock,(int)NSIntegerMax,item.courses,nil);
        }
    }];
    self.listRequest = request;
}
@end
