//
//  MasterLearningInfoFetcher_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterLearningInfoFetcher_17.h"
#import "MasterLearningInfoRequest_17.h"
@interface MasterLearningInfoFetcher_17 ()
@property (nonatomic, strong) MasterLearningInfoRequest_17 *infoRequest;
@end
@implementation MasterLearningInfoFetcher_17
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.infoRequest stopRequest];
    MasterLearningInfoRequest_17 *request = [[MasterLearningInfoRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.page = [NSString stringWithFormat:@"%d",self.pageindex + 1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.pagesize];
    request.status = self.status;
    request.barId =  self.barId;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterLearningInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        MasterLearningInfoRequestItem *item = retItem;
//        if (item.body.xueQing.total.integerValue ) {
//
//        }
        BLOCK_EXEC(aCompleteBlock,item.body.xueQing.total.integerValue,item.body.xueQing.learningInfoList,nil);
    }];
    self.infoRequest = request;
}
@end
