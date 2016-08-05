//
//  YXVideoRecordBottomView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXVideoRecordBottomView : UIView
@property (nonatomic, assign) YXVideoRecordStatus  videoRecordStatus;
@property (nonatomic, copy) void(^recordHandler)(YXVideoRecordStatus recordStatus);
@end
