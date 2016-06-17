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

@interface YXFileBrowseManager()<YXBrowserExitDelegate,YXFileFavorDelegate>
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
        [self.baseViewController showToast:@"网络异常，请稍候重试"];
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
        [self.baseViewController presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    [self browseOnlineFile];
}

- (void)browseOnlineFile{
    if (self.fileItem.type == YXFileTypeVideo) {
        
    }else if (self.fileItem.type == YXFileTypeAudio) {
        
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
            [self.baseViewController showToast:@"下载失败"];
        }
    }];
    progressView.frame = [UIScreen mainScreen].bounds;
    progressView.titleLabel.text  =@"文件下载中...";
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
        YXFileFavorWrapper *wrapper = [[YXFileFavorWrapper alloc]initWithData:self.favorData baseVC:(YXBaseViewController *)qlVC];
        wrapper.delegate = self;
        qlVC.favorWrapper = wrapper;
    }
    qlVC.exitDelegate = self;
    [self.baseViewController presentViewController:qlVC animated:YES completion:nil];
}

- (void)openPic:(NSString *)path{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (!image) {
        [self.baseViewController showToast:@"该文件无法预览"];
        return;
    }
    YXImageViewController *vc = [[YXImageViewController alloc] init];
    if (!self.favorData) {
        YXFileFavorWrapper *wrapper = [[YXFileFavorWrapper alloc]initWithData:self.favorData baseVC:vc];
        wrapper.delegate = self;
        vc.favorWrapper = wrapper;
    }
    vc.image = image;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.title = self.fileItem.name;
    vc.exitDelegate = self;
    [self.baseViewController presentViewController:vc animated:NO completion:nil];
}

- (void)openHtml{
    YXTOWebViewController * webViewController = [[YXTOWebViewController alloc] initWithURLString:self.fileItem.url];
    webViewController.title = self.fileItem.name;
    webViewController.showPageTitles = NO;
    [self.baseViewController.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - YXBrowserExitDelegate
- (void)browserExit{
    [self clear];
}

#pragma mark - YXFileFavorDelegate
- (void)fileDidFavor{
    BLOCK_EXEC(self.addFavorCompleteBlock);
}






@end
