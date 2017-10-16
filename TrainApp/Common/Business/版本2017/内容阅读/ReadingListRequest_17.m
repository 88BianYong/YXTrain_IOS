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
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"resName":@"resname",
                                                                  @"convertStatus":@"convertstatus",
                                                                  @"previewUrl":@"previewurl",
                                                                  @"downloadUrl":@"downloadurl",
                                                                  @"resID":@"resid"}];
}
@end
@implementation ReadingListRequest_17Item_Objs
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objID":@"id",
                                                                  @"isFinish":@"isfinish",
                                                                  @"timeLength":@"timelength"}];
}
@end
@implementation ReadingListRequest_17Item_Scheme_Process
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"userFinishNum":@"userfinishnum",
                                                                  @"userFinishScore":@"userfinishscore"}];
}
@end
@implementation ReadingListRequest_17Item_Scheme_Scheme
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"finishNum":@"finishnum",
                                                                  @"finishScore": @"finishscore",
                                                                  @"toolID":@"toolid"}];
}
@end
@implementation ReadingListRequest_17Item_Scheme

@end
@implementation ReadingListRequest_17Item
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"isFinish":@"isfinish"}];
}
@end

@implementation ReadingListRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"projectID":@"projectid",
                                                                  @"stageID":@"stageid",
                                                                  @"toolID":@"toolid",
                                                                  @"themeID":@"themeid",
                                                                  @"layerID":@"layerid"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/reading/list"];
        self.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
        self.themeID= [LSTSharedInstance sharedInstance].trainManager.currentProject.themeId;
        self.layerID = [LSTSharedInstance sharedInstance].trainManager.currentProject.layerId;
    }
    return self;
}
@end
