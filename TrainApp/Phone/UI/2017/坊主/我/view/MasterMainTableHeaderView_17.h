//
//  MasterMainTableHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterMainTableHeaderView_17 : UIView
@property (nonatomic, strong) YXUserProfile *userProfile;
@property (nonatomic, copy) void(^masterMainUserCompleteBlock)(void);
@end
