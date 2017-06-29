//
//  VideoClassworkManager.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoClassworkView.h"
static const NSInteger VideoClassworkQuizzesTime = 16;
static const NSInteger VideoClassworkTriggerTime = 5;
@interface VideoClassworkManager : UIControl
@property (nonatomic, assign) BOOL forcequizcorrect;
@property (nonatomic, assign) NSInteger quizzesInteger;//控制请求时机避免重复请求
@property (nonatomic, strong) VideoClassworkView *clossworkView;

@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSMutableArray<__kindof YXFileVideoClassworkItem *> *classworkMutableArray;
@property (nonatomic, copy) void(^videoClassworkManagerBlock)(BOOL isPlay, NSInteger playTime);

- (instancetype)initClassworkRootViewController:(UIViewController *)controller NS_DESIGNATED_INITIALIZER;
- (void)compareClassworkPlayTime:(NSInteger)playProgress;
- (void)startBatchRequestForVideoQuestions;
- (void)clear;
@end
