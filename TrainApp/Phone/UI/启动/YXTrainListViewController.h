//
//  YXTrainListViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 2018/4/25.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"

@interface YXTrainListViewController : YXBaseViewController
@property (nonatomic, assign) BOOL isLoginChooseBool;//是否是第一次登录选择
@property (nonatomic, copy) void(^reloadChooseTrainListBlock)(void);
@end
