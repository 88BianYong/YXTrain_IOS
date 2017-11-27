//
//  MasterManageOffActiveRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageOffActiveRequest_17.h"
@implementation MasterManageOffActiveItem_Body_Active
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"userName":@"username",
                                                                  @"activeId":@"aid"
                                                                  }];
}
- (void)setStartTime:(NSString<Optional> *)startTime{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:startTime];
    [dateFormater setDateFormat:@"yyyy.MM.dd"];
    NSString *currentDateString = [dateFormater stringFromDate:date];
    _startTime = currentDateString;
}
- (void)setEndTime:(NSString<Optional> *)endTime{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:endTime];
    [dateFormater setDateFormat:@"yyyy.MM.dd"];
    NSString *currentDateString = [dateFormater stringFromDate:date];
    _endTime = currentDateString;
}
@end
@implementation MasterManageOffActiveItem_Body
@end
@implementation MasterManageOffActiveItem
@end
@implementation MasterManageOffActiveRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/manageOffActive"];
    }
    return self;
}
@end
