//
//  YXProjectMainViewController.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"

@interface YXProjectMainViewController : YXBaseViewController
@property (nonatomic,strong ) UIViewController<YXTrackPageDataProtocol> *selectedViewController;
- (void)showChangeProjectGuideView;
@end
