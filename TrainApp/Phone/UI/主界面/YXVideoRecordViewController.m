//
//  YXVideoRecordViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
#define PATH_OF_DOCUMENT         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_OF_VIDEO   [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"VideoRecord"]
#import "YXVideoRecordViewController.h"
#import "YXGetQiNiuTokenRequest.h"
#import "YXQiNiuVideoUpload.h"
@interface YXVideoRecordViewController()<SCRecorderDelegate, SCAssetExportSessionDelegate>
{
    BOOL _stateBool;
    UIView * _scanPreviewView;
    YXQiNiuVideoUpload *upload;
}
@property (nonatomic, strong) SCRecorder    *recorder;
@property (strong, nonatomic) SCRecorderToolsView *focusView;
@property (nonatomic, strong) SCPlayer  *player;
@property (nonatomic, strong) SCAssetExportSession *exportSession;
@property (nonatomic, strong) YXGetQiNiuTokenRequest *getQiNiuTokenRequest;


@end

@implementation YXVideoRecordViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    _scanPreviewView = [[UIView alloc] init];
    _scanPreviewView.frame = CGRectMake(0, 0, 320, 320);
    _scanPreviewView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scanPreviewView];
    
    self.recorder = [SCRecorder recorder];
    self.recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    self.recorder.maxRecordDuration = CMTimeMake(30 * 2400, 30);
    self.recorder.delegate = self;
    self.recorder.autoSetVideoOrientation = YES;
    self.recorder.initializeSessionLazily = NO;
    self.recorder.videoConfiguration.size = CGSizeMake(321, 321);
    self.recorder.previewView = _scanPreviewView;
    _focusView = [[SCRecorderToolsView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _focusView.recorder = self.recorder;
    _focusView.outsideFocusTargetImage = [UIImage imageNamed:@"03动态详情页UI-附件全屏浏览-按下效果-修改版"];
    [_scanPreviewView addSubview:_focusView];
    
    UIButton *stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stateButton.frame = CGRectMake(0, 30, 40, 40);
    stateButton.backgroundColor = [UIColor blueColor];
    [stateButton addTarget:self action:@selector(gotoLuzhi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stateButton];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 30, 40, 40);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(gotoZanting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(100, 30, 40, 40);
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(gotoBaocun) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(150, 30, 40, 40);
    button3.backgroundColor = [UIColor redColor];
    [button3 addTarget:self action:@selector(gotoShangchuan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
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
}

- (void)gotoLuzhi{
    [self.recorder record];
}

- (void)gotoZanting{
    [self.recorder pause];
    @weakify(self);
    [self.recorder pause:^{
        @strongify(self);
        [self configPreviewView];
        
    }];
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


- (void)gotoBaocun{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    self.exportSession = [[SCAssetExportSession alloc] initWithAsset:_recorder.session.assetRepresentingSegments];
    self.exportSession.videoConfiguration.preset = SCPresetHighestQuality;
    self.exportSession.videoConfiguration.sizeAsSquare = NO;
    self.exportSession.videoConfiguration.size = CGSizeMake(320, 320);
    self.exportSession.videoConfiguration.maxFrameRate = 35;
    
    self.exportSession.outputFileType = AVFileTypeMPEG4;
    self.exportSession.delegate = self;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:PATH_OF_VIDEO]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:PATH_OF_VIDEO withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //    self.progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    //    self.progressHUD.delegate = self;
    //    self.progressHUD.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    //    self.progressHUD.mode = MBProgressHUDModeDeterminate;
    
    //    NSString *videoPathName = [NSString stringWithFormat:@"%@.mp4",self.videoModel.jobid];
    NSString *videoPathName = @"1129632018079.mp4";
    self.exportSession.outputUrl = [NSURL fileURLWithPath:[PATH_OF_VIDEO stringByAppendingPathComponent:videoPathName]];
    CFTimeInterval time = CACurrentMediaTime();
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
        [self.player play];
        NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if (!self.exportSession.error) {
            NSLog(@"成功");
            //            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            //            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            //            [YXVideoRecordManager cleartmpFile];
            //            NSArray * nameArray = [[NSFileManager defaultManager] componentsToDisplayForPath:self.exportSession.outputUrl];
            
        }
        else{
            NSLog(@"失败");
        }
    }];
}
- (void)gotoShangchuan{
    self.getQiNiuTokenRequest = [[YXGetQiNiuTokenRequest alloc] init];
    [self.getQiNiuTokenRequest  startRequestWithRetClass:[YXGetQiNiuTokenRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        YXGetQiNiuTokenRequestItem *item = retItem;
        NSLog(@"%@",item.uploadToken);
        upload = [[YXQiNiuVideoUpload alloc] initWithFileName:@"1129632018079.mp4" qiNiuToken:item.uploadToken];
        [upload  startUpload];
        
    }];
    
}

- (BOOL)shouldAutorotate{
    if (_stateBool) {
        return NO;
    }
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    _scanPreviewView.frame = CGRectMake(0, 0, size.width, size.height);
    self.recorder.previewView = _scanPreviewView;
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
