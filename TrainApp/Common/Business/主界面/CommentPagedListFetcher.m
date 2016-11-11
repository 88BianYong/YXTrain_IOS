//
//  CommentPagedListFetche.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/14.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "CommentPagedListFetcher.h"
#import "ActivityFirstCommentRequest.h"
@interface CommentPagedListFetcher ()
@property (nonatomic, strong) ActivityFirstCommentRequest *commentRequest;
@end
@implementation CommentPagedListFetcher

- (void)startWithBlock:(PagedListFetcherCompleteBlock)aCompleteBlock {
    if (self.commentRequest){
        [self stop];
    }
    ActivityFirstCommentRequest *request = [[ActivityFirstCommentRequest alloc] init];
    request.aid = self.aid;
    request.page = [NSString stringWithFormat:@"%d", self.pageindex];
    request.pageSize = [NSString stringWithFormat:@"%d", self.pageSize];
    request.topicid = self.topicid;
    request.parentid = self.parentid;
    WEAK_SELF
    [request startRequestWithRetClass:[ActivityFirstCommentRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,0,nil,error);
        }else {
            ActivityFirstCommentRequestItem *item = (ActivityFirstCommentRequestItem *)retItem;
            BLOCK_EXEC(aCompleteBlock,item.body.totalPage.intValue,item.body.page.intValue,item.body.replies,nil);
        }
    }];
}

- (void)stop {
    [self.commentRequest stopRequest];
}

@end
