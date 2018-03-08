//
//  MasterThemeListRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/3/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MasterThemeListRequest_17.h"
@implementation MasterThemeListItem_Body_Theme
@end
@implementation MasterThemeListItem_Body
@end
@implementation MasterThemeListItem
@end
@implementation MasterThemeListRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/theme/list"];
    }
    return self;
}
@end
