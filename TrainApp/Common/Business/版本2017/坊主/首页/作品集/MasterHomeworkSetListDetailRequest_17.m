//
//  MasterHomeworkSetListDetailRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkSetListDetailRequest_17.h"
@implementation MasterHomeworkSetListDetailItem_Body_Homework
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"homeworkId":@"id",
                                                                  @"templateId":@"templateid"
                                                                  }];
}
@end
@implementation MasterHomeworkSetListDetailItem_Body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"homeworkSetId":@"id"}];
}
@end
@implementation MasterHomeworkSetListDetailItem 
@end
@implementation MasterHomeworkSetListDetailRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/homeworkSetDetail"];
        self.hook = @"yes";
    }
    return self;
}
@end
