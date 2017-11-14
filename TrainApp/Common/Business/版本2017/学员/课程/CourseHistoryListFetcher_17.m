//
//  CourseHistoryListFetcher_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseHistoryListFetcher_17.h"
#import "CourseListRequest_17.h"
#import "CourseHistoryListRequest_17.h"
@interface CourseHistoryListFetcher_17 ()
@property (nonatomic, strong) CourseHistoryListRequest_17 *listRequest;
@end
@implementation CourseHistoryListFetcher_17
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.listRequest stopRequest];
    CourseHistoryListRequest_17 *request = [[CourseHistoryListRequest_17 alloc] init];
    request.page = [NSString stringWithFormat:@"%d",self.pageindex + 1];
    request.limit = [NSString stringWithFormat:@"%d",self.pagesize];
    request.stageID = self.stageID;
    WEAK_SELF
    [request startRequestWithRetClass:[CourseListRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        CourseListRequest_17Item *item = (CourseListRequest_17Item *)retItem;
        BLOCK_EXEC(aCompleteBlock,item.count.integerValue,item.objs,nil);
    }];
    self.listRequest = request;
}
@end
