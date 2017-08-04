//
//  VideoPlayManagerView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoPlayManagerView.h"
#import "YXPlayerBufferingView.h"
#import "ActivitySlideProgressView.h"
#import "ActivityPlayExceptionView.h"
#import "UIImage+YXImage.h"
#import "YXCourseDetailItem.h"
#import "VideoBeginningView.h"
@interface VideoPlayerDefinition : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *url;
@end
@implementation VideoPlayerDefinition
@end

static const NSTimeInterval kTopBottomHiddenTime = 5;
static const NSInteger kPlayReportRetryTime = 10;
@interface VideoPlayManagerView ()
@property (nonatomic, strong) YXPlayerBufferingView *bufferingView;
@property (nonatomic, strong) ActivitySlideProgressView *slideProgressView;
@property (nonatomic, strong) ActivityPlayExceptionView *exceptionView;
@property (nonatomic, strong) UIImageView *placeholderImageView;

@property (nonatomic, strong) VideoBeginningView *beginningView;

@property (nonatomic, copy) VideoPlayManagerViewBackActionBlock backBlock;
@property (nonatomic, copy) VideoPlayManagerViewRotateScreenBlock rotateBlock;
@property (nonatomic, copy) VideoPlayManagerViewPlayVideoBlock playBlock;
@property (nonatomic, copy) VideoPlayManagerViewFinishBlock finishBlock;
@property (nonatomic, strong) NSMutableArray *disposableMutableArray;
@property (nonatomic, strong) NSTimer *topBottomHideTimer;
@property (nonatomic, assign) BOOL isTopBottomHidden;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) BOOL isManualPause;
@property (nonatomic, strong) NSMutableArray<VideoPlayerDefinition *> *definitionMutableArray;
@property (nonatomic, strong) NSMutableArray<UIButton *> *defButtonArray;
@property (nonatomic, assign) BOOL isShowDefinition;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) NSTimeInterval playTime;

@property (nonatomic, strong) NSURL *oldUrl;


@property (nonatomic, strong) NSTimer *playReportRetryTimer;

@property (nonatomic, copy) void(^isReportSuccessBlock)(BOOL isSuccess);
@property (nonatomic, assign) BOOL isTestReport;


@end
@implementation VideoPlayManagerView
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.disposableMutableArray = [[NSMutableArray alloc] initWithCapacity:5];
        self.definitionMutableArray = [[NSMutableArray alloc] initWithCapacity:3];
        self.defButtonArray = [[NSMutableArray alloc] initWithCapacity:3];
        self.clipsToBounds = YES;
        self.isShowTop = YES;
        [self setupUI];
        [self setupLayout];
        [self setupObserver];
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kRecordNeedUpdateNotification object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            [self recordPlayerDuration];
        }];
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainStartStopVideo object:nil] subscribeNext:^(NSNotification *x) {
            STRONG_SELF
            if (!self.exceptionView.hidden) {
                return;
            }
            if ([x.object boolValue]) {
                [self.player pause];
            }else {
                if (!self.isManualPause) {
                    [self.player play];
                }
            }
        }];
        
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillTerminateNotification object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            self.player = nil;
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
            if (self.exceptionView.hidden  && !self.isManualPause && self.isShowTop) {
                [self.player play];
            }
        }];
        
        [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kRecordReportSuccessNotification object:nil]subscribeNext:^(id x) {
            STRONG_SELF
            NSNotification *noti = (NSNotification *)x;
            NSString *course_id = noti.userInfo.allKeys.firstObject;
            NSString *record = noti.userInfo[course_id];
            if (!isEmpty(record) && self.isTestReport) {
                [self.playReportRetryTimer invalidate];
                self.playReportRetryTimer = nil;
                self.playTime = 0;
                self.startTime = nil;
                self.isTestReport = NO;                
                BLOCK_EXEC(self.isReportSuccessBlock,YES);
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
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    recognizer.numberOfTapsRequired = 1;
    [self.playerView addGestureRecognizer:recognizer];
    
    self.bottomView = [[ActivityPlayBottomView alloc] init];
    [self addSubview:self.bottomView];
    [self.bottomView.playPauseButton addTarget:self action:@selector(playAndPauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.rotateButton addTarget:self action:@selector(rotateScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.slideProgressControl addTarget:self action:@selector(progressAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView.slideProgressControl addTarget:self action:@selector(invalidateTopBottomHiddenTimer) forControlEvents:UIControlEventTouchDown];
    self.bufferingView = [[YXPlayerBufferingView alloc] init];
    [self addSubview:self.bufferingView];
    
    self.topView = [[ActivityPlayTopView alloc] init];
    [self.topView.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.exceptionView = [[ActivityPlayExceptionView alloc] init];
    [self.exceptionView.exceptionButton  addTarget:self action:@selector(exceptionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.exceptionView.hidden = YES;
    WEAK_SELF
    [[self.exceptionView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.backBlock);
    }];
    [self addSubview:self.exceptionView];
}
- (void)setupLayout {
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_offset(44.0f);
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
- (void)showBeginningView {
    [self.beginningView playVideoClear];
    self.beginningView = nil;
    self.beginningView = [[VideoBeginningView alloc] init];
    [self.beginningView.rotateButton addTarget:self action:@selector(rotateScreenButtonAction:)forControlEvents:UIControlEventTouchUpInside];
    WEAK_SELF
    [self.beginningView setVideoBeginningViewBackBlock:^{
        STRONG_SELF
        BLOCK_EXEC(self.backBlock);
    }];
    [self.beginningView setVideoBeginningViewFinishBlock:^(BOOL isSave){
        STRONG_SELF
        if (isSave) {
            NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:kYXTrainPlayBeginningCourse]];
            mutableDictionary[self.fileItem.cid] = [NSDate date];
            [[NSUserDefaults standardUserDefaults] setObject:mutableDictionary forKey:kYXTrainPlayBeginningCourse];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.isBeginPlayEnd = YES;
        }
        self ->_beginningView = nil;
        [self.player play];
    }];
    [self addSubview:self.beginningView];
    self.beginningView.videoUrl = [NSURL URLWithString:self.fileItem.vheadUrl];
    //[NSURL URLWithString:@"http://upload.ugc.yanxiu.com/video/4620490456e684328d4fcf5a920f54a1.mp4"];
    [self.beginningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (BOOL)isPlayBeginningVideo:(BOOL)vHead {
    NSMutableDictionary *mutableDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:kYXTrainPlayBeginningCourse];
    NSDate *oldDate = mutableDictionary[self.fileItem.cid];
    BOOL playBool = NO;
    if (oldDate == nil) {
        playBool = YES;
    }else {
        NSTimeInterval  value = [[NSDate date] timeIntervalSinceDate:oldDate];
        playBool = (value > 12 * 60 * 60) ? YES : NO;
    }
    return playBool && vHead && !self.isBeginPlayEnd;
}
#pragma mark - set
- (void)setPlayTime:(NSTimeInterval)playTime {
    _playTime = playTime;
//    self.playTotalTime += _playTime;
}
- (void)setFileItem:(YXFileItemBase *)fileItem {
    if (_fileItem) {//每次先上报上次播放结果
        [self recordPlayerDuration];
        SAFE_CALL(self.exitDelegate, browserExit);
    }
    if (![[Reachability reachabilityForInternetConnection] isReachable] && self.oldUrl == nil) {
        self.oldUrl = self.player.videoUrl;
    }
    if (fileItem == nil) {
        return;
    }
    _fileItem = fileItem;
    self.delegate = _fileItem;
    self.exitDelegate = _fileItem;
    self.playTime = 0;
    self.startTime = nil;
    self.topView.titleString = _fileItem.name;
    self.videoUrl = [NSURL URLWithString:_fileItem.url];
    [self definitionFormat];
    CGFloat preProgress = fileItem.record.floatValue / fileItem.duration.floatValue;
    if (preProgress > 0.99) {
        preProgress = 0;
    }
    self.player.progress = preProgress;
    if (isEmpty(self.videoUrl.absoluteString)) {
        self.playStatus =  VideoPlayManagerStatus_Empty;
        return;
    }
    self.player.videoUrl = self.videoUrl;
    if ([self isPlayBeginningVideo:[_fileItem.vhead boolValue]] && self.fileItem.vheadUrl.length > 0) {
        self.isManualPause = YES;
        self.player.playPauseState = PlayerView_State_Paused;
        [self showBeginningView];
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
        [self.beginningView.rotateButton setImage:[UIImage imageNamed:@"放大按钮"] forState:UIControlStateNormal];
    }else {
        [self.beginningView.rotateButton setImage:[UIImage imageNamed:@"缩小按钮-"] forState:UIControlStateNormal];
    }
    self.exceptionView.backButton.hidden = !_isFullscreen;
    self.beginningView.topView.hidden = !_isFullscreen;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//TBD: 修改进度条白点跳动问题
        [self.bottomView.slideProgressControl updateUI];
    });
}
- (void)setVideoPlayManagerViewBackActionBlock:(VideoPlayManagerViewBackActionBlock)block {
    self.backBlock = block;
}
- (void)setVideoPlayManagerViewRotateScreenBlock:(VideoPlayManagerViewRotateScreenBlock)block {
    self.rotateBlock = block;
}
- (void)setVideoPlayManagerViewPlayVideoBlock:(VideoPlayManagerViewPlayVideoBlock)block {
    self.playBlock = block;
}
- (void)setVideoPlayManagerViewFinishBlock:(VideoPlayManagerViewFinishBlock)block {
    self.finishBlock = block;
}
- (void)setPlayStatus:(VideoPlayManagerStatus)playStatus {
    _playStatus = playStatus;
    self.exceptionView.hidden = NO;
    switch (_playStatus) {
        case  VideoPlayManagerStatus_Finish:
        {
            self.exceptionView.exceptionLabel.text = @"视频课程已播放完";
            [self.exceptionView.exceptionButton setTitle:@"点击重新观看" forState:UIControlStateNormal];
        }
            break;
        case  VideoPlayManagerStatus_Empty:
        {
            self.exceptionView.exceptionLabel.text = @"未找到该视频";
            [self.exceptionView.exceptionButton setTitle:@"刷新重试" forState:UIControlStateNormal];
        }
            break;
        case  VideoPlayManagerStatus_NotWifi:
        {
            self.exceptionView.exceptionLabel.text = @"当前为非wifi网络,继续播放会产生流量费用";
            [self.exceptionView.exceptionButton setTitle:@"继续观看" forState:UIControlStateNormal];
        }
            break;
        case  VideoPlayManagerStatus_PlayError:
        {
            [self.player pause];
            self.exceptionView.exceptionLabel.text = @"抱歉,播放出错了";
            [self.exceptionView.exceptionButton setTitle:@"重新播放" forState:UIControlStateNormal];
        }
            break;
        case  VideoPlayManagerStatus_NetworkError:
        {
            [self.player pause];
            self.exceptionView.exceptionLabel.text = @"网络已断开,请检查网络设置";
            [self.exceptionView.exceptionButton setTitle:@"刷新重试" forState:UIControlStateNormal];
        }
            break;
        case  VideoPlayManagerStatus_DataError:
        {
            self.exceptionView.exceptionLabel.text = @"抱歉,播放出错了";
            [self.exceptionView.exceptionButton setTitle:@"重新播放" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
#pragma mark - notification
- (void)setupObserver {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    WEAK_SELF
    [r setReachableBlock:^void (Reachability * reachability) {
        STRONG_SELF
        if([reachability isReachableViaWiFi]) {
            if (self.beginningView) {
                self.fileItem = self.fileItem;
                if (self.playStatus == VideoPlayManagerStatus_NotWifi) {
                    self.exceptionView.hidden = YES;
                }
            }
            return;
        }
        if([reachability isReachableViaWWAN]) {
            if (!self.classworkManager.hidden) {
                [self.player pause];
            }else {
                [self do3GCheck];
            }
            return;
        }
    }];
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
        if ([x unsignedIntegerValue] == PlayerView_State_Playing) {
            self.startTime = [NSDate date];
        } else {
            if (self.startTime) {
                self.playTime += [[NSDate date] timeIntervalSinceDate:self.startTime];
                self.startTime = nil;
            }
        }
        switch ([x unsignedIntegerValue]) {
            case PlayerView_State_Buffering:
            {
                DDLogDebug(@"加载");
                if (![r isReachable]) {
                    self.playStatus = VideoPlayManagerStatus_NetworkError;
                    [self.player pause];
                }else {
                    self.exceptionView.hidden = YES;
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.bufferingView stop];
                    self.bufferingView.hidden = YES;
                    self.playStatus = VideoPlayManagerStatus_PlayError;
                });
                break;
            }
            default:
                break;
        }
    }];
    RACDisposable *r2 = [RACObserve(self.player, duration) subscribeNext:^(id x) {
        STRONG_SELF
        self.bottomView.slideProgressControl.duration = [x doubleValue];
        [self.bottomView.slideProgressControl updateUI];
    }];
    
    RACDisposable *r3 = [RACObserve(self.player, timeBuffered) subscribeNext:^(id x) {
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
    
    RACDisposable *r4 = [RACObserve(self.player, timePlayed) subscribeNext:^(id x) {
        STRONG_SELF
        if (self.bottomView.slideProgressControl.bSliding) {
            return;
        }
        if (self.bottomView.slideProgressControl.duration > 0) {
            CGFloat playProgres = [x floatValue] / self.bottomView.slideProgressControl.duration;
            self.bottomView.slideProgressControl.playProgress = playProgres;
            self.slideProgressView.playProgress = playProgres;
            if (self.bottomView.slideProgressControl.playProgress > 0) { // walkthrough 换url时slide跳动
                [self.bottomView.slideProgressControl updateUI];
            }
            self.playTotalTime += 1;
        }
        if (self.classworkManager.hidden){
            [self.classworkManager compareClassworkPlayTime:(NSInteger)(self.player.duration * self.bottomView.slideProgressControl.playProgress)];
        }
    }];
    
    [self.disposableMutableArray addObject:r0];
   // [self.disposableMutableArray addObject:r1];
    [self.disposableMutableArray addObject:r2];
    [self.disposableMutableArray addObject:r3];
    [self.disposableMutableArray addObject:r4];
}
- (void)do3GCheck {
    [self.player pause];
    self.playStatus = VideoPlayManagerStatus_NotWifi;
}
#pragma mark - top / bottom hide
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap {
    tap.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tap.enabled = YES;//防止连续点击出现UI混乱
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
}
- (void)resetTopBottomHideTimer {
    [self.topBottomHideTimer invalidate];
    self.topBottomHideTimer = [NSTimer scheduledTimerWithTimeInterval:kTopBottomHiddenTime
                                                               target:self
                                                             selector:@selector(topBottomHideTimerAction)
                                                             userInfo:nil
                                                              repeats:YES];
}
- (void)invalidateTopBottomHiddenTimer {
    [self.topBottomHideTimer invalidate];
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
            make.bottom.equalTo(self.mas_bottom).offset(44.0f);
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
            make.bottom.equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - playStatus
- (void)progressAction {
    self.classworkManager.quizzesInteger = 0;
    [self resetTopBottomHideTimer];
    [self.player seekTo:self.player.duration * self.bottomView.slideProgressControl.playProgress];
    [self.classworkManager compareClassworkPlayTime:(NSInteger)(self.player.duration * self.bottomView.slideProgressControl.playProgress)];
}
- (void)playVideoFinished {
    self.bottomView.slideProgressControl.playProgress = 0.0f;
    self.slideProgressView.playProgress = 0.0f;
    self.bottomView.slideProgressControl.bufferProgress = 0.0f;
    self.slideProgressView.bufferProgress = 0.0f;
    [self.bottomView.slideProgressControl updateUI];
    [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"播放按钮A"] forState:UIControlStateNormal];
    BLOCK_EXEC(self.finishBlock);
    [self recordPlayerDuration];
    SAFE_CALL(self.exitDelegate, browserExit);
    _fileItem = nil;
}
#pragma mark - button Action
- (void)playAndPauseButtonAction:(UIButton *)sender{
    [self resetTopBottomHideTimer];
    if (self.player.state == PlayerView_State_Paused) {
        [self.player play];
        self.isManualPause = NO;
    } else if (self.player.state == PlayerView_State_Finished) {
        [self.player seekTo:0];
        [self.player play];
        self.isManualPause = NO;
    } else if (self.player.state == PlayerView_State_Playing){
        [self.player pause];
        self.isManualPause = YES;
    }else {
        [self.player pause];
        self.isManualPause = YES;
    }
}
- (void)rotateScreenButtonAction:(UIButton *)sender {
    self.bottomView.isFullscreen = !self.bottomView.isFullscreen;
    BLOCK_EXEC(self.rotateBlock,self.bottomView.isFullscreen)
}
- (void)playButtonAction:(UIButton *)sender {
    self.thumbImageView.hidden = YES;
}
- (void)backButtonAction:(UIButton *)sender {
    [self recordPlayerDuration];
    SAFE_CALL(self.exitDelegate, browserExit);
    BLOCK_EXEC(self.backBlock);
}
- (void)exceptionButtonAction:(UIButton *)sender {
    self.bufferingView.hidden = NO;
    [self.bufferingView start];
    self.exceptionView.hidden = YES;
    if (self.playStatus == VideoPlayManagerStatus_NotWifi) {//非WIFI情况下继续播放
        self.player.videoUrl = self.videoUrl;
        [self.player play];
    }else if (self.playStatus == VideoPlayManagerStatus_Finish || self.playStatus ==VideoPlayManagerStatus_Empty){
        BLOCK_EXEC(self.playBlock,self.playStatus);
    }else if (self.playStatus == VideoPlayManagerStatus_NetworkError) {
        if ([[Reachability reachabilityForInternetConnection] isReachable]) {
            if (self.oldUrl != nil) {
                self.player.videoUrl = self.videoUrl;//TBD: 无网络情况下切换播放地址会播放上一个
            }
            [self.player play];
            self.oldUrl = nil;
        }else {
            self.exceptionView.hidden = NO;
        }
    }
}
#pragma mark - definition
- (void)definitionFormat {
    [self.definitionMutableArray removeAllObjects];
    [self.defButtonArray removeAllObjects];
    if (!isEmpty(self.fileItem.lurl)) {
        VideoPlayerDefinition *definition = [[VideoPlayerDefinition alloc] init];
        definition.identifier = @"流畅";
        definition.url = self.fileItem.lurl;
        [self.definitionMutableArray addObject:definition];
    }
    if (!isEmpty(self.fileItem.murl)) {
        VideoPlayerDefinition *definition = [[VideoPlayerDefinition alloc] init];
        definition.identifier = @"标清";
        definition.url = self.fileItem.murl;
        [self.definitionMutableArray addObject:definition];
    }
    if (!isEmpty(self.fileItem.surl)) {
        VideoPlayerDefinition *definition = [[VideoPlayerDefinition alloc] init];
        definition.identifier = @"高清";
        definition.url = self.fileItem.surl;
        [self.definitionMutableArray addObject:definition];
    }
    if(isEmpty(self.definitionMutableArray)){
        self.bottomView.isShowDefinition = NO;
        return;
    }
    self.bottomView.isShowDefinition = YES;
    [self.definitionMutableArray enumerateObjectsUsingBlock:^(VideoPlayerDefinition * _Nonnull def, NSUInteger idx, BOOL * _Nonnull stop) {
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
        [self.defButtonArray addObject:btn];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(definitionCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    }];
    [self.bottomView.definitionButton setTitle:self.definitionMutableArray[0].identifier
                                      forState:UIControlStateNormal];
    self.videoUrl = [NSURL URLWithString:self.definitionMutableArray[0].url];
    [self.bottomView.definitionButton addTarget:self action:@selector(definitionShowHiddenAction:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)definitionShowHiddenAction:(UIButton *)sender {
    if (self.defButtonArray.count <= 1) {
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
    [self invalidateTopBottomHiddenTimer];
    for (UIButton *btn in self.defButtonArray) {
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45, 25.5));
            make.right.mas_equalTo(-3);
            make.top.mas_equalTo(self.mas_bottom);
        }];
        btn.alpha = 0;
    }
    [self layoutIfNeeded];
    
    CGFloat yOffset = -50;
    for (UIButton *btn in _defButtonArray) {
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
    for (UIButton *btn in self.defButtonArray) {
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 34));
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.mas_bottom);
        }];
        btn.alpha = 0;
    }
    [self layoutIfNeeded];
}
- (void)definitionCloseAction:(UIButton *)sender {
    NSInteger index = [self.defButtonArray indexOfObject:sender];
    [self.bottomView.definitionButton setTitle:self.definitionMutableArray[index].identifier forState:UIControlStateNormal];
    [self changeVideoUrlAndPlay:self.definitionMutableArray[index].url];
    self.isShowDefinition = NO;
    [self hideDefinition];
}
- (void)changeVideoUrlAndPlay:(NSString *)url {
    self.player.progress = self.bottomView.slideProgressControl.playProgress;
    self.player.videoUrl = [NSURL URLWithString:url];
}
#pragma mark - 
- (void)recordPlayerDuration  {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(playerProgress:totalDuration:stayTime:)]) {
        if (self.player.duration) {
            if (self.startTime) {
                self.playTime += [[NSDate date]timeIntervalSinceDate:self.startTime];
            }
            [self.delegate playerProgress:self.slideProgressView.playProgress totalDuration:self.player.duration stayTime:self.playTime];
            self.playTime = 0;
            self.startTime = nil;
        }
    }
}
- (void)playReport:(void(^)(BOOL isSuccess))block {
    self.isReportSuccessBlock = block;
    [self.playReportRetryTimer invalidate];
    self.playReportRetryTimer = [NSTimer scheduledTimerWithTimeInterval:kPlayReportRetryTime
                                                               target:self
                                                             selector:@selector(startPlayReport)
                                                             userInfo:nil
                                                              repeats:YES];
    [self.playReportRetryTimer fire];
}
- (void)startPlayReport {
    self.isTestReport = YES;
    [self recordPlayerDuration];
    SAFE_CALL(self.exitDelegate, browserExit);
}
- (void)viewWillAppear {
    if (!self.isManualPause) {
        [self.player play];
    }
    self.isShowTop = YES;
    [_beginningView viewWillAppear];
}
- (void)viewWillDisappear {
    [self.player pause];
    self.isShowTop = NO;
    [_beginningView viewWillDisappear];
}
- (void)playVideoClear {
    [_beginningView playVideoClear];
    [self recordPlayerDuration];
    SAFE_CALL(self.exitDelegate, browserExit);
    [self.player pause];
    self.player = nil;
    [self.topBottomHideTimer invalidate];
    for (RACDisposable *d in self.disposableMutableArray) {
        [d dispose];
    }
}
@end
