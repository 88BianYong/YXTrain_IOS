//
//  ActivityPlayManagerView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityToolVideoRequest.h"
typedef NS_ENUM(NSInteger, ActivityPlayManagerStatus) {
    ActivityPlayManagerStatus_Unknown,//外部链接
    ActivityPlayManagerStatus_Empty,//视频为空
    ActivityPlayManagerStatus_NotWifi,//非wifi
    ActivityPlayManagerStatus_PlayError,//播放出错
    ActivityPlayManagerStatus_NetworkError,//网络出错
    ActivityPlayManagerStatus_DataError,//数据出错
};

typedef void (^ActivityPlayManagerBackActionBlock)(void);
typedef void (^ActivityPlayManagerRotateScreenBlock)(BOOL isVertical);
typedef void (^ActivityPlayManagerPlayVideoBlock)(ActivityPlayManagerStatus status);

@interface ActivityPlayManagerView : UIView
@property (nonatomic, assign) BOOL isFullscreen;
@property (nonatomic, strong) ActivityToolVideoRequestItem_Body_Content *content;
@property (nonatomic, assign) ActivityPlayManagerStatus playStatus;

- (void)setActivityPlayManagerBackActionBlock:(ActivityPlayManagerBackActionBlock)block;
- (void)setActivityPlayManagerRotateScreenBlock:(ActivityPlayManagerRotateScreenBlock)block;
- (void)setActivityPlayManagerPlayVideoBlock:(ActivityPlayManagerPlayVideoBlock)block;
- (void)viewWillAppear;
- (void)viewWillDisappear;

- (void)playVideoClear;
@end
