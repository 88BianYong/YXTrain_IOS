//
//  YXFileBrowseManager.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileBrowseManager.h"
#import "UrlDownloader.h"
#import "YXFileDownloadProgressView.h"
#import "YXQLPreviewController.h"
#import "YXFileFavorWrapper.h"
#import "YXImageViewController.h"
#import "YXTOWebViewController.h"
#import "YXPlayerViewController.h"
#import "YXAudioPlayerViewController.h"
#import "YXNavigationController.h"
#import "YXBroseWebView.h"

@interface YXFileBrowseManager()<YXBrowserExitDelegate,YXFileFavorDelegate,YXPlayProgressDelegate,YXBrowseTimeDelegate>
@property (nonatomic, strong) UrlDownloader *downloader;
@property (nonatomic, strong) id favorData;
@property (nonatomic, copy) void(^addFavorCompleteBlock)();
@end

@implementation YXFileBrowseManager

+ (instancetype)sharedManager{
    static YXFileBrowseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXFileBrowseManager alloc] init];
    });
    return manager;
}

- (void)clear{
    self.fileItem = nil;
    self.baseViewController = nil;
    self.downloader = nil;
    self.favorData = nil;
    self.addFavorCompleteBlock = nil;
}

- (void)addFavorWithData:(id)data completion:(void(^)())completeBlock{
    self.favorData = data;
    self.addFavorCompleteBlock = completeBlock;
}

- (void)browseFile{
    if (self.fileItem.isLocal) {
        if (self.fileItem.type == YXFileTypePhoto) {
            [self openPic:self.fileItem.url];
        }else if(self.fileItem.type == YXFileTypeVideo){
            [self openVideo];
        }else{
            [self openDoc:self.fileItem.url];
        }
    }else{
        [self checkNetwork];
    }
}

- (void)checkNetwork {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (![r isReachable]) {
        [self.baseViewController showToast:@"网络异常,请稍候重试"];
        return;
    }
    
    if ([r isReachableViaWWAN] && ![r isReachableViaWiFi]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"网络连接提示" message:@"当前处于非Wi-Fi环境，仍要继续吗？" preferredStyle:UIAlertControllerStyleAlert];
        WEAK_SELF
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            return;
        }];
        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF
            [self browseOnlineFile];
        }];
        [alertVC addAction:backAction];
        [alertVC addAction:goAction];
        [self managerPresentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    [self browseOnlineFile];
}

- (void)browseOnlineFile{
    if (self.fileItem.type == YXFileTypeVideo) {
        [self openVideo];
    }else if (self.fileItem.type == YXFileTypeAudio) {
        [self openAudio];
    }else if (self.fileItem.type == YXFileTypeHtml) {
        [self openHtml];
    }else {
        [self startDownload];
    }
}

- (void)startDownload{
    self.downloader = [[UrlDownloader alloc]init];
    [self.downloader setModel:self.fileItem.url];
    NSString *des = [self.downloader desFilePath];
    NSData *desData = [NSData dataWithContentsOfFile:des];
    if (des && desData && desData.length > 0) {
        if (self.fileItem.type == YXFileTypePhoto) {
            [self openPic:des];
        }else{
            [self openDoc:des];
        }
        return;
    }
    
    YXFileDownloadProgressView *progressView = [[YXFileDownloadProgressView alloc] init];
    WEAK_SELF
    [RACObserve(self.downloader, progress) subscribeNext:^(id x) {
        STRONG_SELF
        progressView.progress = [x floatValue];
    }];
    [RACObserve(self.downloader, state) subscribeNext:^(id x) {
        STRONG_SELF
        if ([x intValue] == DownloadStatusFinished) {
            [progressView removeFromSuperview];
            
            if (self.fileItem.type == YXFileTypePhoto) {
                [self openPic:des];
            }else{
                [self openDoc:des];
            }
        }
        
        if ([x intValue] == DownloadStatusFailed) {
            [progressView removeFromSuperview];
            [self.baseViewController showToast:@"加载失败"];
        }
    }];
    progressView.frame = [UIScreen mainScreen].bounds;
    progressView.titleLabel.text  =@"文件加载中...";
    [self.baseViewController.view.window addSubview:progressView];
    progressView.closeBlock = ^() {
        STRONG_SELF
        [self.downloader stop];
    };
    
    [self.downloader start];
}

#pragma mark - Open file
- (void)openDoc:(NSString *)path{
    YXQLPreviewController *qlVC = [[YXQLPreviewController alloc]init];
    qlVC.qlUrl = path;
    qlVC.qlTitle = self.fileItem.name;
    
    if (![qlVC canPreview]) {
        [self.baseViewController showToast:@"该文件无法预览"];
        return;
    }
    
    if (self.favorData) {
        YXFileFavorWrapper *wrapper = [[YXFileFavorWrapper alloc]initWithData:self.favorData baseVC:qlVC];
        wrapper.delegate = self;
        qlVC.favorWrapper = wrapper;
    }
    qlVC.exitDelegate = self;
    qlVC.browseTimeDelegate = self;
    [self managerPresentViewController:qlVC animated:YES completion:nil];
}

- (void)openPic:(NSString *)path{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (!image) {
        [self.baseViewController showToast:@"该文件无法预览"];
        return;
    }
    YXImageViewController *vc = [[YXImageViewController alloc] init];
    if (self.favorData) {
        YXFileFavorWrapper *wrapper = [[YXFileFavorWrapper alloc]initWithData:self.favorData baseVC:vc];
        wrapper.delegate = self;
        vc.favorWrapper = wrapper;
    }
    vc.image = image;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.title = self.fileItem.name;
    vc.exitDelegate = self;
    
    YXNavigationController *navi = [[YXNavigationController alloc]initWithRootViewController:vc];
    [self managerPresentViewController:navi animated:YES completion:nil];
}

- (void)openHtml{
    //    YXTOWebViewController * webViewController = [[YXTOWebViewController alloc] initWithURLString:self.fileItem.url];
    //    webViewController.title = self.fileItem.name;
    //    webViewController.showPageTitles = NO;
    //    webViewController.exitDelegate = self;
    //    webViewController.browseTimeDelegate = self;
    //    [self.baseViewController.navigationController pushViewController:webViewController animated:YES];
    YXBroseWebView *webView = [[YXBroseWebView alloc] init];
    webView.urlString = self.fileItem.url;
    webView.titleString = self.fileItem.name;
    webView.exitDelegate = self;
    webView.browseTimeDelegate = self;
    [self.baseViewController.navigationController pushViewController:webView animated:YES];
}

- (void)openVideo{
    YXPlayerViewController *vc = [[YXPlayerViewController alloc] init];
    if (self.favorData) {
        YXFileFavorWrapper *wrapper = [[YXFileFavorWrapper alloc]initWithData:self.favorData baseVC:vc];
        wrapper.delegate = self;
        vc.favorWrapper = wrapper;
    }
    YXFileVideoItem *videoItem = (YXFileVideoItem *)self.fileItem;
    vc.videoUrl = videoItem.url;
    
    YXPlayerDefinition *d0 = [[YXPlayerDefinition alloc] init];
    d0.identifier = @"流畅";
    d0.url = videoItem.lurl;
    
    YXPlayerDefinition *d1 = [[YXPlayerDefinition alloc] init];
    d1.identifier = @"标清";
    d1.url = videoItem.murl;
    
    YXPlayerDefinition *d2 = [[YXPlayerDefinition alloc] init];
    d2.identifier = @"高清";
    d2.url = videoItem.surl;
    
    vc.definitionArray = @[d0, d1, d2];
    
    vc.title = videoItem.name;
    vc.delegate = self;
    vc.exitDelegate = self;
    vc.isPreRecord = videoItem.isDeleteVideo;
    [self managerPresentViewController:vc animated:YES completion:nil];
}

- (void)openAudio{
    YXAudioPlayerViewController *vc = [[YXAudioPlayerViewController alloc] init];
    if (self.favorData) {
        YXFileFavorWrapper *wrapper = [[YXFileFavorWrapper alloc]initWithData:self.favorData baseVC:vc];
        wrapper.delegate = self;
        vc.favorWrapper = wrapper;
    }
    vc.videoUrl = self.fileItem.url;
    vc.title = self.fileItem.name;
    vc.delegate = self;
    vc.exitDelegate = self;
    [self managerPresentViewController:vc animated:YES completion:nil];
}

#pragma mark - YXBrowserExitDelegate
- (void)browserExit{
    [self clear];
    if ([YXRecordManager sharedManager].isActive) {
        [[YXRecordManager sharedManager]report];
    }
}

#pragma mark - YXPlayProgressDelegate
- (void)playerProgress:(CGFloat)progress totalDuration:(NSTimeInterval)duration stayTime:(NSTimeInterval)time{
    if ([YXRecordManager sharedManager].isActive) {
        [[YXRecordManager sharedManager]updateFragmentWithDuration:duration record:duration*progress watchedTime:time];
    }
    NSInteger min = time / 60;
    NSInteger sec = (NSInteger)time % 60;
    NSString *playTime = [NSString stringWithFormat:@"%02zd分:%02zd秒",min,sec];
    NSDictionary *dict = @{
                           @"时长": playTime
                           };
    if (self.fileItem.sourceType == YXSourceTypeCourse) {
        [YXDataStatisticsManger trackEvent:@"课程播放" label:@"播放视频课程" parameters:dict];
    }
    if (self.fileItem.sourceType == YXSourceTypeTaskNoUploadedVideos) {
        [YXDataStatisticsManger trackEvent:@"未上传视频操作" label:@"未上传时播放视频" parameters:dict];
    }
}
- (CGFloat)preProgress{
    if ([YXRecordManager sharedManager].isActive) {
        return [[YXRecordManager sharedManager]preProgress];
    }
    return 0;
}
#pragma mark - YXBrowseTimeDelegate
- (void)browseTimeUpdated:(NSTimeInterval)time{
    if ([YXRecordManager sharedManager].isActive) {
        [[YXRecordManager sharedManager]updateFragmentWithFileBrowseTime:time];
    }
}

#pragma mark - YXFileFavorDelegate
- (void)fileDidFavor{
    BLOCK_EXEC(self.addFavorCompleteBlock);
}

- (void)managerPresentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion{
    [[self.baseViewController visibleViewController] presentViewController:viewControllerToPresent animated:YES completion:completion];
}





@end
