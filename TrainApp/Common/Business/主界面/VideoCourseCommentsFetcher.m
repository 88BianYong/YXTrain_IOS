//
//  VideoCourseCommentsFetcher.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseCommentsFetcher.h"
#import "VideoCourseCommentsRequest.h"
@interface VideoCourseCommentsFetcher ()
@property (nonatomic, strong) VideoCourseCommentsRequest *commentRequest;
@end
@implementation VideoCourseCommentsFetcher
- (void)startWithBlock:(VideoCourseCommentsCompleteBlock)aCompleteBlock {
    if (self.commentRequest){
        [self stop];
    }
    VideoCourseCommentsRequest *request = [[VideoCourseCommentsRequest alloc] init];
    request.commentID = self.commentID;
    request.courseID = self.courseID;
    request.offset = @"20";
    request.parentID = self.parentID;
    WEAK_SELF
    [request startRequestWithRetClass:[VideoCourseCommentsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,NO,nil,error);
        }else {
            VideoCourseCommentsRequestItem *item = (VideoCourseCommentsRequestItem *)retItem;
            BLOCK_EXEC(aCompleteBlock,item.body.comments.count < 20 ? NO : YES, item.body.comments,nil);
        }
    }];
    self.commentRequest = request;
}

- (void)stop {
    [self.commentRequest stopRequest];
}
@end
