//
//  ExamineToolStatusRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ExamineToolStatusRequest_17.h"
@implementation ExamineToolStatusRequest_17Item
@end
@implementation ExamineToolStatusRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"projectid":@"projectID"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/examine/toolStatus"];
        self.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    }
    return self;
}
@end
