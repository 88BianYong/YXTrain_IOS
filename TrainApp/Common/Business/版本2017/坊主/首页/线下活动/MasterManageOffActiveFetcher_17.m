//
//  MasterManageOffActiveFetcher_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageOffActiveFetcher_17.h"
#import "MasterManageOffActiveRequest_17.h"
@interface MasterManageOffActiveFetcher_17 ()
@property (nonatomic, strong) MasterManageOffActiveRequest_17 *listRequest;
@end
@implementation MasterManageOffActiveFetcher_17
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.listRequest stopRequest];
    MasterManageOffActiveRequest_17 *request = [[MasterManageOffActiveRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.page = [NSString stringWithFormat:@"%d",self.pageindex + 1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.pagesize];
    WEAK_SELF
    [request startRequestWithRetClass:[MasterManageOffActiveItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        MasterManageOffActiveItem *item = retItem;
        BLOCK_EXEC(self.masterManageOffActiveBlock,item.body.scheme);
        BLOCK_EXEC(aCompleteBlock,item.body.total.integerValue,item.body.offActives,nil);
    }];
    self.listRequest = request;
}
@end
