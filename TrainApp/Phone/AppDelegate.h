//
//  AppDelegate.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXProvincesRequest.h"
#import "YXStageAndSubjectRequest.h"
#import "YXCheckRequest.h"
#import "AppDelegateHelper.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) YXProvincesRequest *provincesRequest;
@property (nonatomic, strong) YXStageAndSubjectRequest *stageAndSubjectRequest;
@property (nonatomic ,strong) YXCheckRequest *checkRequest;
@property (nonatomic, strong) AppDelegateHelper *appDelegateHelper;
@end

