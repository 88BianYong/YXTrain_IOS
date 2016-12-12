//
//  YXAppStartupManager.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 1/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXAppStartupManager.h"

@interface YXAppStartupManager ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, strong) NSTimer *backgroundTimer;
@end

@implementation YXAppStartupManager

+ (YXAppStartupManager *)sharedInstance {
    NSAssert([YXAppStartupManager class] == self, @"Incorrect use of singleton : %@, %@", [YXAppStartupManager class], [self class]);
    static dispatch_once_t once;
    static YXAppStartupManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)setupForAppdelegate:(id)appdelegate withLauchOptions:(NSDictionary *)options {
    [GlobalUtils setupCore];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    self.window = [appdelegate window];
    self.delegate = appdelegate;
    
    NSArray *deliveredMethodArray = @[@"applicationWillTerminate:",
                                      @"applicationDidEnterBackground:"
                                      ];
    for (NSString *selectorName in deliveredMethodArray) {
        SEL selector = NSSelectorFromString(selectorName);
        [GlobalUtils deliverSelector:selector fromObject:appdelegate toObject:self];
    }

}

#pragma mark - GlobalUtils相关
- (void)applicationWillTerminate:(UIApplication *)application {
    [GlobalUtils clearCore];
}
#pragma mark - 看课记录后台上报
- (void)applicationDidEnterBackground:(UIApplication *)application{
    if ([YXRecordManager sharedManager].isActive) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kRecordNeedUpdateNotification object:nil];
        [[YXRecordManager sharedManager]report];
        WEAK_SELF
        self.backgroundTaskIdentifier =[application beginBackgroundTaskWithExpirationHandler:^(void) {
            STRONG_SELF
            [self.backgroundTimer invalidate];
            self.backgroundTimer = nil;
            [self endBackgroundTask];
        }];
        self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishRecordTimer) name:kRecordReportCompleteNotification object:nil];
    }
}
- (void)endBackgroundTask{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    @weakify(self);
    dispatch_async(mainQueue, ^(void) {
        @strongify(self);
        if (self != nil){
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            // 销毁后台任务标识符
            self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    });
}
- (void)finishRecordTimer {
    [self.backgroundTimer invalidate];
    self.backgroundTimer = nil;
    if (self.backgroundTaskIdentifier) {
        [self endBackgroundTask];
    }
}

- (void)timerMethod:(NSTimer *)paramSender{
    // backgroundTimeRemaining 属性包含了程序留给的我们的时间
    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX){
        DDLogDebug(@"Background Time Remaining = Undetermined");
    } else {
        DDLogDebug(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
    }
}
@end
