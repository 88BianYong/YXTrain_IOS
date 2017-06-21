//
//  VideoBeginningView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/6/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, VideoBeginningStatus) {
    VideoBeginningStatus_Finish,//视频为空
    VideoBeginningStatus_NotWifi,//非wifi
    VideoBeginningStatus_PlayError,//播放出错
    VideoBeginningStatus_NetworkError,//网络出错
};


typedef void (^VideoBeginningViewBackBlock)(void);
typedef void (^VideoBeginningViewFinishBlock)(BOOL isSave);
@interface VideoBeginningView : UIView
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rotateButton;

- (void)setVideoBeginningViewBackBlock:(VideoBeginningViewBackBlock)block;
- (void)setVideoBeginningViewFinishBlock:(VideoBeginningViewFinishBlock)block;
- (void)viewWillAppear;
- (void)viewWillDisappear;
- (void)playVideoClear;
@end
