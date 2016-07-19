//
//  YXPromtController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXPromtController.h"

@implementation YXPromtController

+ (void)startLoadingInView:(UIView *)view{
    if ([MBProgressHUD HUDForView:view]) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void)stopLoadingInView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)showToast:(NSString *)text inView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

@end
