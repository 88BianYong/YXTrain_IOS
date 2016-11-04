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
@interface ActivityPlayManagerView()
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) LePlayerView *playerView;
@property (nonatomic, strong) YXPlayerBufferingView *bufferingView;


@property (nonatomic, copy) BackActionBlock backBlock;
@property (nonatomic, copy) RotateScreenBlock rotateBlock;
@property (nonatomic, strong) NSMutableArray *disposableMutableArray;
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
    self.playerView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.playerView];
    self.bottomView = [[ActivityPlayBottomView alloc] init];
    [self addSubview:self.bottomView];
    [self.bottomView.playPauseButton addTarget:self action:@selector(playAndPauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.rotateButton addTarget:self action:@selector(rotateScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.bufferingView = [[YXPlayerBufferingView alloc] init];
    [self addSubview:self.bufferingView];
    self.player.videoUrl = [NSURL URLWithString:@"http://coursecdn.teacherclub.com.cn/course/cf/ts/ts_gg/ptcz-xybnx_qxgly/video/qxgly/qxgly.m3u8"];
    

}
- (void)setupLayout {
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_offset(50.0f);
    }];
    [self.bufferingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(100.0f, 100.0f));
    }];
}

#pragma mark - notification
- (void)setupObserver {
    // 2G / wifi
    Reachability *r = [Reachability reachabilityForInternetConnection];
    // 播放中，网络切换为2G
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
        @strongify(self); if (!self) return;
        if ([x unsignedIntegerValue] == PlayerView_State_Buffering) {
            self.bufferingView.hidden = NO;
            [self.bufferingView start];
        } else {
            self.bufferingView.hidden = YES;
            [self.bufferingView stop];
        }
        switch ([x unsignedIntegerValue]) {
            case PlayerView_State_Buffering:
                DDLogInfo(@"buffering");
                break;
            case PlayerView_State_Playing:
                DDLogInfo(@"Playing");
    [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"音频全屏浏览-stop"] forState:UIControlStateNormal];                break;
            case PlayerView_State_Paused:
                DDLogInfo(@"Paused");
                    [self.bottomView.playPauseButton setImage:[UIImage imageNamed:@"音频全屏浏览-play"] forState:UIControlStateNormal];
                break;
            case PlayerView_State_Finished:
                DDLogInfo(@"Finished");
                BLOCK_EXEC(self.backBlock);
                break;
            case PlayerView_State_Error:
            {
                DDLogError(@"Error");
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
                                                      @strongify(self); if (!self) return;
                                                      if ([value boolValue]) {
                                                          self.bufferingView.hidden = YES;
                                                          [self.bufferingView stop];
//                                                          [self showTop];
//                                                          [self showBottom];
//                                                          self.bTopBottomHidden = NO;
//                                                          [self resetTopBottomHideTimer];
//                                                          self.gestureView.userInteractionEnabled = YES;
                                                      }
                                                  }];
    
    RACDisposable *r2 = [RACObserve(self.player, duration) subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
        self.bottomView.slideProgressView.duration = [x doubleValue];
        if (self.bottomView.slideProgressView.bufferProgress > 0) {
            [self.bottomView.slideProgressView updateUI];
        }
    }];
    
    RACDisposable *r3 = [RACObserve(self.player, timeBuffered) subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
        if (self.bottomView.slideProgressView.bSliding) {
            return;
        }
        
        if (self.bottomView.slideProgressView.duration > 0) {
            self.bottomView.slideProgressView.bufferProgress = [x floatValue] / self.bottomView.slideProgressView.duration;
            if (self.bottomView.slideProgressView.bufferProgress > 0) {
                [self.bottomView.slideProgressView updateUI];
            }
        }
    }];
    
    RACDisposable *r4 = [RACObserve(self.player, timePlayed) subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
        if (self.bottomView.slideProgressView.bSliding) {
            return;
        }
        
        if (self.bottomView.slideProgressView.duration > 0) {
            self.bottomView.slideProgressView.playProgress = [x floatValue] / self.bottomView.slideProgressView.duration;
            if (self.bottomView.slideProgressView.playProgress > 0) { // walkthrough 换url时slide跳动
                [self.bottomView.slideProgressView updateUI];
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

#pragma mark - button Action
- (void)playAndPauseButtonAction:(UIButton *)sender{
    
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
@end
