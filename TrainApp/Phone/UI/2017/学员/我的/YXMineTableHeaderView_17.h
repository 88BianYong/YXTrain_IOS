//
//  YXMineTableHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2018/3/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXMineTableHeaderView_17 : UIView
@property (nonatomic, strong) YXUserProfile *userProfile;
@property (nonatomic, copy) void(^mineHeaderUserCompleteBlock)(void);
@end
