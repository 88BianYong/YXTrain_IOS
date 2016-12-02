//
//  BeijingCourseListFetcher.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
#import "BeijingCourseListFetcher.h"
@interface BeijingCourseListFetcher ()
@property (nonatomic, strong) YXCourseListRequest *request;
@end
@implementation BeijingCourseListFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock
{
    [self.request stopRequest];
    self.request = [[YXCourseListRequest alloc] init];
    self.request.pid = self.pid;
    self.request.pageindex = [NSString stringWithFormat:@"%d", self.pageindex + 1];
    self.request.pagesize = [NSString stringWithFormat:@"%d", self.pagesize];
    self.request.studyid = self.studyid;
    self.request.segid = self.segid;
    self.request.stageid = self.stageid;
    self.request.w = self.w;
    self.request.urlHead = self.urlHead;
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXCourseListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        YXCourseListRequestItem *item = (YXCourseListRequestItem *)retItem;
        BLOCK_EXEC(self.filterBlock,[item beijingFilterModel]);
        BLOCK_EXEC(aCompleteBlock,item.body.total.intValue,[item allCourses],nil);
    }];
}

@end
