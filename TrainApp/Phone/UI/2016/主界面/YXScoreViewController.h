//
//  YXScoreViewController.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXExamineRequest.h"
@interface YXScoreViewController : YXBaseViewController
@property (nonatomic, strong) YXExamineRequestItem_body *data;
@property (nonatomic,strong) UIView *waveView;
@end
