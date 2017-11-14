//
//  YXVideoRecordManager.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXVideoRecordManager.h"
#import "YXHomeworkInfoRequest.h"
#import "YXAlertView.h"
#include <sys/stat.h>
#include <sys/mount.h>
#include <sys/sysctl.h>
#include <arpa/inet.h>
@implementation YXVideoRecordManager
+ (BOOL)isEnoughDeviceSpace
{
    if ([[self freeSpace] longLongValue] < 200 * 1024 *1024) {
        return NO;
    }
    return YES;
}

+ (BOOL)isSupportRecordVideoShowView:(UIView *)view
{
    __block BOOL isSupport = NO;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied
            || authStatus == AVAuthorizationStatusRestricted) {
            WEAK_SELF
            YXAlertView *alertView = [YXAlertView alertViewWithTitle:@"无法访问相机" message:@"请到“设置->隐私->相机”中设置为允许访问相机！"];
            [alertView addButtonWithTitle:@"确定" action:^{
                STRONG_SELF
              isSupport = [self isSupportMicrophoneShow:view];
            }];
            [alertView show];
        }else{
            isSupport = [self isSupportMicrophoneShow:view];
        }
    } else {
        [YXPromtController showToast:@"设备不支持拍照功能！" inView:view];
        isSupport = NO;
    }
    return isSupport;
}
+ (BOOL)isSupportMicrophoneShow:(UIView *)view
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        YXAlertView *alertView = [YXAlertView alertViewWithTitle:@"无法访问麦克风" message:@"请到“设置->隐私->麦克风”中设置为允许访麦克风！"];
                        [alertView addButtonWithTitle:@"确定"];
                        [alertView show];
                    });
                }
            }];
        }
    }
    return bCanRecord;
}

+ (void)saveVideoArrayWithModel:(YXHomeworkInfoRequestItem_Body *)model
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray * videoArray = [user objectForKey:kYXTrainVideoUserDefaultsKey];
    __block YXHomeworkInfoRequestItem_Body *hasModel = nil;
    [videoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXHomeworkInfoRequestItem_Body *tempModel = [[YXHomeworkInfoRequestItem_Body alloc] initWithDictionary:obj error:nil];
        if (tempModel.requireId == model.requireId && tempModel.uid == model.uid) {
           hasModel = obj;
        }
    }];
    
    NSMutableArray *newVideoArray = [NSMutableArray arrayWithArray:videoArray];
    if (hasModel) {
        [newVideoArray removeObject:hasModel];
    }
    
    NSDictionary *videoMulDict = model.toDictionary;
    [newVideoArray addObject:videoMulDict];
    
    [user setObject:newVideoArray forKey:kYXTrainVideoUserDefaultsKey];
    [user synchronize];
}

+ (void)deleteVideoWithModel:(YXHomeworkInfoRequestItem_Body *)model
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray * videoArray = [user objectForKey:kYXTrainVideoUserDefaultsKey];
    __block YXHomeworkInfoRequestItem_Body *hasModel = nil;
    [videoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXHomeworkInfoRequestItem_Body *tempModel = [[YXHomeworkInfoRequestItem_Body alloc] initWithDictionary:obj error:nil];
        if (tempModel.requireId == model.requireId && tempModel.uid == model.uid) {
            hasModel = obj;
        }
    }];
    
    NSMutableArray *newVideoArray = [NSMutableArray arrayWithArray:videoArray];
    if (hasModel) {
        [newVideoArray removeObject:hasModel];
    }
    if (newVideoArray.count == 0) {
        [user setObject:nil forKey:kYXTrainVideoUserDefaultsKey];
    }else{
        [user setObject:newVideoArray forKey:kYXTrainVideoUserDefaultsKey];
    }
    [user synchronize];
}

+ (NSArray *)getVideoArrayWithModel
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray * videoArray = [user objectForKey:kYXTrainVideoUserDefaultsKey];
    __block NSMutableArray * newVideoArray = [NSMutableArray array];
    [videoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXHomeworkInfoRequestItem_Body *model = [[YXHomeworkInfoRequestItem_Body alloc] initWithDictionary:obj error:nil];
        [newVideoArray addObject:model];
    }];
    return newVideoArray;
}
+ (void)clearVideoArray{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray * videoArray = [user objectForKey:kYXTrainVideoUserDefaultsKey];
    [videoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXHomeworkInfoRequestItem_Body *model = [[YXHomeworkInfoRequestItem_Body alloc] initWithDictionary:obj error:nil];
        NSString *localPath = [PATH_OF_VIDEO stringByAppendingPathComponent:model.fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
            if ([[NSFileManager defaultManager] removeItemAtPath:localPath error:nil]){
                
            }
        }
    }];
    
    [user setObject:nil forKey:kYXTrainVideoUserDefaultsKey];
    [user synchronize];
}

+ (void)cleartmpFile
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSArray * subPaths = [manger subpathsAtPath:[YXVideoRecordManager tmpPath]];
    [subPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *pathString = obj;
        if ([[pathString pathExtension] isEqualToString:@"mp4"]) {
            NSString *fullsubpath = [[YXVideoRecordManager tmpPath] stringByAppendingPathComponent:pathString];
            BOOL dir = NO;
            [manger fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) { // 子路径是个文件
                [manger removeItemAtPath:fullsubpath error:nil];
            }
        }
    }];
}

+ (NSString *)tmpPath
{
    return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}

+ (NSString *)getFileNameWithJobId:(NSString *)jojid
{
    return [[LSTSharedInstance sharedInstance].userManger.userModel.uid stringByAppendingString:jojid];
}


+ (NSNumber *)freeSpace{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/private/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    // freespace/1024/1024/1024 = B/KB/MB/14.02GB
    return @(freespace);
}

+ (NSNumber *)totalSpace{
    struct statfs buf;
    long long totalspace = -1;
    if(statfs("/private/var", &buf) >= 0){
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    return @(totalspace);
}


+ (CGFloat)videoTimeLenghtForFilePath:(NSString *)filePath {
    AVURLAsset *mp4Asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    CMTime itmeTime = mp4Asset.duration;
    CGFloat durationTime = CMTimeGetSeconds(itmeTime);
    return durationTime;
}

@end
