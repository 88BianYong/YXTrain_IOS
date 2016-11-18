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
static const NSTimeInterval kTopBottomHiddenTime = 5;
@interface ActivityPlayManagerView()
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) LePlayerView *playerView;
@property (nonatomic, strong) YXPlayerBufferingView *bufferingView;
@property (nonatomic, strong) ActivityPlayBottomView *bottomView;
@property (nonatomic, strong) ActivitySlideProgressView *slideProgressView;
@property (nonatomic, strong) ActivityPlayTopView *topView;

@property (nonatomic, copy) BackActionBlock backBlock;
@property (nonatomic, copy) RotateScreenBlock rotateBlock;
@property (nonatomic, strong) NSMutableArray *disposableMutableArray;
@property (nonatomic, strong) NSTimer *topBottomHideTimer;
@property (nonatomic, assign) BOOL isTopBottomHidden;
@end

@implementation ActivityPlayManagerView
- (void)dealloc{
    for (RACDisposable *d in self.disposableMutableArray) {
        [d dispose];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.disposableMutableArray = [[NSMutableArray alloc] initWithCapacity:5];
        self.clipsToBounds = YES;
        [self setupUI];
        [self setupLayout];
        [self setupObserver];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.player = [[LePlayer alloc] init];
    self.playerView = (LePlayerView *)[self.player playerViewWithFrame:CGRectZero];
    [self addSubview:self.playerView];
    self.bottomView = [[ActivityPlayBottomView alloc] init];
    [self addSubview:self.bottomView];
    [self.bottomView.playPauseButton addTarget:self action:@selector(playAndPauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.rotateButton addTarget:self action:@selector(rotateScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.slideProgressControl addTarget:self action:@selector(progressAction) forControlEvents:UIControlEventTouchUpInside];
    self.bufferingView = [[YXPlayerBufferingView alloc] init];
    [self addSubview:self.bufferingView];

    
    self.topView = [[ActivityPlayTopView alloc] init];
    [self addSubview:self.topView];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)];
    recognizer.numberOfTapsRequired = 1;
    self.playerView.userInteractionEnabled = YES;
    [self.playerView addGestureRecognizer:recognizer];
    
    self.slideProgressView = [[ActivitySlideProgressView alloc] init];
    self.slideProgressView.hidden = YES;
    [self addSubview:self.slideProgressView];
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
                BLOCK_EXEC(self.backBlock);
            }
                break;
            case PlayerView_State_Error:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.bufferingView stop];
                    self.bufferingView.hidden = YES;
                    [(YXBaseViewController *)[self viewController] showToast:@"播放失败！"];
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
                                                          self.playerView.userInteractionEnabled = YES;
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
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"网络连接提示" message:@"当前处于非Wi-Fi环境，仍要继续吗？" preferredStyle:UIAlertControllerStyleAlert];
    WEAK_SELF
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        BLOCK_EXEC(self.backBlock);
        return;
    }];
    UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self.player play];
    }];
    [alertVC addAction:backAction];
    [alertVC addAction:goAction];
    [[self viewController] presentViewController:alertVC animated:YES completion:nil];
}
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
#pragma mark - top / bottom hide
- (void)tapGestureRecognizer {
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

#pragma mark - button Action
- (void)playAndPauseButtonAction:(UIButton *)sender{
    [self resetTopBottomHideTimer];
    if (self.player.state == PlayerView_State_Paused) {
        [self.player play];
    } else if (self.player.state == PlayerView_State_Finished) {
        [self.player seekTo:0];
        [self.player play];
    } else {
        [self.player pause];
    }
}
- (void)rotateScreenButtonAction:(UIButton *)sender{
    self.bottomView.isFullscreen = !self.bottomView.isFullscreen;
    BLOCK_EXEC(self.rotateBlock,self.bottomView.isFullscreen)
}
- (void)setBackActionBlock:(BackActionBlock)block{
    self.backBlock = block;
}
- (void)setRotateScreenBlock:(RotateScreenBlock)block{
    self.rotateBlock = block;
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
- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    self.player.videoUrl = _videoUrl;
//    [NSURL URLWithString:@"http://coursecdn.teacherclub.com.cn/course/cf/ts/ts_gg/ptcz-xybnx_qxgly/video/qxgly/qxgly.m3u8"];
}
@end
