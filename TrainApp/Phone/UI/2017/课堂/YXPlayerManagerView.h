//
//  YXPlayerManagerView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityPlayTopView.h"
#import "LePlayer.h"
#import "LePlayerView.h"
#import "ActivityPlayBottomView.h"
#import "ActivitySlideProgressView.h"
typedef NS_ENUM(NSInteger, YXPlayerManagerPauseStatus) {
    YXPlayerManagerPause_Not = 0,//未暂停
    YXPlayerManagerPause_Manual = 1,//手动暂停
    YXPlayerManagerPause_Backstage = 2,//退入后台暂停
    YXPlayerManagerPause_Next = 3,//进入下一界面
    YXPlayerManagerPause_Test = 4,//显示测试
    YXPlayerManagerPause_Abnormal = 5,//异常界面
    YXPlayerManagerPause_Beginning = 6//显示片头
};
typedef NS_ENUM(NSInteger, YXPlayerManagerAbnormalStatus) {
    YXPlayerManagerAbnormal_Finish,//视频完成
    YXPlayerManagerAbnormal_Empty,//视频为空
    YXPlayerManagerAbnormal_NotWifi,//非wifi
    YXPlayerManagerAbnormal_PlayError,//播放出错
    YXPlayerManagerAbnormal_NetworkError,//网络出错
    YXPlayerManagerAbnormal_DataError,//数据出错
};
@interface YXPlayerManagerView : UIView
//播放视图相关
@property (nonatomic, strong) YXFileItemBase *fileItem;
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) LePlayerView *playerView;
@property (nonatomic, strong) ActivityPlayBottomView *bottomView;
@property (nonatomic, strong) ActivitySlideProgressView *slideProgressView;
@property (nonatomic, strong) ActivityPlayTopView *topView;
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, assign) BOOL isFullscreen;

//播放相关时间
@property (nonatomic, assign) NSTimeInterval playTime;

//播放相关状态
@property (nonatomic, assign) YXPlayerManagerPauseStatus pauseStatus;
@property (nonatomic, assign) YXPlayerManagerAbnormalStatus playerStatus;
@property (nonatomic, assign) BOOL isWifiPlayer;//WIFI先允许播放


@property (nonatomic, copy) void (^playerManagerBackActionBlock)(void);
@property (nonatomic, copy) void (^playerManagerRotateActionBlock)(void);
@property (nonatomic, copy) void (^playerManagerSlideActionBlock)(CGFloat playerTime, BOOL isReset);
@property (nonatomic, copy) void (^playerManagerPlayerActionBlock)(YXPlayerManagerAbnormalStatus status);
@property (nonatomic, copy) void (^playerManagerFinishActionBlock)(void);

- (void)playVideoClear;
@end
