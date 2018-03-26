//
//  YXDynamicDatumFetch.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDynamicDatumFetch.h"
@interface YXDynamicDatumFetch ()
@property (nonatomic, strong)YXDynamicRequest *dynamicRequest;
@end


@implementation YXDynamicDatumFetch
- (void)startWithBlock:(void(^)(NSInteger total, NSArray *retItemArray, NSError *error))aCompleteBlock{
    YXDynamicRequest *request = [[YXDynamicRequest alloc] init];
//    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;消息动态界面不区分项目
    request.pageNo = [NSString stringWithFormat:@"%d", self.pageindex + 1];
    request.pageSize = [NSString stringWithFormat:@"%d", self.pagesize];
    [request startRequestWithRetClass:[YXDynamicRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
            aCompleteBlock(0, nil, error);
        }
        else{
            YXDynamicRequestItem *item = (YXDynamicRequestItem *)retItem;
            aCompleteBlock([item.total intValue],item.body,nil);
        }
    }];
    self.dynamicRequest = request;
}
- (void)stop{
    [self.dynamicRequest stopRequest];
}
@end
