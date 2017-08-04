//
//  VideoPlayManagerView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoClassworkManager.h"
#import "ActivityPlayTopView.h"
#import "LePlayer.h"
#import "LePlayerView.h"
#import "ActivityPlayBottomView.h"
typedef NS_ENUM(NSInteger, VideoPlayManagerStatus) {
    VideoPlayManagerStatus_Finish,//视频完成
    VideoPlayManagerStatus_Empty,//视频为空
    VideoPlayManagerStatus_NotWifi,//非wifi
    VideoPlayManagerStatus_PlayError,//播放出错
    VideoPlayManagerStatus_NetworkError,//网络出错
    VideoPlayManagerStatus_DataError,//数据出错
};
typedef void (^VideoPlayManagerViewBackActionBlock)(void);
typedef void (^VideoPlayManagerViewRotateScreenBlock)(BOOL isVertical);
typedef void (^VideoPlayManagerViewPlayVideoBlock)(VideoPlayManagerStatus status);
typedef void (^VideoPlayManagerViewFinishBlock)(void);

@interface VideoPlayManagerView : UIView
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) LePlayerView *playerView;
@property (nonatomic, strong) ActivityPlayBottomView *bottomView;
@property (nonatomic, strong) ActivityPlayTopView *topView;
@property (nonatomic, strong) UIImageView *thumbImageView;

@property (nonatomic, assign) VideoPlayManagerStatus playStatus;
@property (nonatomic, assign) BOOL isFullscreen;
@property (nonatomic, assign) BOOL isBeginPlayEnd;
@property (nonatomic, strong) YXFileItemBase *fileItem;
@property (nonatomic, weak) id<YXPlayProgressDelegate> delegate;
@property (nonatomic, weak) id<YXBrowserExitDelegate> exitDelegate;
@property (nonatomic ,weak) VideoClassworkManager *classworkManager;
@property (nonatomic, assign) BOOL isShowTop;//TBD:双层控制播放 需要优化

@property (nonatomic, assign) NSTimeInterval playTotalTime;




- (void)setVideoPlayManagerViewBackActionBlock:(VideoPlayManagerViewBackActionBlock)block;
- (void)setVideoPlayManagerViewRotateScreenBlock:(VideoPlayManagerViewRotateScreenBlock)block;
- (void)setVideoPlayManagerViewPlayVideoBlock:(VideoPlayManagerViewPlayVideoBlock)block;
- (void)setVideoPlayManagerViewFinishBlock:(VideoPlayManagerViewFinishBlock)block;
- (void)viewWillAppear;
- (void)viewWillDisappear;
- (void)playVideoClear;

- (void)playReport:(void(^)(BOOL isSuccess))block;
@end
