//
//  ReadingSubmitStatusRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ReadingSubmitStatusRequest_17.h"

@implementation ReadingSubmitStatusRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"projectid":@"projectID",
                                                       @"stateid":@"stageID",
                                                       @"id":@"contentID"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/reading/submitStatus"];
        self.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    }
    return self;
}
@end
