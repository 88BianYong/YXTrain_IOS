//
//  MasterBriefHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterNoticeBriefScheme.h"
@interface MasterBriefHeaderView_17 :UIView
@property (nonatomic, strong) MasterNoticeBriefScheme *scheme;
@property (nonatomic, copy) void(^masterBriefButtonBlock)(UIButton *sender);
@end
