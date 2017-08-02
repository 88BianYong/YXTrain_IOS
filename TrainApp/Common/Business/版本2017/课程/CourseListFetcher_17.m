//
//  CourseListFetcher_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseListFetcher_17.h"
@interface CourseListFetcher_17 ()
@property (nonatomic, strong) CourseListRequest_17 *listRequest;
@end
@implementation CourseListFetcher_17
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock
{
    [self.listRequest stopRequest];
    CourseListRequest_17 *request = [[CourseListRequest_17 alloc] init];
    request.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.page = [NSString stringWithFormat:@"%d",self.pageindex + 1];
    request.limit = [NSString stringWithFormat:@"%d",self.pagesize];
    request.stageID = self.stageID;
    request.study =  self.study;
    request.segment = self.segment;
    request.type =  self.type;
#warning 128
    request.themeID = @"128";
    //[LSTSharedInstance sharedInstance].trainManager.currentProject.themeId;
    WEAK_SELF
    [request startRequestWithRetClass:[CourseListRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        CourseListRequest_17Item *item = (CourseListRequest_17Item *)retItem;
        BLOCK_EXEC(self.courseListItemBlock,item);
        BLOCK_EXEC(aCompleteBlock,item.count.integerValue,item.objs,nil);
    }];
    self.listRequest = request;
}
@end
