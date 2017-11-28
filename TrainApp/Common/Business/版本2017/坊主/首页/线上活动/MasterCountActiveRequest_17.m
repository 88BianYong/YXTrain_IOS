//
//  MasterCountActiveRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterCountActiveRequest_17.h"
@implementation  MasterCountActiveItem_Body_CountTool_Total
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"likeNum":@"zanNum",
                                            @"questionNum":@"wenjuanNum"
                                            }];
}
@end

@implementation MasterCountActiveItem_Body_CountTool
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"toolType":@"tooltype",
                                            @"toolId":@"toolid"
                                            }];
}
@end

@implementation MasterCountActiveItem_Body_CountMemeber_TotalArray
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"likeNum":@"zanNum",
                                            @"questionNum":@"wenjuanNum",
                                            @"toolType":@"tooltype",
                                            @"toolId":@"toolid"
                                            }];
}
- (void)setToolType:(NSString<Optional> *)toolType {
    if ([toolType isEqualToString:@"discuss"]) {
        _toolType = @"1";
    }else if ([toolType isEqualToString:@"vote"]) {
        _toolType = @"2";
    }else if ([toolType isEqualToString:@"resources"]) {
        _toolType = @"3";
    }else if ([toolType isEqualToString:@"wenjuan"]) {
        _toolType = @"4";
    }else if ([toolType isEqualToString:@"video"]) {
        _toolType = @"5";
    }
}
@end
@implementation MasterCountActiveItem_Body_CountMemeber
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"userName":@"username",
                                            @"userId":@"userid"
                                            }];
}
@end
@implementation MasterCountActiveItem_Body_Active
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"activeId":@"aid",
                                            @"stageId":@"stageid"
                                            }];
}

@end

@implementation MasterCountActiveItem_Body 
@end

@implementation MasterCountActiveItem
@end
@implementation MasterCountActiveRequest_17
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"aId":@"aid"
                                            }];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/countActive"];
    }
    return self;
}
@end
