//
//  YXMineHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXMineHeaderView_17 : UITableViewHeaderFooterView
@property (nonatomic, strong) YXUserProfile *userProfile;
@property (nonatomic, copy) void(^mineHeaderUserCompleteBlock)(void);
@end
