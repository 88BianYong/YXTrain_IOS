//
//  MasterIndexRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterIndexRequest_17.h"
@implementation MasterIndexRequestItem_Body_Modules_Extend
@end
@implementation MasterIndexRequestItem_Body_MyExamine_Types_Detail
@end

@implementation MasterIndexRequestItem_Body_MyExamine_Types
@end

@implementation MasterIndexRequestItem_Body_MyExamine
@end

@implementation MasterIndexRequestItem_Body_Modules

@end
@implementation MasterIndexRequestItem_Body_CountBars
@end

@implementation MasterIndexRequestItem_Body
//- (void)setModules:(NSMutableArray<MasterIndexRequestItem_Body_Modules,Optional> *)modules {
//        NSMutableArray<MasterIndexRequestItem_Body_Modules,Optional> *mutableArray = [[NSMutableArray<MasterIndexRequestItem_Body_Modules,Optional> alloc] init];
//    [modules enumerateObjectsUsingBlock:^(MasterIndexRequestItem_Body_Modules *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.iconStatus.integerValue != 0) {
//            [mutableArray addObject:obj];
//        }
//    }];
//    _modules = mutableArray;
//}

@end

@implementation MasterIndexRequestItem

@end
@implementation MasterIndexRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"projectID":@"projectId"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/index"];
    }
    return self;
}
@end
