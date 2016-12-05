//
//  AppDelegate+CMSView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "AppDelegate+CMSView.h"
#import "YXWebViewController.h"
@implementation AppDelegate (CMSView)
- (void)showCMSView {
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
        self.cmsView = [[YXCMSCustomView alloc] init];
        self.cmsView.hidden = YES;
        [self.window addSubview:self.cmsView];
        [self.cmsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        WEAK_SELF
        [[YXCMSManager sharedManager] requestWithType:@"1" completion:^(NSArray *rotates, NSError *error) {
            STRONG_SELF
            if (error || rotates.count <= 0) {
                [self.cmsView removeFromSuperview];
                [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainShowUpdate object:nil];
            }
            else{
                YXRotateListRequestItem_Rotates *rotate = rotates[0];
                [self.cmsView reloadWithModel:rotate];
                WEAK_SELF
                self.cmsView.clickedBlock = ^(YXRotateListRequestItem_Rotates *model) {
                    STRONG_SELF
                    YXWebViewController *webView = [[YXWebViewController alloc] init];
                    webView.urlString = model.typelink;
                    webView.titleString = model.name;
                    [webView setBackBlock:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainShowUpdate object:nil];
                    }];
                    [self.window.rootViewController.navigationController pushViewController:webView animated:YES];
                };
            }
        }];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainShowUpdate object:nil];
    }

}

@end
