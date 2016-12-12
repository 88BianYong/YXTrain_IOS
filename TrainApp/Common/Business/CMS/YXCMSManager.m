//
//  YXCMSManager.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCMSManager.h"
@interface YXCMSManager()
@property (nonatomic, strong) YXRotateListRequest *listRequest;
@end

@implementation YXCMSManager

+ (instancetype)sharedManager
{
    static YXCMSManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXCMSManager alloc] init];
    });
    return manager;
}

- (void)requestWithType:(NSString *)type
             completion:(void (^)(NSArray *, NSError *))completion
{
    if (self.listRequest) {
       [self.listRequest stopRequest];
    }
    YXRotateListRequest *request = [[YXRotateListRequest alloc] init];
//    request.type = type;
    [request startRequestWithRetClass:[YXRotateListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (!error) {
            YXRotateListRequestItem *item = retItem;
            completion(item.rotates,error);
        }else{
            completion(nil,error);
        }
    }];
    self.listRequest = request;
}
@end
