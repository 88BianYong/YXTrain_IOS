//
//  MasterManageBriefFetcher_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageBriefFetcher_17.h"
#import "MasterManageBriefRequest_17.h"
@interface MasterManageBriefFetcher_17 ()
@property (nonatomic, strong) MasterManageBriefRequest_17 *briefRequest;
@end
@implementation MasterManageBriefFetcher_17
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.briefRequest stopRequest];
    MasterManageBriefRequest_17 *request = [[MasterManageBriefRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.page = [NSString stringWithFormat:@"%d",self.pageindex + 1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.pagesize];
    WEAK_SELF
    [request startRequestWithRetClass:[MasterManageBriefItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        MasterManageBriefItem *item = retItem;
        BLOCK_EXEC(self.masterBriefSchemeBlock,item.body.scheme);
        BLOCK_EXEC(aCompleteBlock,item.body.total.integerValue,item.body.briefs,nil);
    }];
    self.briefRequest = request;
}
@end
