//
//  MasterNoticeBriefScheme.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterNoticeBriefScheme.h"
@implementation MasterNoticeBriefItem
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"nbId":@"id",
                                                                  @"projectId":@"projectid"
                                                                  }];
}
- (void)setTime:(NSString<Optional> *)time {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormater dateFromString:time];
    [dateFormater setDateFormat:@"yyyy.MM.dd"];
    NSString *currentDateString = [dateFormater stringFromDate:date];
    _time = currentDateString;
}
@end
@implementation MasterNoticeBriefScheme

@end
