//
//  YXFileItemBase.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileItemBase.h"

@interface YXFileItemBase ()
@property (nonatomic, strong) id favorData;
@property (nonatomic, copy) void(^addFavorCompleteBlock)();
@end

@implementation YXFileItemBase

- (instancetype)init{
    if (self = [super init]) {
        self.type = YXFileTypeUnknown;
    }
    return self;
}

- (void)addFavorWithData:(id)data completion:(void(^)())completeBlock{
    self.favorData = data;
    self.addFavorCompleteBlock = completeBlock;
}

- (void)browseFile {
    if (self.isLocal) {
        [self openFile];
    }else {
        [self checkNetwork];
    }
}

- (void)openFile {
    
}

- (void)checkNetwork {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (![r isReachable]) {
        [self.baseViewController showToast:@"网络异常,请稍候重试"];
        return;
    }
    
    if ([r isReachableViaWWAN] && ![r isReachableViaWiFi]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"网络连接提示" message:@"当前处于非Wi-Fi环境，仍要继续吗？" preferredStyle:UIAlertControllerStyleAlert];
        WEAK_SELF
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            return;
        }];
        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF
            [self openFile];
        }];
        [alertVC addAction:backAction];
        [alertVC addAction:goAction];
        [[self.baseViewController visibleViewController] presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    [self openFile];
}

#pragma mark - YXBrowserExitDelegate
- (void)browserExit{
    if ([LSTSharedInstance sharedInstance].recordManager.isActive) {
        [[LSTSharedInstance sharedInstance].recordManager report];
    }
}
- (void)browserExitReport:(void(^)(BOOL isScuess))scuessBlock {
    
}

#pragma mark - YXPlayProgressDelegate
- (void)playerProgress:(CGFloat)progress totalDuration:(NSTimeInterval)duration stayTime:(NSTimeInterval)time{
    NSLog(@"12");
    if ([LSTSharedInstance sharedInstance].recordManager.isActive) {
        [[LSTSharedInstance sharedInstance].recordManager updateFragmentWithDuration:duration record:duration*progress watchedTime:time];
    }
    NSInteger min = time / 60;
    NSInteger sec = (NSInteger)time % 60;
    NSString *playTime = [NSString stringWithFormat:@"%02zd分:%02zd秒",min,sec];
    NSDictionary *dict = @{
                           @"时长": playTime
                           };
    if (self.sourceType == YXSourceTypeCourse) {
        [YXDataStatisticsManger trackEvent:@"课程播放" label:@"播放视频课程" parameters:dict];
    }
    if (self.sourceType == YXSourceTypeTaskNoUploadedVideos) {
        [YXDataStatisticsManger trackEvent:@"未上传视频操作" label:@"未上传时播放视频" parameters:dict];
    }
}
- (CGFloat)preProgress{
    if ([LSTSharedInstance sharedInstance].recordManager.isActive) {
        return [[LSTSharedInstance sharedInstance].recordManager preProgress];
    }
    return 0;
}
#pragma mark - YXBrowseTimeDelegate
- (void)browseTimeUpdated:(NSTimeInterval)time{
    if ([LSTSharedInstance sharedInstance].recordManager.isActive) {
        [[LSTSharedInstance sharedInstance].recordManager updateFragmentWithFileBrowseTime:time];
    }
}

#pragma mark - YXFileFavorDelegate
- (void)fileDidFavor{
    BLOCK_EXEC(self.addFavorCompleteBlock);
}

@end
