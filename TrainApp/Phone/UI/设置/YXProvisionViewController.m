//
//  YXProvisionViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXProvisionViewController.h"

@interface YXProvisionViewController ()
<
  UIWebViewDelegate
>
{
    UIWebView *_webView;
}
@end

@implementation YXProvisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.yanxiu.com/common/agreement.html"]]];
    [_webView setScalesPageToFit:YES];
    [self.view addSubview:_webView];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self startLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self stopLoading];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self stopLoading];
}
@end
