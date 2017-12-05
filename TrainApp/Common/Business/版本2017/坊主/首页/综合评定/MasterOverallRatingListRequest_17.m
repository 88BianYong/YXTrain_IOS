//
//  MasterOverallRatingListRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOverallRatingListRequest_17.h"
@implementation MasterOverallRatingListItem_Body_Bar
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"barId":@"barid"}];
}
@end

@implementation MasterOverallRatingListItem_Body_UserScore
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"userId":@"userid"}];
}
- (NSString<Ignore> *)sortName {
    return [self formatSortName:self.userName.copy];
}
- (NSString *)formatSortName:(NSString *)originalString {
    if ([originalString hasPrefix:@"沈"]) {
        originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"神"];
    }else if ([originalString hasPrefix:@"曾"]) {
        originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"增"];
        
    }else if ([originalString hasPrefix:@"仇"]) {
        originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"求"];
        
    }else if ([originalString hasPrefix:@"单"]) {
        originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"闪"];
        
    }else if ([originalString hasPrefix:@"重"]) {
        originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"冲"];
        
    }else if ([originalString hasPrefix:@"区"]) {
        originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"哦"];
        
    }else if ([originalString hasPrefix:@"冼"]) {
        originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"先"];
        
    }else if ([originalString hasPrefix:@"解"]) {
        originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"写"];
        
    }else if ([originalString hasPrefix:@"朴"]) {
        originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"票"];
        
    }else if ([originalString hasPrefix:@"翟"]) {
        originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"窄"];
    }
    else if ([originalString hasPrefix:@"查"]) {
        originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"渣"];
    }
    return originalString;
}
@end

@implementation MasterOverallRatingListItem_Body_CountUser

@end

@implementation MasterOverallRatingListItem_Body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"userScores":@"userSocres"}];
}
@end

@implementation MasterOverallRatingListItem 
@end


@implementation MasterOverallRatingListRequest_17
- (instancetype)init{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/overallRating/list"];
        self.page = @"1";
        self.pageSize = @"9999";
    }
    return self;
}
@end
