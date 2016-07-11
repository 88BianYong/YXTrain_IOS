//
//  YXErrorView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXErrorView : UIView
@property (nonatomic, strong) void(^retryBlock)();
@end
