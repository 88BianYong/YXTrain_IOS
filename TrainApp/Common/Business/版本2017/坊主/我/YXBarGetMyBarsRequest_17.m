//
//  YXBarGetMyBarsRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBarGetMyBarsRequest_17.h"
@implementation YXBarGetMyBarsRequestItem_Body_Bar : JSONModel
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"barId":@"id"}];
}
@end

@implementation YXBarGetMyBarsRequestItem_Body : JSONModel
@end

@implementation YXBarGetMyBarsRequestItem : HttpBaseRequestItem
@end
@implementation YXBarGetMyBarsRequest_17
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"club/bar/getMyBars"];
    }
    return self;
}
@end
