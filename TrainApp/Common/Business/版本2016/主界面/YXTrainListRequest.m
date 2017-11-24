//
//  YXTrainListRequest.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTrainListRequest.h"

@implementation YXTrainListRequestItem_body_train
- (NSString<Optional> *)role {
    if (_role) {
        return _role;
    }else {
        NSArray *array = [self.roles componentsSeparatedByString:@","];
        for (NSString *r in array) {
            if ([r isEqualToString:@"99"]) {
                return @"99";
            }
        }
        return @"9";
    }
}
- (NSString<Optional> *)isDoubel {
    if (self.w.integerValue == 5) {
        return @"0";
    }
    BOOL isMaster = NO;
    BOOL isStudent = NO;
    NSArray *array = [self.roles componentsSeparatedByString:@","];
    for (NSString *r in array) {
        if ([r isEqualToString:@"99"]) {
            isMaster = YES;
        }
        if ([r isEqualToString:@"9"]) {
            isStudent = YES;
        }
    }
    if (isStudent && isMaster) {
        return @"1";
    }else {
        return @"0";
    }
}

- (NSString<Optional> *)isOpenLayer {
    if (_isOpenLayer.boolValue && self.layerId.integerValue <= 0) {
        return @"1";
    }else {
        return @"0";
    }
}
- (NSString<Optional> *)isOpenTheme {
    if (_isOpenTheme.boolValue && self.themeId.integerValue <= 0) {
        return @"1";
    }else {
        return @"0";
    }
}
- (void)setStartDate:(NSString<Optional> *)startDate {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:startDate];
    [dateFormater setDateFormat:@"yyyy.MM.dd"];
    NSString *currentDateString = [dateFormater stringFromDate:date];
    _startDate = currentDateString;
}
- (void)setEndDate:(NSString<Optional> *)endDate {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:endDate];
    [dateFormater setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDateString = [dateFormater stringFromDate:date];
    _endDate = currentDateString;
}
@end

@implementation YXTrainListRequestItem_body
@end

@implementation YXTrainListRequestItem

@end

@implementation YXTrainListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"guopei/trainlist"];
    }
    return self;
}
@end
