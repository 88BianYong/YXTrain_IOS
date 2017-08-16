//
//  YXPlayerBeginningView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXPlayerBeginningView : UIView
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) BOOL isFullscreen;


@property (nonatomic, copy) void (^playerBeginningBackActionBlock)(void);
@property (nonatomic, copy) void (^playerBeginningRotateActionBlock)(void);
@property (nonatomic, copy) void (^playerBeginningFinishActionBlock)(BOOL isSave);

- (void)playVideoClear;
@end
