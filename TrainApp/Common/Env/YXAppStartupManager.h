//
//  YXAppStartupManager.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 1/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YXLoginDelegate <NSObject>
@optional
- (void)loginSuccess;
- (void)logoutSuccess;
- (void)tokenInvalid;
@end

@interface YXAppStartupManager : NSObject
+ (YXAppStartupManager *)sharedInstance;
@property (nonatomic, readonly) UIWindow *window;
@property (nonatomic, weak) id<YXLoginDelegate> delegate;

/**
 * UIApplicationDelegate, didFinishLaunchingWithOptions中调用，
 */
- (void)setupForAppdelegate:(id)appdelegate withLauchOptions:(NSDictionary *)options;
//- (void)resetAPNSWithAccount:(NSString *)account;

@end
