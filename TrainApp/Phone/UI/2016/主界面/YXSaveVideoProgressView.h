//
//  YXSaveVideoProgressView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXSaveVideoProgressView : UIView
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, copy, nonnull) NSString *titleString;
@property (nonatomic, copy, nonnull) void (^closeHandler)(void);

- (void)isShowView:(UIView *__nullable)view;
@end
