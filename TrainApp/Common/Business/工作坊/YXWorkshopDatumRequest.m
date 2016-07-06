//
//  YXWorkshopDatumRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopDatumRequest.h"

@implementation YXWorkshopDatumRequest
- (NSString *)condition {
    return [NSString stringWithFormat:@"{\"source\":\"ios\",\"barid\":\"%@\",\"interf\":\"SearchFilter\"}", self.barid];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"search/search"];
    }
    return self;
}

@end
