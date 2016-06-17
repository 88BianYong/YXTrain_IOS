//
//  YXBaseViewController.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXBaseViewController : UIViewController

// 提示
- (void)startLoading;
- (void)stopLoading;
- (void)showToast:(NSString *)text;

@end
