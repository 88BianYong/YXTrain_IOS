//
//  YXPlayerBeginningView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPlayerBeginningView.h"
#import "YXPlayerManagerView.h"
#import "YXPlayerBufferingView.h"
#import "ActivityPlayExceptionView.h"
#import "VideoBeginningTopView.h"
@interface YXPlayerBeginningView ()
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) LePlayerView *playerView;
@property (nonatomic, strong) YXPlayerBufferingView *bufferingView;
@property (nonatomic, strong) ActivityPlayExceptionView *exceptionView;
@property (nonatomic, strong) VideoBeginningTopView *topView;
@property (nonatomic, strong) UIButton *rotateButton;


@property (nonatomic, strong) RACDisposable *disposable;

@property (nonatomic, assign) YXPlayerManagerPauseStatus pauseStatus;
@property (nonatomic, assign) YXPlayerManagerAbnormalStatus playerStatus;
@property (nonatomic, assign) BOOL isWifiPlayer;//WIFI先允许播放


@end
@implementation YXPlayerBeginningView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self setupUI];
        [self setupLayout];
        [self setupObserver];
        [self setupNotification];
    }
    return self;
}
#pragma mark - set 
- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        self.playerStatus = YXPlayerManagerAbnormal_NetworkError;
        return;
    }
    self.player.videoUrl = _videoUrl;
    self.isWifiPlayer = NO;
    if ([[Reachability reachabilityForInternetConnection] isReachableViaWWAN]) {
        [self.player pause];
        self.playerStatus = YXPlayerManagerAbnormal_NotWifi;
    }
}
- (void)setPlayerStatus:(YXPlayerManagerAbnormalStatus)playerStatus {
    _playerStatus = playerStatus;
    self.exceptionView.hidden = NO;
    if (_playerStatus == YXPlayerManagerAbnormal_NetworkError) {
        self.exceptionView.exceptionLabel.text = @"当前为非wifi网络,继续播放会产生流量费用";
        [self.exceptionView.exceptionButton setTitle:@"继续观看" forState:UIControlStateNormal];
        
    }else if (_playerStatus == YXPlayerManagerAbnormal_NotWifi) {
        self.exceptionView.exceptionLabel.text = @"当前为非wifi网络,继续播放会产生流量费用";
        [self.exceptionView.exceptionButton setTitle:@"继续观看" forState:UIControlStateNormal];
        
    }
}
- (void)setPauseStatus:(YXPlayerManagerPauseStatus)pauseStatus {
    _pauseStatus = pauseStatus;
    if (_pauseStatus == YXPlayerManagerPause_Not) {
        [self.player play];
    }else {
        [self.player pause];
    }
}
- (void)setIsFullscreen:(BOOL)isFullscreen {
    _isFullscreen = isFullscreen;
    if (!_isFullscreen) {
        [self.rotateButton setImage:[UIImage imageNamed:@"放大按钮"] forState:UIControlStateNormal];
    }else {
        [self.rotateButton setImage:[UIImage imageNamed:@"缩小按钮-"] forState:UIControlStateNormal];
    }
    self.exceptionView.backButton.hidden = !_isFullscreen;
    self.topView.hidden = !_isFullscreen;
}
#pragma mark - setupUI
- (void)setupUI {
    self.player = [[LePlayer alloc] init];
    self.playerView = (LePlayerView *)[self.player playerViewWithFrame:CGRectZero];
    [self addSubview:self.playerView];
    
    self.bufferingView = [[YXPlayerBufferingView alloc] init];
    [self addSubview:self.bufferingView];
    WEAK_SELF
    self.topView = [[VideoBeginningTopView alloc] init];
    [[self.topView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.playerBeginningBackActionBlock);
    }];
    self.topView.hidden = YES;
    [self addSubview:self.topView];
    
    self.rotateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rotateButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    self.rotateButton.layer.cornerRadius = 15.0f;
    [self.rotateButton setImage:[UIImage imageNamed:@"放大按钮"] forState:UIControlStateNormal];
    [[self.rotateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.playerBeginningRotateActionBlock);
    }];
    [self addSubview:self.rotateButton];
    
    self.exceptionView = [[ActivityPlayExceptionView alloc] init];
    [[self.exceptionView.exceptionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if ([[Reachability reachabilityForInternetConnection] isReachable]) {
            self.isWifiPlayer = YES;
            [self.player play];
            self.exceptionView.hidden = YES;
        }else {
            self.exceptionView.hidden = NO;
        }
    }];
    [[self.exceptionView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.playerBeginningBackActionBlock);
    }];
    self.exceptionView.hidden = YES;
    [self addSubview:self.exceptionView];
}
- (void)setupLayout {
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bufferingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(100.0f, 100.0f));
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.mas_offset(44.0f);
    }];
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30.0f, 30.0f));
        make.bottom.equalTo(self.mas_bottom).offset(-7.0f);
        make.right.equalTo(self.mas_right).offset(-7.0f);
    }];
    [self.exceptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - notification
- (void)setupObserver {
    WEAK_SELF
    [Reachability reachabilityForInternetConnection].reachableBlock = ^(Reachability *reachability) {
        STRONG_SELF
        if([reachability isReachableViaWWAN]) {
            if (self.playerStatus == YXPlayerManagerAbnormal_NetworkError) {
                self.playerStatus = YXPlayerManagerAbnormal_NotWifi;
            }
        }
    };
    [Reachability reachabilityForInternetConnection].unreachableBlock = ^(Reachability *reachability) {
        if (self.playerStatus == YXPlayerManagerAbnormal_NotWifi) {
            self.playerStatus = YXPlayerManagerAbnormal_NetworkError;
        }
    };
    [[Reachability reachabilityForInternetConnection] startNotifier];
    self.disposable = [RACObserve(self.player, state) subscribeNext:^(id x) {
        STRONG_SELF
        if (self.player.isBuffering) {
            self.bufferingView.hidden = NO;
            [self.bufferingView start];
        } else {
            self.bufferingView.hidden = YES;
            [self.bufferingView stop];
        }
        if ([x unsignedIntegerValue] == PlayerView_State_Playing) {
            DDLogDebug(@"播放");
        } else if ([x unsignedIntegerValue] == PlayerView_State_Finished)  {
            [self playVideoClear];
            BLOCK_EXEC(self.playerBeginningFinishActionBlock,YES);
        }else if ([x unsignedIntegerValue] == PlayerView_State_Error) {
            [self playVideoClear];
            BLOCK_EXEC(self.playerBeginningFinishActionBlock,NO);
        }else if ([x unsignedIntegerValue] == PlayerView_State_Buffering) {
            if ([[Reachability reachabilityForInternetConnection] isReachable]) {
                if([[Reachability reachabilityForInternetConnection] isReachableViaWWAN] && !self.isWifiPlayer) {
                    self.pauseStatus = YXPlayerManagerPause_Abnormal;
                    self.playerStatus = YXPlayerManagerAbnormal_NotWifi;
                }else {
                    self.exceptionView.hidden = YES;
                    self.pauseStatus = YXPlayerManagerPause_Not;
                }
            }else {
                self.playerStatus = YXPlayerManagerAbnormal_NetworkError;
                self.pauseStatus = YXPlayerManagerPause_Abnormal;
            }
        }
    }];
}
- (void)setupNotification {
    WEAK_SELF
    //显示文档
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainStartStopVideo object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        if (self.self.pauseStatus == YXPlayerManagerPause_Next || self.pauseStatus == YXPlayerManagerPause_Not) {
            if ([x.object boolValue]) {
                self.pauseStatus = YXPlayerManagerPause_Next;
            }else {
                self.pauseStatus = YXPlayerManagerPause_Not;
            }
        }
    }];
    
    //进入后台
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        if (self.pauseStatus == YXPlayerManagerPause_Not) {
            self.pauseStatus = YXPlayerManagerPause_Backstage;
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.pauseStatus == YXPlayerManagerPause_Backstage) {
            self.pauseStatus = YXPlayerManagerPause_Not;
        }
    }];
    
    //进入下一界面
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainPlayCourseNext object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        if (self.self.pauseStatus == YXPlayerManagerPause_Next || self.pauseStatus == YXPlayerManagerPause_Not) {
            if ([x.object boolValue]) {
                self.pauseStatus = YXPlayerManagerPause_Next;
            }else {
                self.pauseStatus = YXPlayerManagerPause_Not;
            }
        }
    }];
}
- (void)playVideoClear {
    self.player = nil;
    [self.disposable dispose];
    [self removeFromSuperview];
}
@end
