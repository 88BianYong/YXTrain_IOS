//
//  YXDrawerController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDrawerController.h"

@implementation YXDrawerController

+ (void)showDrawer{
    MSDynamicsDrawerViewController *drawerVC = [self drawer];
    if (drawerVC.paneState == MSDynamicsDrawerPaneStateClosed) {
        [drawerVC setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:^{
            
        }];
    }
}

+ (void)hideDrawer{
    MSDynamicsDrawerViewController *drawerVC = [self drawer];
    if (drawerVC.paneState != MSDynamicsDrawerPaneStateClosed) {
        [drawerVC setPaneState:MSDynamicsDrawerPaneStateClosed inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:^{
            
        }];
    }
}

+ (MSDynamicsDrawerViewController *)drawer{
    MSDynamicsDrawerViewController *drawerVC = (MSDynamicsDrawerViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([drawerVC isKindOfClass:[MSDynamicsDrawerViewController class]]) {
        return drawerVC;
    }
    return nil;
}

+ (void)enableDrag{
    [[self drawer] setPaneDragRevealEnabled:YES forDirection:MSDynamicsDrawerDirectionLeft];
}

+ (void)disableDrag{
    [[self drawer] setPaneDragRevealEnabled:NO forDirection:MSDynamicsDrawerDirectionLeft];
}

@end
