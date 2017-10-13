//
//  VideoCommentErrorView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXErrorView.h"

@interface VideoCommentErrorView : UIView
@property (nonatomic, strong) void(^retryBlock)(void);
@end
