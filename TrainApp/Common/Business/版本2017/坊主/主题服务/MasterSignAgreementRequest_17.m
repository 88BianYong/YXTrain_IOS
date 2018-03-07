//
//  MasterSignAgreementRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/3/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MasterSignAgreementRequest_17.h"

@implementation MasterSignAgreementRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/signAgreement"];
        self.roleId = [LSTSharedInstance sharedInstance].trainManager.currentProject.role;
    }
    return self;
}
@end
