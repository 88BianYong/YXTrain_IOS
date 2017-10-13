//
//  YXErrorView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXErrorView : UIView
@property (nonatomic, strong) void(^retryBlock)(void);
//半屏视频界面专用
@property (nonatomic, assign) BOOL isVideo;
@end
