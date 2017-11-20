//
//  MasterManageNoticeFetcher_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageNoticeFetcher_17.h"
#import "MasterManageNoticeRequest_17.h"
@interface MasterManageNoticeFetcher_17 ()
@property (nonatomic, strong) MasterManageNoticeRequest_17 *noticeRequest;
@end
@implementation MasterManageNoticeFetcher_17
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.noticeRequest stopRequest];
    MasterManageNoticeRequest_17 *request = [[MasterManageNoticeRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.page = [NSString stringWithFormat:@"%d",self.pageindex + 1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.pagesize];
    WEAK_SELF
    [request startRequestWithRetClass:[MasterManageNoticeItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        MasterManageNoticeItem *item = retItem;
        BLOCK_EXEC(aCompleteBlock,item.body.total.integerValue,item.body.notices,nil);
    }];
    self.noticeRequest = request;
}
@end
