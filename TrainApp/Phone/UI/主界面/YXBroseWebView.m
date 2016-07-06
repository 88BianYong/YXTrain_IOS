//
//  YXBroseWebView.m
//  TrainApp
//
//  Created by 李五民 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBroseWebView.h"
#import "YXShowWebMenuView.h"

@interface YXBroseWebView ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YXBroseWebView

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleString;
    
    [self setupRightWithTitle:@"菜单"];
    self.webView = [UIWebView new];
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    [self.webView loadRequest:request];
}

- (void)naviRightAction{
    YXShowWebMenuView *menuView = [[YXShowWebMenuView alloc]initWithFrame:self.view.window.bounds];
    menuView.didSeletedItem = ^(NSInteger index) {
        if (index == 0) {
            [self.webView reload];
        }
        if (index == 1) {
            NSURL *requestURL = [[NSURL alloc] initWithString:self.urlString];
            [[UIApplication sharedApplication] openURL:requestURL];
        }
        if (index == 2) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.urlString;
        }
    };
    [self.view.window addSubview:menuView];
}

@end
