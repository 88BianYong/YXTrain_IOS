//
//  MasterHomeworkRemarkRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkRemarkRequest_17.h"
@implementation MasterHomeworkRemarkItem_Body_Remark
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"rId":@"id"}];
}
@end

@implementation  MasterHomeworkRemarkItem_Body
@end

@implementation MasterHomeworkRemarkItem 
@end
@implementation MasterHomeworkRemarkRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/homework/remarks"];
    }
    return self;
}
@end
