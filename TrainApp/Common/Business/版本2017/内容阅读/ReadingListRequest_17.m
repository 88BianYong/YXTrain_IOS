//
//  ReadingListRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ReadingListRequest_17.h"
@implementation ReadingListRequest_17Item_Objs_Affix
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"resname":@"resName",
                                                       @"convertstatus":@"convertStatus",
                                                       @"previewurl":@"previewUrl",
                                                       @"downloadurl":@"downloadUrl",
                                                       @"resid":@"resID"}];
}
@end
@implementation ReadingListRequest_17Item_Objs
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"objID",
                                                       @"isfinish":@"isFinish",
                                                       @"timelength":@"timeLength"}];
}
@end
@implementation ReadingListRequest_17Item_Scheme_Process
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"userfinishnum":@"userFinishNum",
                                                       @"userfinishscore":@"userFinishScore"}];
}
@end
@implementation ReadingListRequest_17Item_Scheme_Scheme
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"finishnum":@"finishNum",
                                                       @"finishscore":@"finishScore",
                                                       @"toolid":@"toolID"}];
}
@end
@implementation ReadingListRequest_17Item_Scheme

@end
@implementation ReadingListRequest_17Item
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"isfinish":@"isFinish"}];
}
@end

@implementation ReadingListRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"projectid":@"projectID",
                                                       @"stageid":@"stageID",
                                                       @"toolid":@"toolID"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/reading/list"];
        self.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    }
    return self;
}
@end
