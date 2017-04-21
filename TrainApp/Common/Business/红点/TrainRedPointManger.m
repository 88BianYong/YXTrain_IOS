//
//  TrainRedPointManger.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TrainRedPointManger.h"

@implementation TrainRedPointManger
+ (instancetype)sharedInstance {
    static TrainRedPointManger *manger = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        manger = [[TrainRedPointManger alloc] init];
    });
    return manger;
}
- (instancetype)init {
    if (self = [super init]) {
        self.dynamicInteger = -1;
        self.hotspotInteger = -1;
    }
    return self;
}
- (void)setDynamicInteger:(NSInteger)dynamicInteger {
    _dynamicInteger = dynamicInteger;
    [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainPushWebSocketReceiveMessage object:nil];
}

- (void)setHotspotInteger:(NSInteger)hotspotInteger {
    _hotspotInteger = hotspotInteger;
    [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainPushWebSocketReceiveMessage object:nil];

}

- (NSInteger)showRedPointInteger {
    if (self.dynamicInteger > 0) {
        return self.dynamicInteger;
    }
    if (self.hotspotInteger > 0) {
        return 0;
    }
    return -1;
}
@end
