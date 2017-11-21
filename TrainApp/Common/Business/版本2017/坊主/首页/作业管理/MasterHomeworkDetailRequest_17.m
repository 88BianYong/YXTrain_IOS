//
//  MasterHomeworkDetailRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkDetailRequest_17.h"

@implementation MasterHomeworkDetailItem_Body_Template_Affixs
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

@implementation MasterHomeworkDetailItem_Body_Template

@end
@implementation MasterHomeworkDetailItem_Body_Require
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"requireId":@"requireid",
                                                                  @"templateId":@"templateid",
                                                                  @"descrip":@"description"}];
}
@end

@implementation MasterHomeworkDetailItem_Body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"homeworkId":@"id",
                                                                  @"projectId":@"projectid",
                                                                  @"stageId":@"stageid",
                                                                  @"userId":@"userid",
                                                                  @"templateId":@"templateid"
                                                                  }];
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

@implementation MasterHomeworkDetailItem
@end

@implementation MasterHomeworkDetailRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/homeworkDetail"];
    }
    return self;
}
@end
