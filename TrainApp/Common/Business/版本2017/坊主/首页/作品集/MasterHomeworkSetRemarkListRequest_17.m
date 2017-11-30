//
//  MasterHomeworkSetRemarkListRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkSetRemarkListRequest_17.h"
@implementation MasterHomeworkSetRemarkListItem_Body_Remark
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"rId":@"id"}];
}
@end

@implementation  MasterHomeworkSetRemarkListItem_Body
@end

@implementation MasterHomeworkSetRemarkListItem
@end
@implementation MasterHomeworkSetRemarkListRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/homeworkSet/remarks"];
    }
    return self;
}
@end
