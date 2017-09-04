//
//  YXFileHtmlItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileHtmlItem.h"
#import "YXBroseWebView.h"

@implementation YXFileHtmlItem

- (void)openFile {
    [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainDocumentRetryTimer object:@(YES)];
    YXBroseWebView *webView = [[YXBroseWebView alloc] init];
    webView.urlString = self.url;
    webView.titleString = self.name;
    webView.exitDelegate = self;
    webView.browseTimeDelegate = self;
    [self.baseViewController.navigationController pushViewController:webView animated:YES];
}

@end
