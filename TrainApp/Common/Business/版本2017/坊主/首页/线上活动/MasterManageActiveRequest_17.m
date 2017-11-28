//
//  MasterManageActiveRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageActiveRequest_17.h"
@implementation MasterManageActiveItem_Body_Active
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"createUserName":@"createUsername",
                                            @"createUserId":@"createUserid",
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

@implementation MasterManageActiveItem_Body_Studie
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"studieId":@"id"
                                            }];
}
@end

@implementation MasterManageActiveItem_Body_Segment
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"segmentId":@"id"
                                            }];
}
@end

@implementation MasterManageActiveItem_Body_Stage
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"stageId":@"id"
                                            }];
}
@end

@implementation MasterManageActiveItem_Body_Bar
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"barId":@"id"
                                            }];
}
@end

@implementation MasterManageActiveItem_Body
@end


@implementation MasterManageActiveItem
@end
@implementation MasterManageActiveRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/manageActive"];
    }
    return self;
}
@end
