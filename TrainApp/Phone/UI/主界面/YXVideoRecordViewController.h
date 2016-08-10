//
//  YXVideoRecordViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
@class  YXHomeworkInfoRequestItem_Body;
@interface YXVideoRecordViewController : YXBaseViewController
@property (nonatomic, strong)YXHomeworkInfoRequestItem_Body  *videoModel;
@property (nonatomic ,assign) BOOL isGreaterTenMinute;
@end
