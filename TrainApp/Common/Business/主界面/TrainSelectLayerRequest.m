//
//  TrainSelectLayerRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TrainSelectLayerRequest.h"

@implementation TrainSelectLayerRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"peixun/layer/selectLayer"];
    }
    return self;
}
@end
