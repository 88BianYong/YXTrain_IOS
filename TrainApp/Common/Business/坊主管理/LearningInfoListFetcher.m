//
//  LearningInfoListFetcher.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LearningInfoListFetcher.h"
@interface LearningInfoListFetcher ()
@property (nonatomic, strong) MasterLearningInfoListRequest *listRequest;
@end
@implementation LearningInfoListFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock
{
    [self.listRequest stopRequest];
    self.listRequest = [[MasterLearningInfoListRequest alloc] init];
    self.listRequest.ifhg = self.ifhg;
    self.listRequest.ifcx = self.ifcx;
    self.listRequest.ifxx = self.ifxx;
    self.listRequest.projectId = self.projectId;
    self.listRequest.barId = self.barId;
    self.listRequest.page = [NSString stringWithFormat:@"%d",self.pageindex];
    self.listRequest.pageSize = [NSString stringWithFormat:@"%d",self.pagesize];;
    WEAK_SELF
    [self.listRequest startRequestWithRetClass:[MasterLearningInfoListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        MasterLearningInfoListRequestItem *item = retItem;
        BLOCK_EXEC(self.learningInfoListFetcherBlock,item.body);
        BOOL isLastPage = [self.listRequest.page isEqualToString:item.body.totalPage];
        if (isLastPage) {
            BLOCK_EXEC(aCompleteBlock,0,item.body.learningInfoList,nil);
        }else {
            BLOCK_EXEC(aCompleteBlock,(int)NSIntegerMax,item.body.learningInfoList,nil);
        }
    }];
}
@end
