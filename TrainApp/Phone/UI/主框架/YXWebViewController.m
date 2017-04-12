//
//  YXWebViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWebViewController.h"
#import "YXShowWebMenuView.h"
@interface YXWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
//@property (nonatomic, strong) YXErrorView *errorView;
@property (nonatomic, assign) BOOL isShowLoding;
@property (nonatomic, strong) NSTimer *timer;


@end
@implementation YXWebViewController
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
    [self.timer invalidate];
    self.timer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowLoding = YES;
    self.title = self.titleString;
    [self setupLeftBack];
    [self setupRightWithImageNamed:@"更多icon" highlightImageNamed:@"更多icon-点击态"];
    self.webView = [UIWebView new];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];

    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSURL *url = [NSURL URLWithString:self.urlString];
    if (![url.scheme isEqualToString:@"http"] && ![url.scheme isEqualToString:@"https"]) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@",url.resourceSpecifier];
        url = [NSURL URLWithString:urlString];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    [self.webView loadRequest:request];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviRightAction{
    YXShowWebMenuView *menuView = [[YXShowWebMenuView alloc]initWithFrame:self.view.window.bounds];
    menuView.didSeletedItem = ^(NSInteger index) {
        if (index == 0) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]];
        }
        if (index == 1) {
            NSURL *requestURL = [[NSURL alloc] initWithString:self.webView.request.URL.absoluteString];
            [[UIApplication sharedApplication] openURL:requestURL];
        }
        if (index == 2) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.webView.request.URL.absoluteString;
            [self showToast:@"复制成功"];
        }
    };
    [self.view.window addSubview:menuView];
}
- (void)naviLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
    BLOCK_EXEC(self.BackBlock);
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    if (self.isShowLoding) {
        [self startLoading];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (webView.isLoading){
        return;
    }
    [self stopLoading];
    if (self.isUpdatTitle){
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    if(self.errorView) {
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self stopLoading];
    if (error.code == -1009) {
        self.errorView.frame = self.view.bounds;
        if (!self.errorView) {
            WEAK_SELF
            self.errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
            self.errorView.retryBlock = ^{
                STRONG_SELF
                [self startLoading];
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]];
            };
            [self.view addSubview:self.errorView];
        }
    }
}
- (void)timerAction{
    [self stopLoading];
    self.isShowLoding = NO;
}



@end
