//
//  YXVideoRecordViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
#import "YXVideoRecordViewController.h"
#import "YXVideoRecordTopView.h"
#import "YXVideoRecordBottomView.h"
#import "YXSaveVideoProgressView.h"
#import "YXVideoRecordManager.h"
#import "YXNotAutorotateView.h"
#import "YXHomeworkInfoRequest.h"
@interface YXVideoRecordViewController()<SCRecorderDelegate, SCAssetExportSessionDelegate>
{
    BOOL _stateBool;
    UIView * _scanPreviewView;
    YXVideoRecordTopView *_topView;
    YXVideoRecordBottomView *_bottomView;
    NSTimer *_startRecordTimer;
    UIView *_statusBar;
    YXSaveVideoProgressView *_progressView;
    UIDeviceOrientation _deviceOrientation;
    NSInteger _againInteger;
}
@property (nonatomic, strong) SCRecorder    *recorder;
@property (nonatomic, strong) SCRecorderToolsView *focusView;
//@property (nonatomic, strong) SCPlayer  *player;
@property (nonatomic, strong) SCAssetExportSession *exportSession;
@property (nonatomic, copy) void(^completionHandle)(NSURL *url, NSError *error ,BOOL cancle);
@property (nonatomic, strong) YXNotAutorotateView *autorotateView;
@property (nonatomic, strong) NSTimer *timer;



@end

@implementation YXVideoRecordViewController
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopTimer];
    self->_focusView.recorder = nil;
}

- (YXNotAutorotateView *)autorotateView{
    if (!_autorotateView) {
        _autorotateView = [[YXNotAutorotateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidthScale(270.0f), kScreenHeightScale(60.0f))];
        _autorotateView.center = self.view.center;
        _autorotateView.hidden = YES;
    }
    return _autorotateView;
}
- (SCAssetExportSession *)exportSession{
    if (!_exportSession) {
        _exportSession = [[SCAssetExportSession alloc] init];
    }
    return _exportSession;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil]; 
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];// TD: fix bug 192
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector (deviceOrientationDidChange:)
                                                 name: UIDeviceOrientationDidChangeNotification
                                               object: nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self.recorder startRunning];
    [self layoutInterface:CGSizeMake(kScreenWidth, kScreenHeight)];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _statusBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.recorder stopRunning];
}

- (void)deviceOrientationDidChange:(NSNotification *)noti {
//    _statusBar.hidden = YES;
//    if ([UIDevice currentDevice].orientation == UIDeviceOrientationFaceUp  || [UIDevice currentDevice].orientation == UIDeviceOrientationFaceDown || [UIDevice currentDevice].orientation == UIDeviceOrientationUnknown ||  _deviceOrientation == [UIDevice currentDevice].orientation) {
//    }
//    else{
//        if (self.autorotateView.hidden && _bottomView.videoRecordStatus == YXVideoRecordStatus_Recording) {
//            self.autorotateView.hidden = NO;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.autorotateView.hidden = YES;
//            });
//        }
//    }
}



- (void)setupUI{
    _scanPreviewView = [[UIView alloc] init];
    _scanPreviewView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scanPreviewView];
    
    self.recorder = [SCRecorder recorder];
    self.recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    self.recorder.maxRecordDuration = CMTimeMake(20 * 2400, 20);
    self.recorder.delegate = self;
    self.recorder.autoSetVideoOrientation = YES;
    self.recorder.initializeSessionLazily = NO;
    SCRecordSession *session = [SCRecordSession recordSession];
    session.fileType = AVFileTypeMPEG4;
    self.recorder.session = session;
    [_scanPreviewView addSubview:_focusView];
    _focusView = [[SCRecorderToolsView alloc] initWithFrame:_scanPreviewView.frame];
    _focusView.recorder = self.recorder;
    _focusView.outsideFocusTargetImage = [[UIImage alloc] init];
    [_scanPreviewView addSubview:_focusView];
    _topView = [[YXVideoRecordTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.0f)];
    _topView.hidden = YES;
    [self.view addSubview:_topView];
    
    _bottomView = [[YXVideoRecordBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight -  110.0f, kScreenWidth, 110.0f)];
    _bottomView.hidden = YES;
    [self.view addSubview:_bottomView];
    
    _progressView = [[YXSaveVideoProgressView alloc] initWithFrame:CGRectMake(0, 0, 150.0f , 150.0f)];
    _progressView.titleString = @"视频保存中...";
    _progressView.hidden = YES;
    [_progressView isShowView:self.view];
    [self setupHandler];
    [self.view addSubview:self.autorotateView];
    NSError *error;
    if (![self->_recorder prepare:&error]) {
        DDLogError(@"Prepare error: %@", error.localizedDescription);
    }
}
- (void)setupHandler{
    WEAK_SELF
    _bottomView.recordHandler = ^(YXVideoRecordStatus recordStatus){
        STRONG_SELF
        self ->_stateBool = YES;
        self.recorder.autoSetVideoOrientation = NO;
        [self ->_topView stopAnimatetion];
        switch (recordStatus) {
            case YXVideoRecordStatus_Ready:
            {
                self->_stateBool = NO;
                self.recorder.autoSetVideoOrientation = YES;
                self ->_topView.canleButton.hidden = NO;
            }
                break;
            case YXVideoRecordStatus_Recording:
            {
                self ->_deviceOrientation = [UIDevice currentDevice].orientation;
                [self ->_topView startAnimatetion];
                [self.recorder record];
                self.autorotateView.hidden = NO;
                [self startTimer];
                [self timerAction];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.autorotateView.hidden = YES;
                });

            }
                break;
            case YXVideoRecordStatus_Pause:{
                [self.recorder pause];
                [self stopTimer];
            }
                break;
            case YXVideoRecordStatus_Delete:
            {
                LSTAlertView *alertView = [[LSTAlertView alloc]init];
                alertView.title = @"确定放弃已录制的视频?";
                alertView.imageName = @"胶卷";
                [alertView addButtonWithTitle:@"放弃" style:LSTAlertActionStyle_Cancel action:^{
                    STRONG_SELF
                    self ->_bottomView.videoRecordStatus = YXVideoRecordStatus_Ready;
                    [self stopCaptureWithSaveFlag:NO];
                    self ->_topView.recordTime = 0.0f;
                    [YXDataStatisticsManger trackEvent:@"视频录制" label:@"放弃已录制的视频" parameters:nil];
                }];
                [alertView addButtonWithTitle:@"取消" style:LSTAlertActionStyle_Default action:^{
                    STRONG_SELF
                }];
                [alertView showInView:self.view];
            }
                break;
            case YXVideoRecordStatus_StopMax:
            {
                [self stopTimer];
                self -> _bottomView.videoRecordStatus = YXVideoRecordStatus_Pause;
                LSTAlertView *alertView = [[LSTAlertView alloc]init];
                alertView.title = @"视频时长已达到上限";
                alertView.imageName = @"失败icon";
                [alertView addButtonWithTitle:@"我知道了" style:LSTAlertActionStyle_Alone action:^{
                    STRONG_SELF
                }];
                [alertView show];
            }
                break;
            case YXVideoRecordStatus_Save:
            {
                [self stopTimer];
                self ->_progressView.progress = 0.0f;
                self ->_progressView.hidden = NO;
                self ->_bottomView.userInteractionEnabled = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self saveRecordVideo];
                });//fix bug 245 录制时间过长会保存失败
            }
                break;
            default:
                break;
        }
    };
    
    _topView.cancleHandler = ^{
        STRONG_SELF
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    _progressView.closeHandler = ^{
        STRONG_SELF
        [self.exportSession cancelExport];
    };
}

- (void)layoutInterface:(CGSize)size{    
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    _scanPreviewView.frame = frame;
    _focusView.frame = frame;
    _topView.frame = CGRectMake(0, 0, size.width, 44.0f);
    _topView.hidden = NO;
    _bottomView.frame = CGRectMake(0, size.height -  110.0f, size.width, 110.0f);
    _bottomView.hidden = NO;
    _autorotateView.center = CGPointMake(size.width/2.0f, size.height/2.0f);
    self.recorder.videoConfiguration.size = size;
    self.recorder.previewView = _scanPreviewView;
}

#pragma mark - recordVideo saveVideo so on
- (void)stopCaptureWithSaveFlag:(BOOL)saveFlag
{
    WEAK_SELF
    [self.recorder pause:^{
        STRONG_SELF
        if (!saveFlag) {
            SCRecordSession *recordSession = self->_recorder.session;
            if (recordSession != nil) {
                self ->_recorder.session = nil;
                [recordSession cancelSession:nil];
            }
            [self prepareSession];
        }
    }];
}
- (void)prepareSession {
    if (self.recorder.session == nil) {
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeMPEG4;
        self.recorder.session = session;
    }
}

- (void)saveRecordVideo{
    self ->_againInteger += 1;
    self ->_progressView.progress = 0.0f;
    self ->_progressView.hidden = NO;
    self ->_bottomView.userInteractionEnabled = NO;
    WEAK_SELF
    self.completionHandle = ^(NSURL *url, NSError *error ,BOOL cancle){
        STRONG_SELF
        if (cancle) {
            self ->_againInteger = 0;
            self ->_progressView.hidden = YES;
            self ->_bottomView.userInteractionEnabled = YES;
           DDLogError(@"取消");
            return;
        }
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url.absoluteURL options:nil];
        CMTime itmeTime = asset.duration;
        CGFloat durationTime = CMTimeGetSeconds(itmeTime);
        if (error == nil &&  durationTime > 0.1f) {
            self ->_againInteger = 0;
            [self saveSuccessWithVideoPath:url.path];
        }else{
            if (self ->_againInteger < 6) {//TD:视频保存错误自动重试
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self saveRecordVideo];
                });
            }else{
                self ->_againInteger = 0;
                [self saveVideoFail];
                self ->_progressView.hidden = YES;
                self ->_bottomView.userInteractionEnabled = YES;
            }
        }
    };
    self.exportSession.inputAsset = self->_recorder.session.assetRepresentingSegments;
    self.exportSession.videoConfiguration.preset = SCPresetLowQuality;
    self.exportSession.videoConfiguration.sizeAsSquare = NO;
    self.exportSession.videoConfiguration.size = self.view.frame.size;
    self.exportSession.videoConfiguration.maxFrameRate = 35;
    self.exportSession.outputFileType = AVFileTypeMPEG4;
    self.exportSession.delegate = self;
    if (![[NSFileManager defaultManager] fileExistsAtPath:PATH_OF_VIDEO_RECORD]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:PATH_OF_VIDEO_RECORD withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *videoPathName = [NSString stringWithFormat:@"%@.mp4",[YXVideoRecordManager getFileNameWithJobId:self.videoModel.requireId]];
    self.exportSession.outputUrl = [NSURL fileURLWithPath:[PATH_OF_VIDEO_RECORD stringByAppendingPathComponent:videoPathName]];
    __block CFTimeInterval time = CACurrentMediaTime();
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
        STRONG_SELF
        self.completionHandle(self.exportSession.outputUrl, self.exportSession.error ,self.exportSession.cancelled);
        DDLogDebug(@"Completed compression in %fs", CACurrentMediaTime() - time);
    }];
}
- (void)saveVideoFail {
    LSTAlertView *alertView = [[LSTAlertView alloc]init];
    alertView.title = @"视频保存失败";
    alertView.imageName = @"失败icon";
    WEAK_SELF
    [alertView addButtonWithTitle:@"取消" style:LSTAlertActionStyle_Cancel action:^{
        STRONG_SELF
    }];
    [alertView addButtonWithTitle:@"重试" style:LSTAlertActionStyle_Default action:^{
        STRONG_SELF
        [self saveRecordVideo];
    }];
    [alertView showInView:self.view];
}
//保存成功视频之后
- (void)saveSuccessWithVideoPath:(NSString *)videoPath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:PATH_OF_VIDEO]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:PATH_OF_VIDEO withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [[NSFileManager defaultManager] removeItemAtPath:[PATH_OF_VIDEO stringByAppendingPathComponent:[videoPath lastPathComponent]]  error:nil];
    [[NSFileManager defaultManager] moveItemAtPath:videoPath toPath:[PATH_OF_VIDEO stringByAppendingPathComponent:[videoPath lastPathComponent]] error:nil];
    self ->_progressView.progress = 1.0f;
    self ->_progressView.titleString = @"视频保存成功";
    [YXVideoRecordManager cleartmpFile];
    NSArray * nameArray = [[NSFileManager defaultManager] componentsToDisplayForPath:videoPath];
    self.videoModel.fileName = nameArray.lastObject;
    self.videoModel.lessonStatus = YXVideoLessonStatus_AlreadyRecord;
    [YXVideoRecordManager saveVideoArrayWithModel:self.videoModel];
    [self stopCaptureWithSaveFlag:NO];
    [self trackingEventOfVideoSavedSuccessfully];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self ->_bottomView.videoRecordStatus = YXVideoRecordStatus_Ready;
        self -> _progressView.hidden = YES;
        self ->_bottomView.userInteractionEnabled = YES;
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (BOOL)shouldAutorotate{
    if (_stateBool) {
        return NO;
    }
    else{
           return YES;
    }

}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    [self layoutInterface:size];
}
#pragma mark - SCAssetExportSessionDelegate
- (void)assetExportSessionDidProgress:(SCAssetExportSession *)assetExportSession
{
    dispatch_async(dispatch_get_main_queue(), ^{
        float progress = assetExportSession.progress;
        if (progress < 1.0f) {
            self ->_progressView.titleString = @"视频保存中...";
            self ->_progressView.progress = progress;
        }
    });
}



#pragma mark - SCRecorderDelegate
- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession
{
    CGFloat durationTime = CMTimeGetSeconds(recordSession.duration);
    _topView.recordTime = (NSInteger)durationTime;
}
- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSession:(SCRecordSession *__nonnull)session
{
    _bottomView.videoRecordStatus = YXVideoRecordStatus_StopMax;
}
#pragma mark - notification
- (void)applicationWillResignActive:(NSNotification *)notification{
    if (_bottomView.videoRecordStatus == YXVideoRecordStatus_Recording){
      _bottomView.videoRecordStatus = YXVideoRecordStatus_Pause;
    }
    if (_bottomView.videoRecordStatus == YXVideoRecordStatus_Save) {
        [self.exportSession cancelExport];
    }
}
- (void)applicationDidBecomeActive:(NSNotification *)notification{
    NSError *error;
    [self -> _recorder unprepare];
    if (![self->_recorder prepare:&error]) {
        DDLogError(@"Prepare error: %@", error.localizedDescription);
    }
    self.recorder.videoOrientation = (AVCaptureVideoOrientation)[UIDevice currentDevice].orientation;
    [self.recorder startRunning];
}


- (void)startTimer{
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerAction{
    if ([[YXVideoRecordManager freeSpace] longLongValue] < 180 * 1024 *1024) {
        _bottomView.videoRecordStatus = YXVideoRecordStatus_Pause;
        WEAK_SELF
        LSTAlertView *alertView = [[LSTAlertView alloc]init];
        alertView.title = @"系统空间不足";
        alertView.imageName = @"失败icon";
        [alertView addButtonWithTitle:@"我知道了" style:LSTAlertActionStyle_Alone action:^{
            STRONG_SELF
        }];
        [alertView show];
        [self stopTimer];
    }
}
- (void)trackingEventOfVideoSavedSuccessfully{
    unsigned long long fileSize = 0;
    NSError *error = nil;
    NSString *filePath = [PATH_OF_VIDEO stringByAppendingPathComponent:self.videoModel.fileName];
    CGFloat durationTime = [YXVideoRecordManager videoTimeLenghtForFilePath:filePath];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    fileSize = [[fileAttributes objectForKey:@"NSFileSize"] longLongValue];
    NSString *fileSizeString = [NSString stringWithFormat:@"%@",[NSString sizeStringWithFileSize:fileSize]];
    NSInteger min = durationTime / 60;
    NSInteger sec = (NSInteger)durationTime % 60;
    NSString *videoTimeLength = [NSString stringWithFormat:@"%02zd分:%02zd秒",min,sec];
    if ((fileSize >= 1024) && (fileSize < 1024*1024)) {
        float mb = (float)fileSize / (1024.f*1024.f);
        fileSizeString = [NSString stringWithFormat:@"%.2fM", mb];
    }
    NSDictionary *dict = @{
                           @"时长": videoTimeLength,
                           @"大小": fileSizeString
                           };
    if (!self.isReRecording) {
        [YXDataStatisticsManger trackEvent:@"视频录制" label:@"成功保存已录制的视频" parameters:dict];
    }
    if (self.isReRecording) {
        [YXDataStatisticsManger trackEvent:@"重新录制" label:@"重新录制视频并成功保存" parameters:dict];
    }
}

//- (void)configPreviewView
//{
//    //    self.player = [SCPlayer player];
//    //    SCVideoPlayerView   *playerView = [[SCVideoPlayerView alloc] initWithPlayer:self.player];
//    //    playerView.tag = 555;
//    //    playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    //    playerView.frame = _scanPreviewView.bounds;
//    //    playerView.autoresizingMask = _scanPreviewView.autoresizingMask;
//    //    [_scanPreviewView addSubview:playerView];
//    //    self.player.loopEnabled = YES;
//    //    [self.player setItemByAsset:self.recorder.session.assetRepresentingSegments];
//    //    [self.player play];
//}

@end
