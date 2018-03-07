//
//  MasterSelectThemeRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/3/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MasterSelectThemeRequest_17.h"

@implementation MasterSelectThemeRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/theme/selectTheme"];
    }
    return self;
}
@end
