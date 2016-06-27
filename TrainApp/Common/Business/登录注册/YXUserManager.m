//
//  YXUserManager.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXUserManager.h"
//#import "XGPush.h"
//#import "XGSetting.h"
#import "AppDelegate.h"

NSString *const YXUserLoginSuccessNotification = @"kYXUserLoginSuccessNotification";
NSString *const YXUserLogoutSuccessNotification = @"kYXUserLogoutSuccessNotification";

@implementation YXUserModel

//- (void)setUid:(NSString<Optional> *)uid {
//    _uid = uid;
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *pushStatusSettedKey = @"YXPushStatusSetted";
//    
//    if (([defaults objectForKey:pushStatusSettedKey]) && (![[[NSUserDefaults standardUserDefaults] objectForKey:@"YXPushNotification"] boolValue])) {
//        [XGPush unRegisterDevice];
//        return;
//    };
//    
//    if (!isEmpty(uid)) {
//        [XGPush unRegisterDevice];
//    }
//
//    DDLogError(@"uid : %@", uid);
//    // 信鸽bug ？异步调用unRegisterDevice永远没有回调
//    [self performSelector:@selector(regAfterUnReg) withObject:nil afterDelay:1];
//}
//
//- (void)regAfterUnReg {
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [XGPush setAccount:self.uid];
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if(sysVer < 8){
//        [appDelegate registerPush];
//    }
//    else{
//        [appDelegate registerPushForIOS8];
//    }
//#else
//    //iOS8之前注册push方法
//    //注册Push服务，注册后才能收到推送
//    [appDelegate registerPush];
//#endif
//}

@end

@implementation YXUserManager

+ (instancetype)sharedManager
{
    static YXUserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXUserManager alloc] init];
        [manager loadLocalUserData];
    });
    return manager;
}

- (void)saveUserData
{
    [NSKeyedArchiver archiveRootObject:self.userModel toFile:[self userDataPath]];
}

- (void)login
{
    [self saveUserData];
    [[NSNotificationCenter defaultCenter] postNotificationName:YXUserLoginSuccessNotification
                                                        object:nil];
}

- (void)logout
{
    [self resetUserData];
    [[NSNotificationCenter defaultCenter] postNotificationName:YXUserLogoutSuccessNotification
                                                        object:nil];

}

- (BOOL)isLogin
{
    return [self.userModel.token yx_isValidString];
}

#pragma mark -

// 重置用户数据
- (void)resetUserData
{
    self.userModel = nil;
    [NSKeyedArchiver archiveRootObject:self.userModel toFile:[self userDataPath]];
    [self initUserModel];
}

- (void)loadLocalUserData
{
    NSString *userDataPath = [self userDataPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:userDataPath]) {
        self.userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:userDataPath];
    }
    [self initUserModel];
}

- (NSString *)userDataPath
{
    return [NSString stringWithFormat:@"%@/userData.dat", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]];
}

- (void)initUserModel
{
    if (!self.userModel) {
        self.userModel = [[YXUserModel alloc] init];
    }
}

@end
