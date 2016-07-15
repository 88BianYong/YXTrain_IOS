//
//  YXMineViewController.h
//  TrainApp
//
//  Created by 李五民 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"

@interface YXMineViewController : YXBaseViewController

@property (nonatomic, copy) void(^nameModifySuccess)(NSString *name);
@property (nonatomic, copy) void(^userPicModifySuccess)(NSString *image);
@property (nonatomic, copy) void(^schoolModifySuccess)(NSString *school);

@end
