//
//  ActivityPlayManagerView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityPlayManagerView.h"
#import "ActivityPlayBottomView.h"
#import "LePlayer.h"
#import "LePlayerView.h"
#import "YXPlayerBufferingView.h"
#import "ActivityPlayTopView.h"
#import "ActivitySlideProgressView.h"
#import "ActivityPlayExceptionView.h"
#import "UIImage+YXImage.h"
static const NSTimeInterval kTopBottomHiddenTime = 5;
@interface ActivityPlayManagerView()
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) LePlayerView *playerView;
@property (nonatomic, strong) YXPlayerBufferingView *bufferingView;
@property (nonatomic, strong) ActivityPlayBottomView *bottomView;
@property (nonatomic, strong) ActivitySlideProgressView *slideProgressView;
@property (nonatomic, strong) ActivityPlayTopView *topView;
@property (nonatomic, strong) ActivityPlayExceptionView *exceptionView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UIImageView *placeholderImageView;

@property (nonatomic, copy) ActivityPlayManagerBackActionBlock backBlock;
@property (nonatomic, copy) ActivityPlayManagerRotateScreenBlock rotateBlock;
@property (nonatomic, copy) ActivityPlayManagerPlayVideoBlock playBlock;
@property (nonatomic, strong) NSMutableArray *disposableMutableArray;
@property (nonatomic, strong) NSTimer *topBottomHideTimer;
@property (nonatomic, assign) BOOL isTopBottomHidden;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) BOOL isFirstBool;
@property (nonatomic, assign) BOOL isManualPause;
@end

@implementation ActivityPlayManagerView
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.disposableMutableArray = [[NSMutableArray alloc] initWithCapacity:5];
        self.clipsToBounds = YES;
        self.isFirstBool = YES;
        [self setupUI];
        [self setupLayout];
        [self setupObserver];
        self.thumbImageView.hidden = NO;
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
    self.bufferingView = [[YXPlayerBufferingView alloc] init];
    [self addSubview:self.bufferingView];

    self.topView = [[ActivityPlayTopView alloc] init];
    [self.topView.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.topView];
    
    self.slideProgressView = [[ActivitySlideProgressView alloc] init];
    self.slideProgressView.hidden = YES;
    [self addSubview:self.slideProgressView];
    
    self.exceptionView = [[ActivityPlayExceptionView alloc] init];
    [self.exceptionView.exceptionButton  addTarget:self action:@selector(exceptionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.exceptionView.hidden = YES;
    [self addSubview:self.exceptionView];
    
    self.thumbImageView = [[UIImageView alloc] init];
    self.thumbImageView.backgroundColor = [UIColor colorWithHexString:@"e7e8ec"];
    self.thumbImageView.userInteractionEnabled = YES;
    [self addSubview:self.thumbImageView];
    
    self.placeholderImageView = [[UIImageView alloc] init];
    self.placeholderImageView.image = [UIImage imageNamed:@"视频未读取过来的默认图片"];
    [self.thumbImageView addSubview:self.placeholderImageView];
    
    self.playButton = [[UIButton alloc] init];
    [self.playButton setImage:[UIImage imageNamed:@"播放视频按钮-正常态A"]
                     forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"播放视频按钮-点击态A"]
                     forState:UIControlStateHighlighted];
    [self.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.thumbImageView addSubview:_playButton];
    
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
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.thumbImageView);
        make.width.height.mas_offset(50.0f);
    }];
}

#pragma mark - notification
- (void)setupObserver {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    @weakify(r);
    WEAK_SELF
    [r setReachableBlock:^void (Reachability * reachability) {
        @strongify(r);
        STRONG_SELF
        if([r isReachableViaWiFi]) {
            return;
        }
        if([r isReachableViaWWAN]) {
            [self do3GCheck];
        }
    }];
    [r startNotifier];
    
    RACDisposable *r0 = [RACObserve(self.player, state) subscribeNext:^(id x) {
        STRONG_SELF
        if ([x unsignedIntegerValue] == PlayerView_State_Buffering) {
            self.bufferingView.hidden = NO;
            [self.bufferingView start];
        } else {
            self.bufferingView.hidden = YES;
            [self.bufferingView stop];
        }
        switch ([x unsignedIntegerValue]) {
            case PlayerView_State_Buffering:
            {
                self.thumbImageView.hidden = YES;
                if(![r isReachable]) {
                   self.playStatus = ActivityPlayManagerStatus_PlayError; 
                }
            }
                break;
            case PlayerView_State_Playing:
            {
                [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"暂停按钮A"] forState:UIControlStateNormal];
            }
                break;
            case PlayerView_State_Paused:
            {
                [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"播放按钮A"] forState:UIControlStateNormal];
            }
                break;
            case PlayerView_State_Finished:
            {
                [self playVideoFinished];
                self.thumbImageView.hidden = NO;
            }
                break;
            case PlayerView_State_Error:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.bufferingView stop];
                    self.bufferingView.hidden = YES;
                    self.playStatus = ActivityPlayManagerStatus_PlayError;
                });
                break;
            }
            default:
                break;
        }
    }];
    
    RACDisposable *r1 = [self.player rac_observeKeyPath:@"bIsPlayable"
                                                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                               observer:self
                                                  block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
                                                      STRONG_SELF
                                                      if ([value boolValue]) {
                                                          self.bufferingView.hidden = YES;
                                                          [self.bufferingView stop];
                                                          [self showTopView];
                                                          [self showBottomView];
                                                          self.isTopBottomHidden = NO;
                                                          [self resetTopBottomHideTimer];
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
        }
    }];

    [self.disposableMutableArray addObject:r0];
    [self.disposableMutableArray addObject:r1];
    [self.disposableMutableArray addObject:r2];
    [self.disposableMutableArray addObject:r3];
    [self.disposableMutableArray addObject:r4];
}
- (void)do3GCheck {
    [self.player pause];
    self.playStatus = ActivityPlayManagerStatus_NotWifi;
}

#pragma mark - top / bottom hide
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap {
    tap.enabled = NO;
    if (self.isTopBottomHidden) {
        [self showTopView];
        [self showBottomView];
    } else {
        [self hiddenTopView];
        [self hiddenBottomView];
    }
    self.isTopBottomHidden = !self.isTopBottomHidden;
    [self resetTopBottomHideTimer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tap.enabled = YES;
    });
}

- (void)resetTopBottomHideTimer {
    [self.topBottomHideTimer invalidate];
    self.topBottomHideTimer = nil;
    self.topBottomHideTimer = [NSTimer scheduledTimerWithTimeInterval:kTopBottomHiddenTime
                                                               target:self
                                                             selector:@selector(topBottomHideTimerAction)
                                                             userInfo:nil
                                                              repeats:YES];
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

- (void)progressAction {
    [self resetTopBottomHideTimer];
    [self.player seekTo:self.player.duration * self.bottomView.slideProgressControl.playProgress];
}

- (void)playVideoFinished {
    self.bottomView.slideProgressControl.playProgress = 0.0f;
    self.slideProgressView.playProgress = 0.0f;
    self.bottomView.slideProgressControl.bufferProgress = 0.0f;
    self.slideProgressView.bufferProgress = 0.0f;
    [self.bottomView.slideProgressControl updateUI];
    [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"播放按钮A"] forState:UIControlStateNormal];
    BLOCK_EXEC(self.backBlock);
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
    } else {
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
    if ([self.content.res_type isEqualToString:@"unknown"]) {
        BLOCK_EXEC(self.playBlock,ActivityPlayManagerStatus_Unknown);
    }else {
        if (self.videoUrl) {
            self.player.videoUrl = self.videoUrl;
        }
        self.isFirstBool = NO;
    }
}

- (void)backButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.backBlock);
}

- (void)exceptionButtonAction:(UIButton *)sender {
    self.bufferingView.hidden = NO;
    [self.bufferingView start];
    if (self.playStatus == ActivityPlayManagerStatus_NotWifi) {
        [self.player play];
    }else {
        BLOCK_EXEC(self.playBlock,self.playStatus);
    }
    self.exceptionView.hidden = YES;
}

#pragma mark - set
- (void)setActivityPlayManagerBackActionBlock:(ActivityPlayManagerBackActionBlock)block {
    self.backBlock = block;
}
- (void)setActivityPlayManagerRotateScreenBlock:(ActivityPlayManagerRotateScreenBlock)block {
    self.rotateBlock = block;
}
- (void)setActivityPlayManagerPlayVideoBlock:(ActivityPlayManagerPlayVideoBlock)block {
    self.playBlock = block;
}
- (void)setIsFullscreen:(BOOL)isFullscreen {
    _isFullscreen = isFullscreen;
    if (_isFullscreen) {
        [self.bottomView.rotateButton setImage:[UIImage imageNamed:@"缩小按钮-"] forState:UIControlStateNormal];
        self.topView.hidden = NO;
    }else {
        [self.bottomView.rotateButton setImage:[UIImage imageNamed:@"放大按钮"] forState:UIControlStateNormal];
        self.topView.hidden = YES;
    }
}
- (void)setContent:(ActivityToolVideoRequestItem_Body_Content *)content {
    _content = content;
    self.videoUrl = [NSURL URLWithString:_content.previewurl];
    self.topView.titleString = content.resname;
    WEAK_SELF
    [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:content.res_thumb] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        STRONG_SELF
        if (!error) {
            self.placeholderImageView.hidden = YES;
        }
    }];
    if (!self.isFirstBool && self.videoUrl) {
        self.player.videoUrl = self.videoUrl;
    }
}

- (void)setPlayStatus:(ActivityPlayManagerStatus)playStatus {
    _playStatus = playStatus;
    self.exceptionView.hidden = NO;
    switch (_playStatus) {
        case  ActivityPlayManagerStatus_Empty:
        {
            self.exceptionView.exceptionLabel.text = @"未找到该视频";
            [self.exceptionView.exceptionButton setTitle:@"刷新重试" forState:UIControlStateNormal];
        }
            break;
        case  ActivityPlayManagerStatus_NotWifi:
        {
            self.exceptionView.exceptionLabel.text = @"当前为非wifi网络,继续播放会产生流量费用";
            [self.exceptionView.exceptionButton setTitle:@"继续观看" forState:UIControlStateNormal];
        }
            break;
        case  ActivityPlayManagerStatus_PlayError:
        {
            self.exceptionView.exceptionLabel.text = @"抱歉,播放出错了";
            [self.exceptionView.exceptionButton setTitle:@"重新播放" forState:UIControlStateNormal];
        }
            break;
        case  ActivityPlayManagerStatus_NetworkError:
        {
            self.exceptionView.exceptionLabel.text = @"网络已断开,请检查网络设置";
            [self.exceptionView.exceptionButton setTitle:@"刷新重试" forState:UIControlStateNormal];
        }
            break;
        case  ActivityPlayManagerStatus_DataError:
        {
            self.exceptionView.exceptionLabel.text = @"抱歉,播放出错了";
            [self.exceptionView.exceptionButton setTitle:@"重新播放" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
- (void)viewWillAppear {
    if (!self.isManualPause) {
        [self.player play];
    }
    if ([self.content.res_type isEqualToString:@"unknown"]) {
        self.thumbImageView.hidden = NO;
    }
}

- (void)viewWillDisappear {
    [self.player pause];
}

- (void)playVideoClear {
    [self.player pause];
    self.player = nil;
    [self.topBottomHideTimer invalidate];
    for (RACDisposable *d in self.disposableMutableArray) {
        [d dispose];
    }
}

@end
