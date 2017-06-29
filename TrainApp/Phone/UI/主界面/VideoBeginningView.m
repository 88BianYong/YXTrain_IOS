//
//  VideoBeginningView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/6/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoBeginningView.h"
#import "LePlayer.h"
#import "LePlayerView.h"
#import "YXPlayerBufferingView.h"
#import "ActivityPlayExceptionView.h"
@interface VideoBeginningView ()
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) LePlayerView *playerView;
@property (nonatomic, strong) YXPlayerBufferingView *bufferingView;
@property (nonatomic, strong) ActivityPlayExceptionView *exceptionView;



@property (nonatomic, strong) RACDisposable *disposable;
@property (nonatomic, copy) VideoBeginningViewBackBlock backBlock;
@property (nonatomic, copy) VideoBeginningViewFinishBlock finishBlock;
@property (nonatomic, assign) VideoBeginningStatus playStatus;
@property (nonatomic, assign) BOOL isShowTop;



@end
@implementation VideoBeginningView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.isShowTop = YES;
        [self setupUI];
        [self setupLayout];
        [self setupObserver];
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainStartStopVideo object:nil] subscribeNext:^(NSNotification *x) {
            STRONG_SELF
            if ([x.object boolValue]) {
                [self.player pause];
            }else {
                [self.player play];
            }
        }];
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil] subscribeNext:^(NSNotification *x) {
            STRONG_SELF
            if (!self.exceptionView.hidden) {
                return;
            }
            [self.player pause];
        }];
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            if (self.exceptionView.hidden && self.isShowTop) {
                [self.player play];
            }
        }];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.player = [[LePlayer alloc] init];
    self.playerView = (LePlayerView *)[self.player playerViewWithFrame:CGRectZero];
    [self addSubview:self.playerView];
    
    self.bufferingView = [[YXPlayerBufferingView alloc] init];
    [self addSubview:self.bufferingView];
    
    self.exceptionView = [[ActivityPlayExceptionView alloc] init];
    [self.exceptionView.exceptionButton  addTarget:self action:@selector(exceptionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.exceptionView.hidden = YES;
    WEAK_SELF
    [[self.exceptionView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.backBlock);
    }];
    [self addSubview:self.exceptionView];
    [self.exceptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.topView = [[VideoBeginningTopView alloc] init];
    [[self.topView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.backBlock);
    }];
    self.topView.hidden = YES;
    [self addSubview:self.topView];
    
    self.rotateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rotateButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    self.rotateButton.layer.cornerRadius = 15.0f;
    [self.rotateButton setImage:[UIImage imageNamed:@"放大按钮"] forState:UIControlStateNormal];
    [self addSubview:self.rotateButton];
    
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
}
#pragma mark - set
- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"片头" ofType:@"mp4"];
//    _videoUrl = [NSURL fileURLWithPath:filePath];
    self.player.videoUrl = _videoUrl;
}
- (void)setPlayStatus:(VideoBeginningStatus)playStatus {
    _playStatus = playStatus;
    self.exceptionView.hidden = NO;
    switch (_playStatus) {
        case VideoBeginningStatus_NotWifi:
        {
            self.exceptionView.exceptionLabel.text = @"当前为非wifi网络,继续播放会产生流量费用";
            [self.exceptionView.exceptionButton setTitle:@"继续观看" forState:UIControlStateNormal];
        }
            break;
        case  VideoBeginningStatus_NetworkError:
        {
            self.exceptionView.exceptionLabel.text = @"网络已断开,请检查网络设置";
            [self.exceptionView.exceptionButton setTitle:@"刷新重试" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
- (void)setVideoBeginningViewBackBlock:(VideoBeginningViewBackBlock)block {
    self.backBlock = block;
}
- (void)setVideoBeginningViewFinishBlock:(VideoBeginningViewFinishBlock)block {
    self.finishBlock = block;
}
#pragma mark - notification
- (void)setupObserver {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    WEAK_SELF
    [r setReachableBlock:^void (Reachability * reachability) {
        STRONG_SELF
        if([reachability isReachableViaWiFi]) {
            return;
        }
        if([reachability isReachableViaWWAN]) {
            [self do3GCheck];
        }
    }];
    [r startNotifier];
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
            BLOCK_EXEC(self.finishBlock,YES);
        }else if ([x unsignedIntegerValue] == PlayerView_State_Error) {
            [self playVideoClear];
            BLOCK_EXEC(self.finishBlock,NO);
        }else if ([x unsignedIntegerValue] == PlayerView_State_Paused) {
            DDLogDebug(@"加载");
        }
    }];
}
- (void)do3GCheck {
    [self.player pause];
    self.playStatus = VideoBeginningStatus_NotWifi;
}
#pragma mark - button Action
- (void)exceptionButtonAction:(UIButton *)sender {
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
        [self.player play];
        self.exceptionView.hidden = YES;
    }else {
        self.exceptionView.hidden = NO;
    }
}
#pragma mark - play Setting
- (void)viewWillAppear {
    self.isShowTop = YES;
    [self.player play];
}
- (void)viewWillDisappear {
    self.isShowTop = NO;
    [self.player pause];
}
- (void)playVideoClear {
    self.player = nil;
    [self.disposable dispose];
    [self removeFromSuperview];
}
@end
