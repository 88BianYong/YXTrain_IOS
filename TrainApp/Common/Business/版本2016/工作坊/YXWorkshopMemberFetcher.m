//
//  YXWorkshopMemberFetcher.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopMemberFetcher.h"
#import "YXWorkshopMemberRequest.h"
@interface YXWorkshopMemberFetcher()
{
    YXWorkshopMemberRequest *_memberRequest;
}
@end
@implementation YXWorkshopMemberFetcher
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock{
    _memberRequest = [[YXWorkshopMemberRequest alloc] init];
    _memberRequest.barid = self.barid;
    
    _memberRequest.pageindex = [NSString stringWithFormat:@"%d", self.pageindex + 1];
    _memberRequest.pagesize = [NSString stringWithFormat:@"%d", self.pagesize];
    DDLogDebug(@"%d", self.pageindex);
    [_memberRequest startRequestWithRetClass:[YXWorkshopMemberRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
           aCompleteBlock(0, nil, error);
        }
        else{
            YXWorkshopMemberRequestItem *item = (YXWorkshopMemberRequestItem *)retItem;
            aCompleteBlock([item.total intValue],item.memberList,nil);
        }
    }];
}
- (void)stop{
    [_memberRequest stopRequest];
}
@end
