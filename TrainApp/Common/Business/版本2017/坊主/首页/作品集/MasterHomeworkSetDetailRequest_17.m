//
//  MasterHomeworkSetDetailRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkSetDetailRequest_17.h"
@implementation MasterHomeworkSetDetailItem_Template_Affix 
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"resId":@"resid",
                                            @"resName":@"resname",
                                            @"previewUrl":@"previewurl",
                                            @"downloadUrl":@"previewurl",
                                            @"convertStatus":@"convertstatus"
                                            }];
}
@end

@implementation MasterHomeworkSetDetailItem_Body_Template
@end

@implementation MasterHomeworkSetDetailItem_Body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"homeworkId":@"homeworkid",
                                                                  @"templateId":@"templateid"}];
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

@implementation MasterHomeworkSetDetailItem

@end
@implementation MasterHomeworkSetDetailRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/homeworkSet/homeworkDetail"];
    }
    return self;
}
@end
