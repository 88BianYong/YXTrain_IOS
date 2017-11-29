//
//  MasterHomeworkSetSetListRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkSetListRequest_17.h"
@implementation MasterHomeworkSetListItem_Body_Bar
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"barId":@"barid"}];
}
@end
@implementation MasterHomeworkSetListItem_Body_Homework
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"homeworkSetId":@"id",@"homeworkNum":@"homeworknum" }];
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
@implementation MasterHomeworkSetListItem_Body
@end
@implementation  MasterHomeworkSetListItem
@end
@implementation MasterHomeworkSetListRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/manageHomeworkSetIndex"];
    }
    return self;
}
@end
