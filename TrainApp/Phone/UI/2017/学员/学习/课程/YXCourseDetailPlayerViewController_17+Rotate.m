//
//  YXCourseDetailPlayerViewController_17+Rotate.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXCourseDetailPlayerViewController_17+Rotate.h"
#import "AppDelegate.h"
@implementation YXCourseDetailPlayerViewController_17 (Rotate)
- (void)naviLeftAction{
    UIInterfaceOrientation screenDirection = [UIApplication sharedApplication].statusBarOrientation;
    if(screenDirection == UIInterfaceOrientationLandscapeLeft || screenDirection ==UIInterfaceOrientationLandscapeRight){
        [self rotateScreenAction];
    }else{
        [self recordPlayerDuration];
        SAFE_CALL(self.exitDelegate, browserExit);
        [self.playMangerView playVideoClear];
        if (self.fromWhere == VideoCourseFromWhere_QRCode) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.appDelegateHelper.courseId = nil;
            appDelegate.appDelegateHelper.projectId = nil;
            appDelegate.appDelegateHelper.seg = nil;
            [LSTSharedInstance sharedInstance].floatingViewManager.loginStatus = PopUpFloatingLoginStatus_Default;
            [[LSTSharedInstance sharedInstance].floatingViewManager startPopUpFloatingView];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)rotateScreenAction {
    UIInterfaceOrientation screenDirection = [UIApplication sharedApplication].statusBarOrientation;
    if(screenDirection == UIInterfaceOrientationLandscapeLeft || screenDirection ==UIInterfaceOrientationLandscapeRight){
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }else{
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    }
}
- (void)remakeForFullSize {
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.playMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
//
//        return ;
//        if (@available (iOS 11.0, *)) {
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//        }else {
//            make.edges.equalTo(self.view);
//        }
    }];
    self.isFullscreen = YES;
    [self.view layoutIfNeeded];
}
- (void)remakeForHalfSize {
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.playMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(self.playMangerView.mas_width).multipliedBy(9.0 / 16.0).priority(999);
    }];
    self.isFullscreen = NO;
    [self.view layoutIfNeeded];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if (size.width > size.height) {
        [self remakeForFullSize];
    }else{
        [self remakeForHalfSize];
    }
}
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end
