//
//  YXTrainListRequest.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTrainListRequest.h"

@implementation YXTrainListRequestItem_body_train
- (NSString<Ignore> *)role {
    if (_role) {
        return _role;
    }else {
//        if (self.special.integerValue == 1 && self.w.integerValue >= 5) { //18德阳只显示学员端,又因为需要判断该用户是否存在坊主管理员身份以便确定不显示线下研修,所以如此操作(不能直接删除管理员身份)
//            return @"9";
//        }
        NSArray *array = [self.roles componentsSeparatedByString:@","];
        for (NSString *r in array) {
            if ([r isEqualToString:@"99"]) {
                return @"99";
            }
        }
        return @"9";
    }
}
- (NSString<Ignore> *)isDoubel {
//    if (self.special.integerValue == 1 && self.w.integerValue >= 5) {//18德阳只显示学员端,又因为需要判断该用户是否存在坊主管理员身份以便确定不显示线下研修,所以如此操作(不能直接删除管理员身份)
//        return @"0";
//    }
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
- (NSString<Optional> *)roles {
    if (self.special.integerValue == 1 && self.w.integerValue >= 5) {
        return @"9";
    }else {
        return _roles;
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
    _startDate = currentDateString?:startDate;
}
- (void)setEndDate:(NSString<Optional> *)endDate {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormater dateFromString:endDate];
    [dateFormater setDateFormat:@"yyyy.MM.dd"];
    NSString *currentDateString = [dateFormater stringFromDate:date];
    _endDate = currentDateString?:endDate;
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
