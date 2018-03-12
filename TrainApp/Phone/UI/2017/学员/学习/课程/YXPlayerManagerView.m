//
//  YXPlayerManagerView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPlayerManagerView.h"
#import "ActivityPlayExceptionView.h"
#import "YXPlayerBufferingView.h"
#define kScreenSlideAdvanceRetreat(offset) 150.0f/[UIScreen mainScreen].bounds.size.width * offset

@interface YXVideoPlayerDefinition : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *url;
@end
@implementation YXVideoPlayerDefinition
@end

@interface YXPlayerManagerView ()
@property (nonatomic, strong) YXPlayerBufferingView *bufferingView;
@property (nonatomic, strong) ActivityPlayExceptionView *exceptionView;
@property (nonatomic, strong) UIImageView *placeholderImageView;

@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) NSMutableArray<RACDisposable *> *disposableMutableArray;

//清晰度选择
@property (nonatomic, strong) NSMutableArray<YXVideoPlayerDefinition *> *definitionMutableArray;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonMutableArray;
@property (nonatomic, assign) BOOL isShowDefinition;

//上下状态栏显示隐藏
@property (nonatomic, strong) RACDisposable *topBottomHiddenDisposable;
@property (nonatomic, assign) BOOL isTopBottomHidden;

@property (nonatomic, assign) CGFloat beginTouchX;
@property (nonatomic, assign) BOOL isStartChangeBool;


@property (nonatomic, strong) UIView *iphonexView;



@end
@implementation YXPlayerManagerView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.disposableMutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.definitionMutableArray = [[NSMutableArray alloc] initWithCapacity:3];
        self.buttonMutableArray = [[NSMutableArray alloc] initWithCapacity:3];
        self.clipsToBounds = YES;
        [self setupUI];
        [self setupLayout];
        [self setupObserver];
        [self setupNotification];
    }
    return self;
}
#pragma mark - set
- (void)setFileItem:(YXFileItemBase *)fileItem {
    if (fileItem == nil) {
        return;
    }
    _fileItem = fileItem;
    [self setupPlayer];
}
- (void)setupPlayer {
    self.playTime = 0;
    self.topView.titleString = _fileItem.name;
    self.videoUrl = [self definitionFormat];
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        self.playerStatus = YXPlayerManagerAbnormal_NetworkError;
        return;
    }
    CGFloat preProgress = _fileItem.record.floatValue / _fileItem.duration.floatValue;
    if (preProgress > 0.99) {
        preProgress = 0;
    }
    self.player.progress = preProgress;
    if (isEmpty(self.videoUrl.absoluteString)) {
        self.playerStatus =  YXPlayerManagerAbnormal_Empty;
        return;
    }
    self.isWifiPlayer = NO;
    self.player.videoUrl = self.videoUrl;
    self.videoUrl = nil;
    if ([[Reachability reachabilityForInternetConnection] isReachableViaWWAN]) {
        self.playerStatus = YXPlayerManagerAbnormal_NotWifi;
    }
    self.thumbImageView.hidden = YES;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
}
- (void)setIsFullscreen:(BOOL)isFullscreen {
    _isFullscreen = isFullscreen;
    self.bottomView.isFullscreen = _isFullscreen;
    self.topView.hidden = !_isFullscreen;
    if (!_isFullscreen) {
        [self hideDefinition];
    }
    self.exceptionView.backButton.hidden = !_isFullscreen;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//TBD: 修改进度条白点跳动问题
        [self.bottomView.slideProgressControl updateUI];
    });
}
- (void)setPlayerStatus:(YXPlayerManagerAbnormalStatus)playerStatus {
    _playerStatus = playerStatus;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.exceptionView.hidden = NO;
        self.pauseStatus = YXPlayerManagerPause_Abnormal;
        switch (self->_playerStatus) {
            case  YXPlayerManagerAbnormal_Finish:
            {
                self.exceptionView.exceptionLabel.text = @"视频课程已播放完";
                [self.exceptionView.exceptionButton setTitle:@"点击重新观看" forState:UIControlStateNormal];
            }
            break;
            case  YXPlayerManagerAbnormal_Empty:
            {
                self.exceptionView.exceptionLabel.text = @"未找到该视频";
                [self.exceptionView.exceptionButton setTitle:@"刷新重试" forState:UIControlStateNormal];
            }
            break;
            case  YXPlayerManagerAbnormal_NotWifi:
            {
                self.exceptionView.exceptionLabel.text = @"当前为非wifi网络,继续播放会产生流量费用";
                [self.exceptionView.exceptionButton setTitle:@"继续观看" forState:UIControlStateNormal];
            }
            break;
            case  YXPlayerManagerAbnormal_PlayError:
            {
                self.exceptionView.exceptionLabel.text = @"抱歉,播放出错了";
                [self.exceptionView.exceptionButton setTitle:@"重新播放" forState:UIControlStateNormal];
            }
            break;
            case  YXPlayerManagerAbnormal_NetworkError:
            {
                self.exceptionView.exceptionLabel.text = @"网络已断开,请检查网络设置";
                [self.exceptionView.exceptionButton setTitle:@"刷新重试" forState:UIControlStateNormal];
            }
            break;
            case  YXPlayerManagerAbnormal_DataError:
            {
                self.exceptionView.exceptionLabel.text = @"抱歉,播放出错了";
                [self.exceptionView.exceptionButton setTitle:@"重新播放" forState:UIControlStateNormal];
            }
            break;
        }
    });

}
- (void)setPauseStatus:(YXPlayerManagerPauseStatus)pauseStatus {
    _pauseStatus = pauseStatus;
    if (_pauseStatus == YXPlayerManagerPause_Not) {
        if (self.videoUrl != nil) {
            [self setupPlayer];
        }
        [self.player play];
        self.exceptionView.hidden = YES;
        self.videoUrl = nil;
    }else {
        if (self.player.state != PlayerView_State_Paused) {
            [self.player pause];
        }
    }
}
#pragma mark - setupUI
- (void)setupUI {
    [self setupPlayerView];
    [self setupBottomView];
    
    self.bufferingView = [[YXPlayerBufferingView alloc] init];
    [self addSubview:self.bufferingView];
    WEAK_SELF
    self.topView = [[ActivityPlayTopView alloc] init];
    [[self.topView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.playerManagerBackActionBlock);
    }];
    [self addSubview:self.topView];
    
    self.slideProgressView = [[ActivitySlideProgressView alloc] init];
    self.slideProgressView.hidden = YES;
    [self addSubview:self.slideProgressView];
    
    self.thumbImageView = [[UIImageView alloc] init];
    self.thumbImageView.backgroundColor = [UIColor colorWithHexString:@"e7e8ec"];
    self.thumbImageView.userInteractionEnabled = YES;
    [self addSubview:self.thumbImageView];
    
    self.placeholderImageView = [[UIImageView alloc] init];
    self.placeholderImageView.hidden = YES;
    self.placeholderImageView.image = [UIImage imageNamed:@"视频未读取过来的默认图片"];
    [self.thumbImageView addSubview:self.placeholderImageView];
    [self setupExceptionView];
}
- (void)setupPlayerView {
    self.player = [[LePlayer alloc] init];
    self.playerView = (LePlayerView *)[self.player playerViewWithFrame:CGRectZero];
    [self addSubview:self.playerView];
    WEAK_SELF
    UITapGestureRecognizer *playerRecognizer = [[UITapGestureRecognizer alloc] init];
    playerRecognizer.numberOfTapsRequired = 1;
    [[playerRecognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        STRONG_SELF
        x.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            x.enabled = YES;//防止连续点击出现UI混乱
        });
        if (self.isShowDefinition) {
            [self hideDefinition];
            return;
        }
        if (self.isTopBottomHidden) {
            [self showTopView];
            [self showBottomView];
        } else {
            [self hiddenTopView];
            [self hiddenBottomView];
        }
        self.isTopBottomHidden = !self.isTopBottomHidden;
        [self resetTopBottomHideTimer];
        
    }];
    [self.playerView addGestureRecognizer:playerRecognizer];
    
}
- (void)setupBottomView {
    WEAK_SELF
    self.bottomView = [[ActivityPlayBottomView alloc] init];
    [self addSubview:self.bottomView];
    [[self.bottomView.playPauseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self resetTopBottomHideTimer];
        if (self.player.state == PlayerView_State_Paused) {
            self.pauseStatus = YXPlayerManagerPause_Not;
        } else if (self.player.state == PlayerView_State_Finished) {
            [self.player seekTo:0];
            self.pauseStatus = YXPlayerManagerPause_Not;
        } else if (self.player.state == PlayerView_State_Playing){
            self.pauseStatus = YXPlayerManagerPause_Manual;
        }else {
            self.pauseStatus = YXPlayerManagerPause_Manual;
        }
    }];
    [[self.bottomView.rotateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.bottomView.isFullscreen = !self.bottomView.isFullscreen;
        BLOCK_EXEC(self.playerManagerRotateActionBlock)
    }];
    [[self.bottomView.slideProgressControl rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self resetTopBottomHideTimer];
        [self.player seekTo:self.player.duration * self.bottomView.slideProgressControl.playProgress];
        BLOCK_EXEC(self.playerManagerSlideActionBlock,self.player.duration * self.bottomView.slideProgressControl.playProgress,YES);
    }];
    [[self.bottomView.slideProgressControl rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        STRONG_SELF
        [self.topBottomHiddenDisposable dispose];
    }];
    
    self.iphonexView = [[UIView alloc] init];
    self.iphonexView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    [self addSubview:self.iphonexView];

}
- (void)setupExceptionView {
    WEAK_SELF
    self.exceptionView = [[ActivityPlayExceptionView alloc] init];
    self.exceptionView.hidden = YES;
    [[self.exceptionView.exceptionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.bufferingView.hidden = NO;
        [self.bufferingView start];
        self.pauseStatus = YXPlayerManagerPause_Not;
        if (self.playerStatus == YXPlayerManagerAbnormal_NotWifi) {//非WIFI情况下继续播放
            self.isWifiPlayer = YES;
            self.pauseStatus = YXPlayerManagerPause_Not;
        }else if (self.playerStatus == YXPlayerManagerAbnormal_Finish || self.playerStatus ==YXPlayerManagerAbnormal_Empty){
            self.exceptionView.hidden = YES;
            BLOCK_EXEC(self.playerManagerPlayerActionBlock,self.playerStatus);
        }else if (self.playerStatus == YXPlayerManagerAbnormal_NetworkError) {
            if ([[Reachability reachabilityForInternetConnection] isReachable]) {
                self.pauseStatus = YXPlayerManagerPause_Not;
            }
        }else {
            self.exceptionView.hidden = YES;
        }
    }];
    [[self.exceptionView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.playerManagerBackActionBlock);
    }];
    [self addSubview:self.exceptionView];
    
}
- (void)setupLayout {
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        }else {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }
        make.height.mas_offset(44.0f);
    }];
    [self.iphonexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.bottomView.mas_bottom);
        make.height.mas_offset(32.0f);
    }];
    
    [self.bufferingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(100.0f, 100.0f));
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        }else {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }
        make.top.equalTo(self.mas_top);
        make.height.mas_offset(44.0f);
    }];
    [self.slideProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_offset(3.0f);
    }];
    
    [self.exceptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(180.0f, 180.0f));
        make.center.equalTo(self.thumbImageView);
    }];
}
#pragma mark - notification
- (void)setupObserver {
    WEAK_SELF
    Reachability *r = [Reachability reachabilityForInternetConnection];
    r.reachableBlock = ^(Reachability *reachability) {
        STRONG_SELF
        if([reachability isReachableViaWWAN]) {
            if ((self.playerStatus == YXPlayerManagerAbnormal_NetworkError || self.exceptionView.hidden || self.pauseStatus != YXPlayerManagerPause_Test) && !self.isWifiPlayer ) {
                self.playerStatus = YXPlayerManagerAbnormal_NotWifi;
            }
        }
    };
    r.unreachableBlock = ^(Reachability *reachability) {
        STRONG_SELF
        if ((self.playerStatus == YXPlayerManagerAbnormal_NotWifi && !self.exceptionView.hidden) || self.player.state == PlayerView_State_Buffering ) {
            self.playerStatus = YXPlayerManagerAbnormal_NetworkError;
        }
    };
    [r startNotifier];

    RACDisposable *r0 = [RACObserve(self.player, state) subscribeNext:^(id x) {
        STRONG_SELF
        if (self.player.isBuffering) {
            self.bufferingView.hidden = NO;
            [self.bufferingView start];
        } else {
            self.bufferingView.hidden = YES;
            [self.bufferingView stop];
        }
        switch ([x unsignedIntegerValue]) {
            case PlayerView_State_Buffering:
            {
                DDLogDebug(@"加载");
                if ([[Reachability reachabilityForInternetConnection] isReachable]) {
                    if([[Reachability reachabilityForInternetConnection] isReachableViaWWAN] && !self.isWifiPlayer) {
                        self.playerStatus = YXPlayerManagerAbnormal_NotWifi;
                    }
                }else {
                    self.playerStatus = YXPlayerManagerAbnormal_NetworkError;
                }
            }
                break;
            case PlayerView_State_Playing:
            {
                self.exceptionView.hidden = YES;
                DDLogDebug(@"播放");
                [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"暂停按钮A"] forState:UIControlStateNormal];
            }
                break;
            case PlayerView_State_Paused:
            {
                DDLogDebug(@"暂停");
                [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"播放按钮A"] forState:UIControlStateNormal];
                [self hideDefinition];
            }
                break;
            case PlayerView_State_Finished:
            {
                DDLogDebug(@"完成");
                [self playVideoFinished];
            }
                break;
            case PlayerView_State_Error:
            {
                DDLogDebug(@"错误");
                NSDictionary *dict = @{
                                       @"token": [LSTSharedInstance sharedInstance].userManger.userModel.token?:@"",
                                       @"uid": [LSTSharedInstance sharedInstance].userManger.userModel.uid?:@"",
                                       @"url": self.videoUrl?:@""
                                       };
                [YXDataStatisticsManger trackEvent:@"播放出错" label:@"出错信息" parameters:dict];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.bufferingView stop];
                    self.bufferingView.hidden = YES;
                    self.playerStatus = YXPlayerManagerAbnormal_PlayError;
                });
                break;
            }
            default:
                break;
        }
    }];
    
    RACDisposable *r1 = [RACObserve(self.player, duration) subscribeNext:^(id x) {
        STRONG_SELF
        self.bottomView.slideProgressControl.duration = [x doubleValue];
        [self.bottomView.slideProgressControl updateUI];
    }];
    
    RACDisposable *r2 = [RACObserve(self.player, timeBuffered) subscribeNext:^(id x) {
        STRONG_SELF
        if (self.bottomView.slideProgressControl.bSliding) {
            return;
        }
        if (self.bottomView.slideProgressControl.duration > 0) {
            CGFloat bufferProgress = [x floatValue] / self.bottomView.slideProgressControl.duration;
            self.bottomView.slideProgressControl.bufferProgress = bufferProgress;
            self.slideProgressView.bufferProgress = bufferProgress;
            if (self.bottomView.slideProgressControl.bufferProgress > 0) {
                [self.bottomView.slideProgressControl updateUI];
            }
        }
    }];
    
    RACDisposable *r3 = [RACObserve(self.player, timePlayed) subscribeNext:^(id x) {
        STRONG_SELF
        if (self.bottomView.slideProgressControl.bSliding) {
            return;
        }
        if (self.bottomView.slideProgressControl.duration > 0) {
            CGFloat playProgres = [x floatValue] / self.bottomView.slideProgressControl.duration;
            if (!self.isStartChangeBool) {
                self.bottomView.slideProgressControl.playProgress = playProgres;
                self.slideProgressView.playProgress = playProgres;
                if (self.bottomView.slideProgressControl.playProgress > 0) { // walkthrough 换url时slide跳动
                    [self.bottomView.slideProgressControl updateUI];
                }
            }
            if (self.pauseStatus == YXPlayerManagerPause_Not) {
                self.playTime += 1;
            }
        }
        BLOCK_EXEC(self.playerManagerSlideActionBlock,self.player.duration * self.bottomView.slideProgressControl.playProgress ,NO);
    }];
    
    RACDisposable *r4 = [RACObserve(self.player, isBuffering) subscribeNext:^(id x) {
        STRONG_SELF
        if (self.player.isBuffering) {
            self.bufferingView.hidden = NO;
            [self.bufferingView start];
        } else {
            self.bufferingView.hidden = YES;
            [self.bufferingView stop];
        }
    }];
    
    [self.disposableMutableArray addObject:r0];
    [self.disposableMutableArray addObject:r1];
    [self.disposableMutableArray addObject:r2];
    [self.disposableMutableArray addObject:r3];
    [self.disposableMutableArray addObject:r4];
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

#pragma mark - hidden show
- (void)resetTopBottomHideTimer {
    [self.topBottomHiddenDisposable  dispose];
    WEAK_SELF
    self.topBottomHiddenDisposable = [[RACSignal interval:5.0f onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        STRONG_SELF
        [self topBottomHideTimerAction];
    }];
}
- (void)topBottomHideTimerAction {
    [self hiddenTopView];
    [self hiddenBottomView];
    self.isTopBottomHidden = YES;
}
- (void)hiddenTopView {
    [UIView animateWithDuration:0.6 animations:^{
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(-44.0f);
        }];
        [self layoutIfNeeded];
    }];
}
- (void)hiddenBottomView {
    [UIView animateWithDuration:0.6f animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(44.0f + kHorizontalBottomUpwardHeight);
            }else {
                make.bottom.equalTo(self.mas_bottom).offset(44.0f + kHorizontalBottomUpwardHeight);
            }
        }];
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.slideProgressView.hidden = NO;
        }
    }];
}
- (void)showTopView {
    [UIView animateWithDuration:0.6 animations:^{
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
        }];
        [self layoutIfNeeded];
    }];
}
- (void)showBottomView {
    self.slideProgressView.hidden = YES;
    [UIView animateWithDuration:0.6f animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            }else {
                make.bottom.equalTo(self.mas_bottom);
            }
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - definition
- (NSURL *)definitionFormat {
    [self.definitionMutableArray removeAllObjects];
    [self.buttonMutableArray removeAllObjects];
    if (!isEmpty(self.fileItem.lurl)) {
        YXVideoPlayerDefinition *definition = [[YXVideoPlayerDefinition alloc] init];
        definition.identifier = @"流畅";
        definition.url = self.fileItem.lurl;
        [self.definitionMutableArray addObject:definition];
    }
    if (!isEmpty(self.fileItem.murl)) {
        YXVideoPlayerDefinition *definition = [[YXVideoPlayerDefinition alloc] init];
        definition.identifier = @"标清";
        definition.url = self.fileItem.murl;
        [self.definitionMutableArray addObject:definition];
    }
    if (!isEmpty(self.fileItem.surl)) {
        YXVideoPlayerDefinition *definition = [[YXVideoPlayerDefinition alloc] init];
        definition.identifier = @"高清";
        definition.url = self.fileItem.surl;
        [self.definitionMutableArray addObject:definition];
    }
    if(isEmpty(self.definitionMutableArray)){
        self.bottomView.isShowDefinition = NO;
        return [NSURL URLWithString:_fileItem.url];
    }
    self.bottomView.isShowDefinition = YES;
    [self.definitionMutableArray enumerateObjectsUsingBlock:^(YXVideoPlayerDefinition * _Nonnull def, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:def.identifier forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [btn setTitleColor:[UIColor colorWithHexString:@"868686"] forState:UIControlStateNormal];
        if (idx == 0) {
            [btn setBackgroundImage:[UIImage imageNamed:@"流畅button"] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
        } else {
            [btn setBackgroundImage:[UIImage imageNamed:@"高清标清button"] forState:UIControlStateNormal];
        }
        [self.buttonMutableArray addObject:btn];
        [self addSubview:btn];
        WEAK_SELF
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG_SELF
            NSInteger index = [self.buttonMutableArray indexOfObject:btn];
            [self.bottomView.definitionButton setTitle:self.definitionMutableArray[index].identifier forState:UIControlStateNormal];
            [self changeVideoUrlAndPlay:self.definitionMutableArray[index].url];
            self.isShowDefinition = NO;
            [self hideDefinition];
        }];
    }];
    [self.bottomView.definitionButton setTitle:self.definitionMutableArray[0].identifier
                                      forState:UIControlStateNormal];
    WEAK_SELF
    [[self.bottomView.definitionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.buttonMutableArray.count <= 1) {
            return;
        }
        self.isShowDefinition = !self.isShowDefinition;
        if (self.isShowDefinition) {
            [self showDefinition];
        }else {
            [self hideDefinition];
        }
    }];
    return [NSURL URLWithString:self.definitionMutableArray[0].url];
}
- (void)changeVideoUrlAndPlay:(NSString *)url {
    self.player.progress = self.bottomView.slideProgressControl.playProgress;
    self.player.videoUrl = [NSURL URLWithString:url];
}
- (void)definitionShowHiddenAction:(UIButton *)sender {
    if (self.buttonMutableArray.count <= 1) {
        return;
    }
    self.isShowDefinition = !self.isShowDefinition;
    if (self.isShowDefinition) {
        [self showDefinition];
    }else {
        [self hideDefinition];
    }
}
- (void)showDefinition {
    self.isShowDefinition = YES;
    [self.topBottomHiddenDisposable dispose];
    for (UIButton *btn in self.buttonMutableArray) {
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45, 25.5));
            make.right.mas_equalTo(-3);
            make.top.mas_equalTo(self.mas_bottom);
        }];
        btn.alpha = 0;
    }
    [self layoutIfNeeded];
    
    CGFloat yOffset = -50;
    for (UIButton *btn in _buttonMutableArray) {
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45, 25.5));
            make.right.mas_equalTo(-3);
            make.bottom.mas_equalTo(yOffset);
        }];
        btn.alpha = 1;
        yOffset -= 28;
        [self bringSubviewToFront:btn];
        [self layoutIfNeeded];
    }
}
- (void)hideDefinition {
    self.isShowDefinition = NO;
    [self resetTopBottomHideTimer];
    for (UIButton *btn in self.buttonMutableArray) {
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 34));
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.mas_bottom);
        }];
        btn.alpha = 0;
    }
    [self layoutIfNeeded];
}

- (void)playVideoFinished {
    self.bottomView.slideProgressControl.playProgress = 0.0f;
    self.slideProgressView.playProgress = 0.0f;
    self.bottomView.slideProgressControl.bufferProgress = 0.0f;
    self.slideProgressView.bufferProgress = 0.0f;
    [self.bottomView.slideProgressControl updateUI];
    [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"播放按钮A"] forState:UIControlStateNormal];
    BLOCK_EXEC(self.playerManagerFinishActionBlock);
    _fileItem = nil;
}
#pragma mark - notification
- (void)playVideoClear {
    [self.player pause];
    self.player = nil;
    [self.topBottomHiddenDisposable  dispose];
    [self.disposableMutableArray enumerateObjectsUsingBlock:^(RACDisposable * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj dispose];
    }];
    [self.disposableMutableArray removeAllObjects];
}
#pragma mark - 滑动快进后退
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *oneTouch = [touches anyObject];
    //手指触摸屏幕开始的坐标
    self.beginTouchX = [oneTouch locationInView:oneTouch.view].x;
    self.isStartChangeBool = YES;
}

//
////滑动快进/快退
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesMoved:touches withEvent:event];
//    UITouch *oneTouch = [touches anyObject];
//
//    // 手势相对于初始坐标的偏移量
//    CGFloat offset = [oneTouch locationInView:oneTouch.view].x - self.beginTouchX;
//    if (self.player.timeBuffered > 0.0f && (offset >= 2.0f || offset<= -2.0f)) {//点击或者勿触不改变 2秒容错
//        [self resetTopBottomHideTimer];
//        CGFloat playTime = self.player.timePlayed + kScreenSlideAdvanceRetreat(offset);
//        if (playTime >=  self.player.duration) {//快进滑动超过总时长
//            playTime = (self.player.duration - 10.0f);
//        }else if (playTime < 0) {//快退滑动超过开始时间
//            playTime = 0.0f;
//        }else {//正常区间
//
//        }
//        CGFloat playProgres = playTime / self.bottomView.slideProgressControl.duration;
//        self.bottomView.slideProgressControl.playProgress = playProgres;
//        self.slideProgressView.playProgress = playProgres;
//        [self.bottomView.slideProgressControl updateUI];
//    }
//}
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
//    UITouch *oneTouch = [touches anyObject];
//    CGFloat offset = [oneTouch locationInView:oneTouch.view].x - self.beginTouchX;
//    if (self.player.timeBuffered > 0.0f && (offset >= 2.0f || offset<= -2.0f)) {//点击或者勿触不改变 2秒容错
//        [self resetTopBottomHideTimer];
//        CGFloat playTime = self.player.timePlayed + kScreenSlideAdvanceRetreat(offset);
//        if (playTime >=  self.player.duration) {//快进滑动超过总时长
//            playTime = (self.player.duration - 10.0f);
//        }else if (playTime < 0) {//快退滑动超过开始时间
//            playTime = 0.0f;
//        }else {//正常区间
//
//        }
//        [self.player seekTo:playTime];
//        BLOCK_EXEC(self.playerManagerSlideActionBlock,playTime,YES);
//    }
//    self.isStartChangeBool = NO;
//}

@end
