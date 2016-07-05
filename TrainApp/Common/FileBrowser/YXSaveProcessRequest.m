//
//  YXSaveProcessRequest.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXSaveProcessRequest.h"

@implementation YXSaveProcessRequest
- (id)init {
    self = [super init];
    if (self) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"guopei/course/saveprocess"];
    }
    return self;
}
@end
