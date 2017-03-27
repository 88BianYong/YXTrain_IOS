//
//  VideoClassworkManager.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoClassworkManager : UIControl
@property (nonatomic, assign) BOOL forcequizcorrect;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSMutableArray<__kindof YXFileVideoClassworkItem *> *classworMutableArray;
@property (nonatomic, copy) void(^videoClassworkManagerBlock)(BOOL isPlay, NSInteger seekTo);
- (instancetype)initClassworkRootViewController:(YXBaseViewController *)controller;
- (void)showVideoClassworkView:(NSInteger)playProgress;
@end
