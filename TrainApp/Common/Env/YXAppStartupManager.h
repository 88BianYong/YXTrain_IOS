//
//  YXAppStartupManager.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 1/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXAppStartupManager : NSObject
+ (YXAppStartupManager *)sharedInstance;
@property (nonatomic, readonly) UIWindow *window;

/**
 * UIApplicationDelegate, didFinishLaunchingWithOptions中调用，
 */
- (void)setupForAppdelegate:(id)appdelegate withLauchOptions:(NSDictionary *)options;
//- (void)resetAPNSWithAccount:(NSString *)account;
@end
