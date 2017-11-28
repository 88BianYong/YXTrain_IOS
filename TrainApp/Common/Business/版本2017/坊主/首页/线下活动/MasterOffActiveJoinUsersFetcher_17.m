//
//  MasterOffActiveJoinUsersFetcher_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOffActiveJoinUsersFetcher_17.h"
#import "MasterOffActiveJoinUsersRequest_17.h"
@interface MasterOffActiveJoinUsersFetcher_17 ()
@property (nonatomic, strong) MasterOffActiveJoinUsersRequest_17 *listRequest;
@end
@implementation MasterOffActiveJoinUsersFetcher_17
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.listRequest stopRequest];
     MasterOffActiveJoinUsersRequest_17 *request = [[ MasterOffActiveJoinUsersRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.page = [NSString stringWithFormat:@"%d",self.pageindex + 1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.pagesize];
    request.aId = self.aId;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterOffActiveJoinUsersItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        MasterOffActiveJoinUsersItem *item = retItem;
        BLOCK_EXEC(aCompleteBlock,item.body.total.integerValue,item.body.joinUsers,nil);
    }];
    self.listRequest = request;
}
@end
