//
//  MasterHomeworkListRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkListRequest_17.h"
@implementation MasterHomeworkListItem_Body_Bar
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"barId":@"barid"}];
}
@end
@implementation MasterHomeworkListItem_Body_Homework
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"homeworkId":@"id"}];
}
- (void)setFinishDate:(NSString<Optional> *)finishDate {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:finishDate];
    [dateFormater setDateFormat:@"yyyy.MM.dd"];
    NSString *currentDateString = [dateFormater stringFromDate:date];
    _finishDate = currentDateString;
}
@end
@implementation MasterHomeworkListItem_Body
@end
@implementation  MasterHomeworkListItem
@end
@implementation MasterHomeworkListRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/manageHomeworkIndex"];
    }
    return self;
}

@end
