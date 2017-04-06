//
//  DeYangExamViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "DeYangExamViewController.h"
#import "MJRefresh.h"
static  NSString *const trackPageName = @"考核页面";

@interface DeYangExamViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL isShowLoding;
@property (nonatomic,assign) BOOL  isSelected;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@end

@implementation DeYangExamViewController

- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
    [self.timer invalidate];
    [self.header free];
    
    self.timer = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isSelected) {
        [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isSelected) {
        [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelected = YES;
    self.isShowLoding = YES;
    self.urlString = [NSString stringWithFormat:@"http://i.yanxiu.com/uft/train/mobile/projectstat.vm?projectid=%@&token=%@",[YXTrainManager sharedInstance].currentProject.pid,[YXUserManager sharedManager].userModel.token];
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
    self.header = [MJRefreshHeaderView header];
    WEAK_SELF
    self.header.scrollView = self.webView.scrollView;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        self.isShowLoding = NO;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]];
    };
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    [self.header endRefreshing];
    [self stopLoading];
    [self.errorView removeFromSuperview];
    self.errorView = nil;
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
- (void)report:(BOOL)status{
    if (status) {
        self.isSelected = YES;
    }else{
        self.isSelected = NO;
    }
    [YXDataStatisticsManger trackPage:trackPageName withStatus:status];
}

@end
