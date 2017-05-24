//
//  VideoPlayManagerView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, VideoPlayManagerStatus) {
    VideoPlayManagerStatus_Empty,//视频为空
    VideoPlayManagerStatus_NotWifi,//非wifi
    VideoPlayManagerStatus_PlayError,//播放出错
    VideoPlayManagerStatus_NetworkError,//网络出错
    VideoPlayManagerStatus_DataError,//数据出错
};
typedef void (^VideoPlayManagerViewBackActionBlock)(void);
typedef void (^VideoPlayManagerViewRotateScreenBlock)(BOOL isVertical);
typedef void (^VideoPlayManagerViewPlayVideoBlock)(VideoPlayManagerStatus status);
typedef void (^VideoPlayManagerViewFinishBlock)();

@interface VideoPlayManagerView : UIView
@property (nonatomic, assign) VideoPlayManagerStatus playStatus;
@property (nonatomic, assign) BOOL isFullscreen;
@property (nonatomic, strong) YXFileItemBase *fileItem;
@property (nonatomic, weak) id<YXPlayProgressDelegate> delegate;
@property (nonatomic, weak) id<YXBrowserExitDelegate> exitDelegate;


- (void)setVideoPlayManagerViewBackActionBlock:(VideoPlayManagerViewBackActionBlock)block;
- (void)setVideoPlayManagerViewRotateScreenBlock:(VideoPlayManagerViewRotateScreenBlock)block;
- (void)setVideoPlayManagerViewPlayVideoBlock:(VideoPlayManagerViewPlayVideoBlock)block;
- (void)setVideoPlayManagerViewFinishBlock:(VideoPlayManagerViewFinishBlock)block;
- (void)viewWillAppear;
- (void)viewWillDisappear;
- (void)playVideoClear;
@end
