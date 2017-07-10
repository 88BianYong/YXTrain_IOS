//
//  TrainRedPointManger.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TrainRedPointManger.h"

@implementation TrainRedPointManger
- (instancetype)init {
    if (self = [super init]) {
        _dynamicInteger = -1;
        _hotspotInteger = -1;
    }
    return self;
}
- (void)setDynamicInteger:(NSInteger)dynamicInteger {
    _dynamicInteger = dynamicInteger;
    if (_dynamicInteger > 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber  = _dynamicInteger;
    }else {
        [UIApplication sharedApplication].applicationIconBadgeNumber  = 0;
    }
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
