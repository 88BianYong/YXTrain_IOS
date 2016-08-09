//
//  YXVideoRecordViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
#import "YXVideoRecordViewController.h"
#import "YXGetQiNiuTokenRequest.h"
#import "YXQiNiuVideoUpload.h"
#import "YXVideoRecordTopView.h"
#import "YXVideoRecordBottomView.h"
#import "YXSaveVideoProgressView.h"
#import "YXVideoRecordManager.h"
#import "YXNotAutorotateView.h"
#import "YXHomeworkInfoRequest.h"
#import "YXAlertCustomView.h"
@interface YXVideoRecordViewController()<SCRecorderDelegate, SCAssetExportSessionDelegate>
{
    BOOL _stateBool;
    UIView * _scanPreviewView;
    YXQiNiuVideoUpload *upload;
    YXVideoRecordTopView *_topView;
    YXVideoRecordBottomView *_bottomView;
    NSTimer *_startRecordTimer;
    UIView *_statusBar;
    YXSaveVideoProgressView *_progressView;
    
}
@property (nonatomic, strong) SCRecorder    *recorder;
@property (nonatomic, strong) SCRecorderToolsView *focusView;
@property (nonatomic, strong) SCPlayer  *player;
@property (nonatomic, strong) SCAssetExportSession *exportSession;
@property (nonatomic, strong) YXGetQiNiuTokenRequest *getQiNiuTokenRequest;
@property (nonatomic, copy) void(^completionHandle)(NSURL *url, NSError *error);
@property (nonatomic, strong) YXNotAutorotateView *autorotateView;


@end

@implementation YXVideoRecordViewController
- (void)dealloc{
    DDLogDebug(@"release=====>%@",NSStringFromClass([self class]));
}

- (YXNotAutorotateView *)autorotateView{
    if (!_autorotateView) {
        _autorotateView = [[YXNotAutorotateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidthScale(270.0f), kScreenHeightScale(60.0f))];
        _autorotateView.center = self.view.center;
        _autorotateView.hidden = YES;
    }
    return _autorotateView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
    [self layoutInterface:CGSizeMake(kScreenWidth, kScreenHeight)];
}

- (void)setupUI{
    NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9] encoding:NSASCIIStringEncoding];
    id object = [UIApplication sharedApplication];
    if ([object respondsToSelector:NSSelectorFromString(key)]) {
        _statusBar = [object valueForKey:key];
    }
    
    _scanPreviewView = [[UIView alloc] init];
    _scanPreviewView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scanPreviewView];
    
    self.recorder = [SCRecorder recorder];
    self.recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    self.recorder.maxRecordDuration = CMTimeMake(30 * 2400, 30);
    self.recorder.delegate = self;
    self.recorder.autoSetVideoOrientation = YES;
    self.recorder.initializeSessionLazily = NO;
    _focusView = [[SCRecorderToolsView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _focusView.recorder = self.recorder;
    _focusView.outsideFocusTargetImage = [UIImage imageNamed:@"03动态详情页UI-附件全屏浏览-按下效果-修改版"];
    [_scanPreviewView addSubview:_focusView];
    _topView = [[YXVideoRecordTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.0f)];
    [self.view addSubview:_topView];
    
    _bottomView = [[YXVideoRecordBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight -  110.0f, kScreenWidth, 110.0f)];
    [self.view addSubview:_bottomView];
    
    _progressView = [[YXSaveVideoProgressView alloc] initWithFrame:CGRectMake(0, 0, 143.0f , 143.0f)];
    _progressView.hidden = YES;
    [self.view addSubview:_progressView];
    [self setupHandler];
    [self.view addSubview:self.autorotateView];
}
- (void)setupHandler{
    WEAK_SELF
    _bottomView.recordHandler = ^(YXVideoRecordStatus recordStatus){
        STRONG_SELF
        _stateBool = YES;
        [self ->_topView stopAnimatetion];
        switch (recordStatus) {
            case YXVideoRecordStatus_Ready:
            {
                _stateBool = NO;
            }
                break;
            case YXVideoRecordStatus_Recording:
            {
                
                [self ->_topView startAnimatetion];
                [self.recorder record];
            }
                break;
            case YXVideoRecordStatus_Pause:{
                [self.recorder pause];
            }
                break;
            case YXVideoRecordStatus_Delete:
            {
                YXAlertAction *waiverAlertAct = [[YXAlertAction alloc] init];
                waiverAlertAct.title = @"放弃";
                waiverAlertAct.style = YXAlertActionStyleCancel;
                waiverAlertAct.block = ^(id sender) {
                    STRONG_SELF
                    self ->_bottomView.videoRecordStatus = YXVideoRecordStatus_Ready;
                    [self stopCaptureWithSaveFlag:NO];
                    self ->_topView.recordTime = 0.0f;
                };
                YXAlertAction *cancelAlertAct = [[YXAlertAction alloc] init];
                cancelAlertAct.title = @"取消";
                cancelAlertAct.style = YXAlertActionStyleDefault;
                cancelAlertAct.block = ^(id sender) {
                    STRONG_SELF
                };
                YXAlertCustomView *alertView = [YXAlertCustomView alertViewWithTitle:@"确定放弃已录制的视频?" image:@"胶卷" actions:@[waiverAlertAct,cancelAlertAct]];
                [alertView showAlertView:self.view];
            }
                break;
            case YXVideoRecordStatus_StopMax:
            {
                [self stopCaptureWithSaveFlag:YES];
            }
                break;
            case YXVideoRecordStatus_Save:
            {
                [self saveRecordVideo];
            }
                break;
            default:
                break;
        }
    };
    
    _topView.cancleHandler = ^{
        STRONG_SELF
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
    _topView.frame = CGRectMake(0, 0, size.width, 44.0f);
    _bottomView.frame = CGRectMake(0, size.height -  110.0f, size.width, 110.0f);
    _progressView.center = self.view.center;
    self.recorder.videoConfiguration.size = size;
    self.recorder.previewView = _scanPreviewView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.recorder.session == nil) {
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeMPEG4;
        self.recorder.session = session;
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self.recorder startRunning];
    _statusBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _statusBar.hidden = NO;
}

#pragma mark - recordVideo saveVideo so on
- (void)stopCaptureWithSaveFlag:(BOOL)saveFlag
{
    WEAK_SELF
    [self.recorder pause:^{
        STRONG_SELF
        if (saveFlag) {
            //TODO 出现保存界面。
            [self configPreviewView];
        }else{
            SCRecordSession *recordSession = _recorder.session;
            if (recordSession != nil) {
                _recorder.session = nil;
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

- (void)configPreviewView
{
    self.player = [SCPlayer player];
    SCVideoPlayerView   *playerView = [[SCVideoPlayerView alloc] initWithPlayer:self.player];
    playerView.tag = 555;
    playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerView.frame = _scanPreviewView.bounds;
    playerView.autoresizingMask = _scanPreviewView.autoresizingMask;
    [_scanPreviewView addSubview:playerView];
    self.player.loopEnabled = YES;
    [self.player setItemByAsset:self.recorder.session.assetRepresentingSegments];
    [self.player play];
}


- (void)saveRecordVideo{
    _progressView.hidden = NO;
    WEAK_SELF
    self.completionHandle = ^(NSURL *url, NSError *error){
        STRONG_SELF
        if (error != nil) {
            [self saveSuccessWithVideoPath:url.path];
        } else {
            YXAlertAction *cancelAlertAct = [[YXAlertAction alloc] init];
            cancelAlertAct.title = @"取消";
            cancelAlertAct.style = YXAlertActionStyleCancel;
            cancelAlertAct.block = ^(id sender) {
                STRONG_SELF
            };
            
            YXAlertAction *retryAlertAct = [[YXAlertAction alloc] init];
            retryAlertAct.title = @"重试";
            retryAlertAct.style = YXAlertActionStyleDefault;
            retryAlertAct.block = ^(id sender) {
                STRONG_SELF
                [self saveRecordVideo];
            };

            YXAlertCustomView *alertView = [YXAlertCustomView alertViewWithTitle:@"视频保存失败" image:@"失败icon" actions:@[cancelAlertAct,retryAlertAct]];
            [alertView showAlertView:self.view];
            
            
            
            DDLogError(@"%@",error.localizedDescription);
        }
    };
    self.exportSession = [[SCAssetExportSession alloc] initWithAsset:_recorder.session.assetRepresentingSegments];
    self.exportSession.videoConfiguration.preset = SCPresetLowQuality;
    self.exportSession.videoConfiguration.sizeAsSquare = NO;
    self.exportSession.videoConfiguration.size = self.view.frame.size;
    self.exportSession.videoConfiguration.maxFrameRate = 35;
    self.exportSession.outputFileType = AVFileTypeMPEG4;
    self.exportSession.delegate = self;
    if (![[NSFileManager defaultManager] fileExistsAtPath:PATH_OF_VIDEO]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:PATH_OF_VIDEO withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *videoPathName = [NSString stringWithFormat:@"%@.mp4",[YXVideoRecordManager getFileNameWithJobId:self.videoModel.requireId]];
    self.exportSession.outputUrl = [NSURL fileURLWithPath:[PATH_OF_VIDEO stringByAppendingPathComponent:videoPathName]];
    CFTimeInterval time = CACurrentMediaTime();
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
        STRONG_SELF
        [self.player play];
        self ->_topView.recordTime = 0.0f;
        self.completionHandle(self.exportSession.outputUrl, self.exportSession.error);
        DDLogDebug(@"Completed compression in %fs", CACurrentMediaTime() - time);
        self -> _progressView.hidden = YES;
    }];
}
//保存成功视频之后
- (void)saveSuccessWithVideoPath:(NSString *)videoPath
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [YXVideoRecordManager cleartmpFile];
    NSArray * nameArray = [[NSFileManager defaultManager] componentsToDisplayForPath:videoPath];
    self.videoModel.fileName = nameArray.lastObject;
    self.videoModel.filePath = videoPath;
    self.videoModel.lessonStatus = YXVideoLessonStatus_AlreadyRecord;
    [YXVideoRecordManager saveVideoArrayWithModel:self.videoModel];
    _bottomView.videoRecordStatus = YXVideoRecordStatus_Ready;
    [self removePreviewView];
 //   [self gotoShangchuan];
}
- (void)removePreviewView
{
    [self.player pause];
    self.player = nil;
    for (UIView *subview in _scanPreviewView.subviews) {
        if (subview.tag == 555) {
            [subview removeFromSuperview];
        }
    }
    [self stopCaptureWithSaveFlag:NO];
}

- (void)gotoShangchuan{
    self.getQiNiuTokenRequest = [[YXGetQiNiuTokenRequest alloc] init];
    [self.getQiNiuTokenRequest  startRequestWithRetClass:[YXGetQiNiuTokenRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        YXGetQiNiuTokenRequestItem *item = retItem;
        upload = [[YXQiNiuVideoUpload alloc] initWithFileName:self.videoModel.fileName qiNiuToken:item.uploadToken];
        [upload  startUpload];
    }];
}

- (BOOL)shouldAutorotate{
    if (_stateBool) {
        if (self.autorotateView.hidden) {
            self.autorotateView.hidden = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.autorotateView.hidden = YES;
            });
        }
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
        _progressView.progress = progress;
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

- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSegment:(SCRecordSessionSegment *__nullable)segment inSession:(SCRecordSession *__nonnull)session error:(NSError *__nullable)error {
//    self.isComplete = YES;
//    if (self.isSaveVideo) {
//        self.isComplete = NO;
//        self.isSaveVideo = NO;
//        [self saveRecordVideo];
//    }
}
@end
