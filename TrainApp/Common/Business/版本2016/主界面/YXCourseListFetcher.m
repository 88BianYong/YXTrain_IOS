//
//  YXCourseListFetcher.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseListFetcher.h"

@interface YXCourseListFetcher()
@property (nonatomic, strong) YXCourseListRequest *request;
@end

@implementation YXCourseListFetcher
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock
{
    [self.request stopRequest];
    self.request = [[YXCourseListRequest alloc] init];
    self.request.pid = self.pid;
    self.request.pageindex = [NSString stringWithFormat:@"%d", self.pageindex + 1];
    self.request.pagesize = [NSString stringWithFormat:@"%d", self.pagesize];
    self.request.studyid = self.studyid;
    self.request.segid = self.segid;
    self.request.type = self.type;
    self.request.stageid = self.stageid;
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXCourseListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        YXCourseListRequestItem *item = (YXCourseListRequestItem *)retItem;
        BLOCK_EXEC(self.filterBlock,[item filterModel]);
        BLOCK_EXEC(aCompleteBlock,item.body.total.intValue,[item allCourses],nil);
    }];
}


@end
