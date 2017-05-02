//
//  DeYangCourseListFetcher.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "DeYangCourseListFetcher.h"
@interface DeYangCourseListFetcher()
@property (nonatomic, strong) YXCourseListRequest *request;
@end
@implementation DeYangCourseListFetcher
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
        BLOCK_EXEC(self.filterBlock,[item deyangFilterModel]);
        BLOCK_EXEC(self.filterQuizBlock,[item deyangFilterStagesQuiz]);
        BLOCK_EXEC(aCompleteBlock,item.body.total.intValue,[item allCourses],nil);
    }];
}
@end
