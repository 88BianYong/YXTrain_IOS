//
//  YXConfigManager.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXConfigManager.h"
#import <FCUUID.h>
#import <UIDevice+HardwareName.h>

@implementation YXConfigManager

+ (YXConfigManager *)sharedInstance {
    NSAssert([YXConfigManager class] == self, @"Incorrect use of singleton : %@, %@", [YXConfigManager class], [self class]);
    static dispatch_once_t once;
    static YXConfigManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithConfigFile:@"YXConfig"];
        [sharedInstance setupServerEnv];
    });
    
    return sharedInstance;
}

- (id)initWithConfigFile:(NSString *)filename {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filepath];
    NSError *error = nil;
    self = [super initWithDictionary:dict error:&error];
    if (error) {
        // make sure works even without a config plist
        self = [super init];
    }
    return self;
}

- (void)setupServerEnv {
    NSString *envPath = [[NSBundle mainBundle]pathForResource:@"env_config" ofType:@"json"];
    NSData *envData = [NSData dataWithContentsOfFile:envPath];
    NSDictionary *envDic = [NSJSONSerialization JSONObjectWithData:envData options:kNilOptions error:nil];
    self.server = [envDic valueForKey:@"server"];
    self.loginServer = [envDic valueForKey:@"loginServer"];
    self.uploadServer = [envDic valueForKey:@"uploadServer"];
    self.websocketServer = [envDic valueForKey:@"websocketServer"];
    self.mode = [envDic valueForKey:@"mode"];
    self.geTuiAppId = [envDic valueForKey:@"geTuiAppId"];
    self.geTuiAppKey = [envDic valueForKey:@"geTuiAppKey"];
    self.geTuiAppServer = [envDic valueForKey:@"geTuiAppServer"];
    DDLogDebug(@"server env : %@",envDic);
}

#pragma mark - properties
- (NSString *)server {
    if ([_server hasSuffix:@"/"]) {
        return _server;
    } else {
        return [_server stringByAppendingString:@"/"];
    }
}

- (NSString *)appName {
    if (!_appName) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _appName = [infoDictionary objectForKey:@"CFBundleName"];
    }
    return _appName;
}

- (NSString *)clientVersion {
    if (!_clientVersion) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _clientVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return _clientVersion;
}

- (NSString *)deviceID {
    return [FCUUID uuidForDevice];
}

- (NSString *)deviceType {
    if (!_deviceType) {
        _deviceType = [[UIDevice currentDevice] platform];
    }
    return _deviceType;
}

- (NSString *)osType {
    return @"ios";
}

- (NSString *)osVersion {
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)deviceName {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"iPad";
    } else {
        return @"iPhone";
    }
}

@end
