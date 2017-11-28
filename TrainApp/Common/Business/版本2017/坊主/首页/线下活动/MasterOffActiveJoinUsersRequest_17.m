//
//  MasterOffActiveJoinUsersRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOffActiveJoinUsersRequest_17.h"
@implementation MasterOffActiveJoinUsersItem_Body_JoinUser
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"schoolName":@"schoolname"
                                            }];
}
@end
@implementation MasterOffActiveJoinUsersItem_Body
@end

@implementation MasterOffActiveJoinUsersItem 
@end

@implementation MasterOffActiveJoinUsersRequest_17
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"aId":@"aid"
                                            }];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/offActiveJoinUsers"];
    }
    return self;
}
@end
