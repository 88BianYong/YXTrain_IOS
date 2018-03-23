//
//  YXHomeworkInfoViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXHomeworkInfoRequest.h"
@interface YXHomeworkInfoViewController : YXBaseViewController
@property (nonatomic ,strong) YXHomeworkInfoRequestItem_Body *itemBody;
@property (nonatomic ,copy) void(^requestSuccessBlock)(void);
@end
