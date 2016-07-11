//
//  YXUploadHeadImgRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/8/27.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXUploadHeadImgRequest.h"

NSString *const YXUpdateHeadImgSuccessNotification = @"kYXUpdateHeadImgSuccessNotification";

@implementation YXUploadHeadImgItem

@end

@implementation YXUploadHeadImgRequest{
    //void(^_completeBlock)(YXUploadHeadImgItem *retItem, NSError *error);
}

//- (void)startRequestWithBlock:(void(^)(YXUploadHeadImgItem *retItem, NSError *error))aCompleteBlock
//{
//    _completeBlock = aCompleteBlock;
//    [self startRequest];
//}

//- (void)dealWithResponseJson:(NSString *)aJson andError:(NSError *)aError {
//    if (aError) {
//        // http错误
//        if (aError
//            && [aError.domain isEqualToString:NetworkRequestErrorDomain]) {
//            NSString *title = @"";
//            if (aError.code == ASIConnectionFailureErrorType) {
//                title = @"网络异常，请稍后重试";
//            } else if (aError.code == ASIRequestTimedOutErrorType) {
//                title = @"请求超时，请稍后重试";
//            }
//            aError = [NSError errorWithDomain:NetworkRequestErrorDomain code:ASIConnectionFailureErrorType userInfo:@{NSLocalizedDescriptionKey:title}]; // 网络异常提示
//        }
//        _completeBlock(nil, aError);
//        return;
//    }
//    
//    NSError *error = nil;
//    YXUploadHeadImgItem *item = [[YXUploadHeadImgItem alloc] initWithString:aJson error:&error];
//    if (error) {
//        // json格式错误
//        _completeBlock(nil, error);
//        return;
//    }
//    
//    if (item.code.intValue != 0) {
//        // 业务逻辑错误
//        error = [NSError errorWithDomain:@"Request API" code:item.code.intValue userInfo:nil];
//        _completeBlock(nil, error);
//        return;
//    }
//    
//    _completeBlock(item, nil);
//}

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"resource/uploadheader"];
        self.width = @"80";
        self.height = @"80";
        self.left = @"-40";
        self.top = @"40";
        self.rate = @"1";
        self.token = [YXUserManager sharedManager].userModel.token;
    }
    return self;
}

@end
